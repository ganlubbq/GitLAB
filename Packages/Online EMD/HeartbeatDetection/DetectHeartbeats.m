function peaktimes = DetectHeartbeats (xd, xs)
    % function peaktimes = DetectHeartbeats (xd, xs)
    % Input: handles to xd and xs, which contain data.
    % 
    % Processing happens incrementally, to whatever new data has been added to
    % those buffers since the last time DetectHeartbeats was called.
    %
    % Sidenote: xd and xs are handle objects, which means they are "passed by
    % reference" and no giant, slow copy operations occur. Phew.
    %
    % This function uses persistent variables. Ensure you call 'clear functions'
    % to clear the persistent variables before using for the first time.
    
    persistent last_n_seen rising_edges falling_edges last_state;
    if ( isempty(last_n_seen) )
        last_n_seen = 0;
        rising_edges = [];
        falling_edges = [];
        peaktimes = [];
        last_state = 0;
    end

%     xd_orig = xd;
    
    common = Buffer.CommonSection([xd,xs]);
    new_n = common.n_latest - last_n_seen;

    if ( new_n <= 0 )
%         fprintf('[LOG %s] HeartbeatDetect(): You called me, but there was no new data for me to analyze\n', datestr(now,'HH:MM:SS:FFF'))
        % No new data, or buffers haven't caught up to real time yet. (Takes
        % about a second for data to propagate through the buffers.
        peaktimes = [];
        return;
    end
    
%     fprintf('[LOG %s] HeartbeatDetect(): I last saw data sample #%i. Now analysing up to #%i.\n', datestr(now,'HH:MM:SS:FFF'), last_n_seen, common.n_latest)

    
    %% Find the locations where the signal rises above 2x the moving average, and
    % falls below 1x the moving average. (These rising and falling edges define
    % the search areas for peak detection.)
    
    % Get NEW parts of signal. I repeat: the parts we **HAVEN'T SEEN YET.**
    % (there was a nasty bug here where I just got all the common.data{} ...
    % It's been too long since i slept!
    sig = xd.Get(last_n_seen,common.n_latest);
    avg = xs.Get(last_n_seen,common.n_latest);
    
    for n = 1:numel(sig)
        % Compute current signal state:
        %  0 - indeterminate (haven't encountered any kind of edge yet)
        %  1 - signal exceeded 2x moving average. In 'peak detection region'.
        % -1 - signal went below 1x moving average. Between 'peak detection
        %      regions'.
        if ( sig(n) > 2*avg(n) )
            new_state = 1;
        elseif ( sig(n) < avg(n) )
            new_state = -1;
        else
            new_state = last_state;
        end
        
        % Determine if a transition between states has occured. Remember that 0
        % is the 'indeterminate' state.
        if ( (new_state == 1) && (last_state == -1) ) % rising edge
            rising_edges = [rising_edges n+last_n_seen-1];
        elseif ( (new_state == -1) && (last_state == 1) ) %falling edge
             if (~isempty(rising_edges)) % prevent adding a falling edge without a corresponding rising edge. This causes the 'bounds reversed' bug (see below.)
                falling_edges = [falling_edges n+last_n_seen-1];
             end
        end
        
        % Don't forget this, or it will cause exciting bugs. Silly.
        last_state = new_state;
    end
    
    %% Process all pairs of rising and falling edges.
    peaktimes = [];
    while ( ~isempty(rising_edges) && ~isempty(falling_edges) )
        % Define search region bounds.
        search_region_start = rising_edges(1);
        search_region_end = falling_edges(1);
        
        % Check sanity of bounds.
        assert( search_region_start < search_region_end, 'DetectHeartbeats() : search region makes no sense - search bounds are reversed.' );
        assert( search_region_end <= common.n_latest, 'DetectHeartbeats() : Trying to use data which doesn''t exist yet.');

        % Extract data and find peak location.
        [~, max_index] = max ( xd.Get(search_region_start, search_region_end) );
        new_peaktime = max_index + search_region_start - 1;
        peaktimes = [peaktimes new_peaktime]; %#ok<AGROW>
        
        % Remove used edges from list. 
        rising_edges(1)  = []; 
        falling_edges(1) = [];
    end
    last_n_seen = common.n_latest;
    return; %return peaktimes
end
    