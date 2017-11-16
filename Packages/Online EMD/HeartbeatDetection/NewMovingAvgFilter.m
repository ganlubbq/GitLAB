function filter_obj = NewMovingAvgFilter ( fs, window, D )
    % filter_obj = NewMovingAvgFilter (fs, window, D)
    % Returns a mfilt decimating filter object that performs a moving average
    % calculation on streaming data.
    %
    % Note that mfilt and dfilt are handle classes, which means that you have to
    % use the copy() function to make a real copy of the filter (instead of just
    % a reference to the existing filter.) See doc mfilt for details.
    %
    % @param fs:
    %       Sampling frequency of filter.
    % @param window:
    %       Moving average window size, in seconds.
    % @param D:
    %       Decimation factor.
    %
    % Li-aung "Lewis" Yip, Sun 29 Aug 2009.
    
    
    % Determine length of smoothing filter. Note: Do not divide by D! TF applies to
    % INPUT data, which is at original sampling rate.
    num_samples = round ( fs * window );

    filter_obj = mfilt.firdecim;
    filter_obj.DecimationFactor = D;
    filter_obj.Numerator = ones(1,num_samples) ./ num_samples; % Create transfer function - rectangular, total area 1.
    filter_obj.persistentmemory = true; % Turn on streaming mode. (See documentation if you don't understand this.)
    
    return;
end