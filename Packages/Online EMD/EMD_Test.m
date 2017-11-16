function run_times = EMD_Test (...
    test_name, ......... String. Name of test, used in output only.
    input_filename, .... Path to a .mat file containing the test input signal, in a vector variable named 'raw_data'.
    input_length, ...... Number of samples of raw_data which will be fed to the input.
    repeat_count, ......
    EMD_config, ........ [optional] A containers.Map containing the configuration settings for the EMD object. If argument is not given, EMD_Default_Config() is used instead. See that files for documentation on the required format.
    output_directory, ... WARNING: IF FOLDER EXISTS, IT WILL BE DELETED. (You have backups, right?)
    plot_params...
    )

%% Process arguments.
% Load input file and check sanity.
S = load(input_filename);
assert( isfield(S,'raw_data'), 'InputFileError', 'input_filename did not point to an appropriate input file. Appropriate input files must contain a vector of data called ''raw_data''.');
assert( isvector(S.raw_data), 'InputFileError', 'input_filename did not point to an appropriate input file. Appropriate input files must contain a vector of data called ''raw_data''.');

raw_data_length = length(S.raw_data);
assert( raw_data_length >= input_length, 'InputFileError', 'You asked to test with the first %i samples from input file %s, but there isn''t that much data in the file.', input_length, input_filename);

% Input sanity check.
assert ( (repeat_count >= 1), 'Repeat count must be an integer greater than 0.');

% Load default config if none was given.
if (~exist('EMD_config','var'))
    EMD_config = EMD_Default_Config();
end

% If output directory exists, delete it.
% WARNING: DELETES ALL FOLDER CONTENTS.
try
    rmdir(output_directory,'s')
end

% Create output directory.
mkdir(output_directory);

%% Prepare for test runs
blocksize = EMD_config('TESTING:BLOCK_SIZE');
num_blocks = floor( input_length / blocksize );

buffer_fs     = EMD_config('TESTING:BUFFER:SAMPLING_FREQUENCY');
buffer_decim  = EMD_config('TESTING:BUFFER:DECIMATION_RATE');
buffer_length = EMD_config('TESTING:BUFFER:HISTORY_LENGTH');
buffer_filter = EMD_config('TESTING:BUFFER:FILTER');
buffer_delay  = EMD_config('TESTING:BUFFER:PROPAGATION_DELAY');

run_times = zeros(1,repeat_count);
errors_encountered = false;


Open_Log();

%% Begin testing.
fprintf('\n\n---- TEST RUNS BEGIN. ----\n\n');
for run_number = 1:repeat_count
    try % Wrap each test in a try-catch so we can attempt to continue if a test run produces errors.
        fprintf('\n\nBeginning run #%i of test %s.\n', run_number, test_name);
        try
            clear EMD_Object;KK
            clear data_buffer;
        end
        
        data_buffer = Buffer(buffer_fs, buffer_decim, buffer_length, buffer_filter, buffer_delay);
        emd_object = EMD(data_buffer, EMD_config);
        
        start_time = tic();
        for n = 1:num_blocks
            new_data_block = S.raw_data( ((n-1)*blocksize)+1 : n*blocksize ); % i.e. for blocksize = 50, new data block will be elements 1:50, then 51-100, then...
            data_buffer.Update(new_data_block);
            emd_object.Update();
        end
        run_times (run_number) = toc(start_time);
        fprintf('Successful run #%i of test %s in %f seconds.\n',run_number, test_name, run_times(run_number) );
    catch exception
        fprintf('Error encountered during run #%i of test %s. Aborting. Attempting to continue gracefully.', run_number, test_name);
        exception
        errors_encountered = true;
        run_times(run_number) = NaN;
    end
end

%% Output stage.
fprintf('\n\n---- TEST RUNS END. ----\n\n');

Print_Test_Time_Statistics();
Make_Plot()
save( [output_directory '/data.mat'] ); % Save complete program state to .mat file. (Results wil be absolutely reproducible.)

diary off;

%% Worker functions.
    function Open_Log()
        %% Begin log output.
        output_diary_filename = [ output_directory '/log.txt' ];
        diary (output_diary_filename);
        fprintf('This is EMD_Test(), running with input parameters as follows:\n\n');
        test_name
        input_filename
        input_length
        repeat_count
        output_directory
        
        fprintf('\n\n--\n\nThe EMD_config values were as follows:\n');
        k = EMD_config.keys();
        v = EMD_config.values();
        for n = 1:length(EMD_config)
            fprintf('\n--\n');
            disp (k{n})
            disp (v{n})
        end
        fprintf('\n--\n');
    end
    function Print_Test_Time_Statistics()
        fprintf('\nTest run times, in seconds:\n');
        for n = 1:numel(run_times)
            fprintf('          %9.6f\n',run_times(n));
        end
        fprintf    ('--------------------------------------\n');
        fprintf    ('AVERAGE  :%9.6f\n',mean(run_times));
        fprintf    ('STD DEV  :%9.6f\n',std(run_times));
        fprintf    ('STD_DEV%% :%9.3f %%\n',std(run_times)/mean(run_times)*100);
    end
    function Make_Plot()
        if ( ~exist('plot_params') );
            return
        elseif (plot_params.PlotP == false);
            return
        end
        
        num_IMFs = numel(emd_object.IMFs);
        num_subplots = num_IMFs + 1;
        
        figure_handle = figure;
        axis_handles = [];
        
        axis_handles(end+1) = subplot(num_subplots,1,1);
        plot( S.raw_data(1:input_length) );
        ylabel('Original signal.');
        
        IMFs_Cellarray = emd_object.Get_Entire_Set_of_IMFs();
        for n = 1:num_IMFs
            axis_handles(end+1) = subplot(num_subplots,1,n+1);
            plot(IMFs_Cellarray{n});
            ylabel(sprintf('IMF #%i',n));
        end
        
        for h = axis_handles
            set(h,'XLim',plot_params.XLim,'YLim',plot_params.YLim);
        end
        
        saveas2(...
            [output_directory '/IMFs.pdf'],...
            150,...
            'pdf'...
            );
        
        pause (1);
        close ( figure_handle );
    end
end




























