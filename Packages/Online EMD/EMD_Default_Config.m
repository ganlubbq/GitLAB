function config = EMD_Default_Config()
config = containers.Map;

%% Testing configuration options.
config('TESTING:BLOCK_SIZE') = 2000;

% See Buffer class for explanations of these options.
config('TESTING:BUFFER:SAMPLING_FREQUENCY') = 22050; % 22.050 kHz. No effect in practice.
config('TESTING:BUFFER:DECIMATION_RATE') = 1;        % Decimation rate. 1 = no decimation.
config('TESTING:BUFFER:HISTORY_LENGTH') = 22050*10;  % Number of samples retained in buffer.
config('TESTING:BUFFER:FILTER') = 'No filter';       % Do not apply any digital filtering to bufffer data.
config('TESTING:BUFFER:PROPAGATION_DELAY') = 0;      % No delay between buffer input and output.

%% EMD configuration options.
% Number of IMFs to extract from input data stream.
config('EMD:NUMBER_OF_IMFS') = 5;

%% IMF configuration options.
% Number of sifting iterations applied to each block of IMF.
config('IMF:SIFT_BLOCK:NUM_SIFTING_ITERATIONS') = 10;

% Controls amount of historical data included in each IMF block calculation.
config('IMF:SIFT_BLOCK:NUM_EXTREMA_PRECEDING') = 10;

% Controls how much of the right of each block is thrown away to guard against
% end effects.
config('IMF:SIFT_BLOCK:NUM_RIGHT_TRIM_EXTR') = 3;

% Turns mirrorising of extrema on or off. Default on, which theoretically
% reduces end effects.
config('IMF:SIFT_BLOCK:MIRRORISE_EXTREMA') = true;

% Valid choices are:
% 'Hermite' -> hermite_spline()
% 'PCHIP' -> MATLAB's pchip()
% 'Cubic' -> MATLAB's spline().
config('IMF:SIFT_BLOCK:ENVELOPE_INTERPOLATION_METHOD') = 'Hermite'; % Other valid choices: 'PCHIP', 'Cubic'

%% Debug options.
% Debug options which modify the behaviour of the program.
config('IMF:SIFT_BLOCK:DEBUG:USE_ALL_HISTORIC_DATA') = false;

% Debug output options - for displaying pretty graphs.
config('IMF:SIFT_BLOCK:DEBUG:DISPLAY_EACH_SIFTING_ITERATION') = false;
config('IMF:SIFT_BLOCK:DEBUG:DISPLAY_BLOCK_OVERLAP_DIAGNOSTIC') = false;
config('IMF:SIFT_BLOCK:DEBUG:DISPLAY_EACH_BLOCK') = false;

config('IMF:SIFT_BLOCK:DEBUG:PROGRESS_OUTPUT') = false; % Print 'Running sifting...' messages.

end

