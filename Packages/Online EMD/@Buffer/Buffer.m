classdef Buffer < handle
    properties (Access=private)
        % Metadata...
        fs = 1000;              % (original) sampling frequency of data in buffer.
        decimation = 1;         % Decimation factor of data in buffer.
        len = 1000;             % Number of samples in buffer
        
        % Filtering
        filter_p = false;       % True if filtering the input before adding to buffer.
        filter = false;         % If filter_p is true, a mfilt or dfilt object.
        delay = 0;              % "Group delay" of filter in samples, if any.
        
        % State
        data = zeros(1,1000);
        n_latest = 0;
        n_earliest = -999;
    end
    methods
        function b = Buffer(fs,decimation,len,filter,delay)
            % Constructor.
            % @param fs:
            %       Sampling frequency of buffer (after any decimation)
            % @param decimation:
            %        Decimation rate.
            % @param len :
            %        Number of samples stored in buffer.
            % @param filter :
            %        Either a dfilt or mfilt object that will be applied to all
            %        incoming data, or the string "No filter".
            % @param delay :
            %        Number of seconds 'group delay' between input and output.
            %        Example: a buffer that filters with a 100-sample moving
            %        average will have delay 50.
            b.decimation = decimation;
            b.len = len;
            b.data = zeros(1,len);
            
            % Note the use of copy() - mfilt and dfilt are handle classes,
            % which means that the syntax filter_a = filter_b only copies the handle,
            % not the actual object.
            if ischar(filter)
                assert( true == strcmp(filter, 'No filter'), 'filter argument must be mfilt object, dfilt object, or ''No filter''.' );
                b.filter_p = false;
                b.filter = false;
            else
                b.filter_p = true;
                b.filter = copy (filter);
            end
            
            delay_samples = round(delay * fs / decimation);
            
            b.delay = delay_samples;
            b.n_latest = -delay_samples;
            b.n_earliest = -delay_samples - len + 1;
        end
        
        function Update(this,data)
            % Buffer.Update(data) : push data into buffer. If the buffer has a
            % filter, the incoming will be filtered through it before pushing
            % into the buffer.
            %
            % Postconditions:
            % ---------------
            %   * New data is filtered (if applicable) and pushed onto the right
            %     side of the data array. Old data 'falls off' the left.
            %   * The counters n_earliest and n_latest are incremented by the
            %     number of new samples in the buffer (counted *after*
            %     downsampling.)
            %
            % Behaviour under error conditions:
            % ---------------------------------
            %   * If you try to push more data into the buffer than it can
            %     handle at once, an exception is thrown.
            %   * argument data must be a vector, or an exception will be thrown.
            %
            %
            
            assert(isvector(data),'Buffer.Update(): data argument must be a vector.');
            if this.filter_p
                processed_data = filter(this.filter,data);
            else
                processed_data = data;
            end
            n_out = numel(processed_data);  % Count number of new samples to put into buffer.
            assert( n_out < this.len, 'Buffer.NewData(): Too much data to fit into the buffer. Feed me smaller chunks of data at a time.' );
            
            % Put new data into right hand side of buffer. Old data 'falls off
            % the left'.
            this.data = [ this.data( n_out+1 : end ) processed_data ];
            assert ( numel(this.data) == this.len, 'Bug: Buffer.NewData(): Buffer length has changed from what it should be.');
            
            % Update time counters
            this.n_latest   = this.n_latest + n_out;
            this.n_earliest = this.n_earliest + n_out;
        end
        
        function data = Get(this, n_start, n_end)
            % Retrieves the buffer data corresponding to the (real) time span
            % n_start:n_end.
            %
            % If you specify n_end = 'end', it does what you expect.
            %
            % If n_end is not specified, then it is assumed you want the single
            % sample from time n_start.
            %
            % Example: Buffer contains data from real-time 1001:2000, and we
            % want 1100:1200. Get(1100,1200) returns this.data(100:200).
            
            % If n_end was not specified, assume only one sample is wanted.
            assert ( exist('n_start','var') == true, 'Buffer.Get() : Must give n_start.');
            if ( ~exist('n_end') )
                n_end = n_start;
            elseif ( strcmp(n_end,'end') )
                n_end = this.n_latest;
            end;
            
            % Sanity check arguments.
            assert ( n_start <= n_end, 'Buffer.Get() : are your n_start and n_end the right way around?' );
            assert ( n_start >= this.n_earliest, 'Buffer.Get() : Asking for data that has fallen out of the buffer''s history.' );
            assert ( n_end <= this.n_latest, 'Buffer.Get() : Asking for data this buffer does not contain yet.');
            
            % Retrieve data
            array_index_start = n_start-this.n_earliest+1;
            array_index_end = this.len+n_end-this.n_latest;
            data = this.data( array_index_start : array_index_end );
            
            % Debugging: Check that the number of output elements is sane.
            if ( n_end == n_start )
                assert ( numel(data) == 1 );
            elseif (n_end ~= n_start)
                assert ( numel(data) == n_end - n_start + 1, sprintf('Buffer.Get(): Output array wrong size! Debug info:\n wanted realtime %i : %i \n buffer currently stores %i : %i \n calculated array indices %i : %i', n_start, n_end, this.n_earliest, this.n_latest, array_index_start, array_index_end));
            end
        end
        
        function Plot(this,style,multiplier)
            if (~exist('multiplier'))
                multiplier = 1;
            end
            t = this.n_earliest:this.n_latest;
            plot (t,this.data*multiplier,style);
        end
        
        function n = Latest(this)
            n = this.n_latest;
        end
        
        function n = Earliest(this)
            n = this.n_earliest;
        end
    end
    
    % Note to self: generalise to N buffers instead of two.
    methods (Static = true)
        % Returns the 'common section' between B1 and B2. (i.e. the parts that overlap in time.)
        % Return is in a struct.
        function common = CommonSection ( h )
            % h is a list of handles to Buffer objects.
            assert( nargin == 1, 'Buffer.CommonSection takes exactly one argument: an array of Buffer handles.');
            assert( isa(h,'Buffer'), 'Passed non-buffer object to Buffer.CommonSection2()!');
            assert ( ~any(diff( [ h.decimation ] )), 'Buffer.Commonsection2() - all buffers must have same decimation!');
            assert ( ~any(diff( [ h.fs ] )), 'Buffer.Commonsection2() - all buffers must have same sampling frequency!');
            
            common.decimation = h(1).decimation;
            common.fs = h(1).fs;
            
            numbufs = numel(h);
            
            common.n_earliest = max ( [h.n_earliest 0] );      % Earliest, or 0 if negative.
            common.n_latest   = max ([ 0, min([h.n_latest]) ]);  % Latest, or 0 if negative.
            common_n = common.n_latest - common.n_earliest;
            
            % Preallocate cell array of empty arrays.
            common.data = cell(numbufs,1);
            
            % Return early if no data to insert.
            if (common_n == 0)
                return;
            end
            
            % Grab the appropriate sections of data from each input buffer.
            for bufnum = 1:numbufs
                common.data{bufnum} = h(bufnum).Get(common.n_earliest,common.n_latest);
            end
            return;
        end
    end
end