% Class for online-EMD.
% Copyright 2010, Li-aung "Lewis" Yip (liaung.yip@ieee.org)
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
% http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%

classdef IMF < handle
    properties (Access=private)
        data_source;    % A handle to a Buffer or IMF object.
        % Must support the n_earliest and n_latest properties
        % and the Get() method for extracting time-slices of
        % data.
        source_last_seen; % The time we're up to processing right now.
        
        source_max_v;
        source_max_t;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 ;
        source_min_v;
        source_min_t;
        
    end
    properties (SetAccess = private)        
        mode;           % The IMF itself, range n_earliest:n_latest.
        residue;        % The residue left over after extracting the IMF,
        % same time range as the IMF. The next IMF object in the
        % chain will use this as its data source.
        
        
        len;            % Length of buffer, in samples.
        n_earliest;     % The earliest time for which the IMF/residue have been calculated.
        n_latest;       % The latest time for which the IMF/residue have been calculated.
        
        mode_num;       % optional - the order of this mode. First IMF extracted is mode 1.
        
        config;         % Config struct. Used to set things like number of sifting iterations and so on.
    end
    
    methods
        %% Constructor.
        function t = IMF(data_source, IMF_number, config)
            % IMF(data_source, IMF_number, config) returns a handle to a new IMF
            % object.
            % data_source must be a handle to a Buffer or IMF object.
            % imf_number is an optional argument.
            % config is an optional argument. NOTE: IT IS A HANDLE OBJECT, USE
            % OBJECT COPY.
            
            % Required so arrays of this object can be initialised.
            if ( nargin == 0 )
                return
            end
            
            % Sanity checks.
            assert ( isa(data_source,'Buffer') || isa(data_source,'IMF'), 'Data source must be IMF or Buffer object. See documentation.');
            
            % Initialize properties.
            t.source_max_v = [];
            t.source_max_t = [];
            t.source_min_v = [];
            t.source_min_t = [];
            t.data_source = data_source;
            t.source_last_seen = 1;
            t.n_earliest = 0;
            t.n_latest = 0;
            
            if (~exist('IMF_number'))
                t.mode_num = 0; % default if not provided
            else 
                t.mode_num = IMF_number;
            end
            
            if (~exist('config','var'));
                t.config = EMD_Default_Config();
            else
                assert ( isa(copy,'containers.Map'), 'Config parameter must be a container.Map');
                 % This is a strange syntax for copying container.Map's by value
                 % (as opposed to just copying the handle.) For some reason the
                 % usual copy() function doesn't work.
                t.config = [ config; containers.Map ];
            end
            
            % Assert that the necessary functions exist.
            % For reference: the extr() this talks about is available here:
            %
            %
            assert( exist('extr.m') == 2, 'ERROR: IMF object needs access to function extr() by Gabriel Rilling. Check that you have this on your path.');
        end
        
        %% Update function.
        function Update(this)
            UpdateExtrema(this);
            Sift_Block(this);
            this.source_last_seen = this.data_source.Latest;
        end
        
        
        
        %% Public accessor functions.
        function data_slice = GetMode (this, n_start, n_end )
            assert( this.Earliest <= n_start );
            assert( this.Latest >= n_end );
            
            array_index_start = n_start-this.n_earliest+1;
            array_index_end = array_index_start + (n_end - n_start);
            data_slice = this.mode( array_index_start : array_index_end );
        end
        function data_slice = GetResidue (this, n_start, n_end )
            assert( this.Earliest <= n_start );
            assert( this.Latest >= n_end );
            
            array_index_start = n_start-this.Earliest+1;
            array_index_end = array_index_start + (n_end - n_start);
            data_slice = this.residue( array_index_start : array_index_end );
        end
        function n = Earliest(this)
            n = this.n_earliest; end
        function n = Latest(this)
            n = this.n_latest; end
        function n = ModeNum(this)
            n = this.mode_num; end
        
    end
    methods (Access = private)
        %% Private internal mechanisms.
        Sift_Block(this);
        UpdateExtrema(this);
        
        function data_slice = GetSourceData(this, n_start, n_end )
            assert( isa(this,'Buffer') || isa (this,'IMF') );
            assert( this.data_source.Earliest <= n_start, 'IMF.GetSourceData() Aborting: Requested data that has fallen out of data source''s history.' );
            assert( this.data_source.Latest >= n_end, 'IMF.GetSourceData() Aborting: Requested data that isn''t in the data source''s buffer yet.' );
            
            if ( isa(this.data_source,'Buffer') )
                data_slice = this.data_source.Get(n_start,n_end);
            elseif ( isa(this.data_source,'IMF') )
                data_slice = this.data_source.GetResidue(n_start,n_end);
            end
        end
        
        %% Private accessor functions.
        function SetEarliest(this, newvalue)
            this.n_earliest = newvalue; end
        function SetLatest(this, newvalue)
            this.n_latest = newvalue; end
    end
end