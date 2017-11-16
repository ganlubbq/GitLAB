classdef EMD
    % EMD: Realtime empirical mode decomposition object.
    % Typical Usage:
    %
    % data_source = Buffer()
    % emd = EMD ( data_source );
    % forever:
    %     data_source.Update (  get some new data );
    %     emd.Update()
    %     (Do something with the calculated IMFs.)
    % end loop
    %
    % Simple!
    
    properties (GetAccess = public, SetAccess = private) % Look, don't touch
        % The data source can be any object that implements a
        % Get_Data(n_start,n_end) method, where n_start and n_end are timestamps
        % (i.e. "Number of samples since beginning of stream.") . This will
        % usually be a Buffer object, but feel free to implement your own.
        Data_Source = 0;
        
        % Array of handles to child IMF objects.
        IMFs;
        
        config;
    end
    
    methods
        % Constructor.
        % Parameters which control number of IMF's extracted:
        %   * 'MaxIMFs', K - extract up to K IMFs.
        %   * 'NumIMFs', K - extract exactly K IMFs. (This is the default, K = 4)
        %   * 'NewIMFTolerance', epsilon - set the threshold the last residue
        %     must exceed to justify calculation of an additional IMF. Only
        %     useful in conjunction with the 'MaxIMFs' setting.
        %
        % Sifting algorithm control parameters
        %   * 'SiftingIterations', k - force all IMF calculations to use exactly
        %     k sifting iterations. (Default: 10.)
        function this = EMD ( data_source, config )
            this.Data_Source = data_source; % check if buffer
            
            % Initialise array of IMF handles.
            this.IMFs = IMF();
            
            if (~exist('config','var') )
                %Make a deep copy of the config containers.Map object. (It's a
                %handle object, so this.config = config only copies the handle.
                this.config = EMD_Default_Config();
            else
                this.config = [ config; containers.Map() ];
            end
            
            % Create a bunch of chained IMF objects, each taking the residue
            % fothe last as its input. (Except the first one, of course, which
            % takes the data source as its input.)
            for n = 1:this.config('EMD:NUMBER_OF_IMFS')
                if ( n == 1 ) h = this.Data_Source;
                         else h = this.IMFs(n-1);   end
                this.IMFs(n) = IMF(h,n);
            end
        end
        
        % Function for updating the IMF's. If there is any new data in the
        % Data_Source, it is used by:
        % 1) Calling each IMF object's Update() function in turn.
        % 2) Calling Assess_New_IMF_P() to decide if another IMF should be
        %    extracted from the last IMF's residue.
        % 3) Return "status", telling how many new bits of IMF have been
        %    calculated.
        function status = Update(this)
            for n = 1:numel(this.IMFs)
                this.IMFs(n).Update();
            end
            status = 0;
        end
        
        % Function for extracting part of one IMF.
        data = Slice_IMF ( this, IMF_number, n_start, n_end );
        
        % Function for extracting a cross-section of particular IMF's.
        data = Slice_IMFs ( this, IMF_numbers, n_start, n_end );
        
        % Function for extracting a cross section of all IMF's.
        function data = Slice_all_IMFs (this, IMF_numbers, n_start, n_end )
            try
                data = Slice_IMFs ( 1:numel(this.IMFs), n_start, n_end );
            catch exception % Possible failure if one of the IMF's is out of bounds.
                error('lwsEMD:EMD:IndexOutOfBounds', [...
                    'You requested IMF data that was out of bounds - i.e. data that has not been calculated yet, or old data that has been pushed out of memory.\n' ...
                    'Details: n_start = %i, n_end = %i.'] ,...
                    n_start, n_end);
            end
        end;
        
        % Function for retrieving all IMF data in a cell array (one IMF per
        % cell.)
        function data = Get_Entire_Set_of_IMFs (this)
            num_IMFs = numel(this.IMFs);
            data = cell(num_IMFs,1);          
            for n = 1:num_IMFs
                imf = this.IMFs(n);
                if (imf.Latest == 0);
                    data{n} = []; % No data in that IMF yet.
                else
                    data{n} = imf.GetMode(imf.Earliest,imf.Latest);
                end
            end 
        end
        
        % Function for extracting a slice of an IMF's residue.
        data = Slice_Residue ( this, IMF_number, n_start, n_end );
        
        % Decide if the residue from the previous IMF is large enough to warrant
        % extracting another IMF from.
        Assess_New_IMF_P ( this );
    end
    
end



