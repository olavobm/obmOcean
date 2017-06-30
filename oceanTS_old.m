classdef oceanTS
    % Class OCEANTS to deal with temperature/salinity data in the ocean.
    %
    % TO DO: Replace the data matrix by a table and use the
    %        relevant operations.
    %
    % Olavo Badaro Marques, 30/Jun/2017.
    
    
    %% Properties of the object
    
    properties
        data
    end
    
    properties
        operlims
    end
    
    
    %% Define methods

    methods

        %%
        function obj = oceanTS(p, t, s, time, lon, lat)
        
            %
            if nargin==0
                ocean.data = NaN(0, 6);
            end

            % Turn data into column vectors:
            p = p(:);
            t = t(:);
            s = s(:);
            time = time(:);
            lon = lon(:);
            lat = lat(:);
            
            N = length(p);
            
            %
            llon1 = length(lon)==1;
            llat1 = length(lat)==1;
            if llon1 && llat1
                lon = repmat(lon, N, 1);
                lat = repmat(lat, N, 1);
            else
                error('')
            end
            
            % -------------------------------------------------------------
            % ---------------- DISREGARD NANs!!!!!!! ----------------
            % -------------------------------------------------------------
            
            %
            obj.data = [p, t, s, time, lon, lat];
            
            %
            obj.operlims = [-Inf(1,6); Inf(1,6)];
            
        end
        
        
        %%
        function obj = add(obj, p, t, s, time, lon, lat)
            obj.data = [obj.data; oceanTS(p, t, s, time, lon, lat).data];
        end

        %%
        function varcolind = indcol(~, varstr)
            colcode.pressure = 1;
            colcode.temperature = 2;
            colcode.salinity = 3;
            colcode.time = 4;
            colcode.longitude = 5;
            colcode.latitude = 6;
            
            varcolind = colcode.(varstr);
        end
        
        
        %%
        function obj = setAllLims(obj, alllims)
            % obj = SETALLLIMS(obj, alllims)
            %
            % alllims must be a 6x2 array, where each row has the lower
            % ans upper limit of the correspondent variable. If alllims
            % is not given, set the default limits (infinity).
            
            %
            if ~exist('alllims', 'var')
                alllims = [-Inf(1,6); Inf(1,6)];
            end
            
            %
            obj.operlims(1:2, 1:6) = alllims';
            
        end
        
        
        %%
        function obj = setlims(obj, ab, varstr)
            
            %
            obj.operlims(:, obj.indcol(varstr)) = [ab(1); ab(2)];
        end
        
        
        %%
        function lmatch = inlims(obj)
            
            N = size(obj.data, 1);
            
            lmatch = true(N, 1);
            
            %
            for i = 1:6
                lmatch = lmatch & (obj.data(:, i) >= obj.operlims(1, i) & ...
                                   obj.data(:, i) <= obj.operlims(2, i));
            end
            
        end
        
        
        %%
        function datavar = extract(obj, varstr)
            
            
            datavar = obj.data(:, );
        end
        
        %%
        function datavar = pressure(obj); datavar = obj.data(:, 1); end
        function datavar = temperature(obj); datavar = obj.data(:, 2); end
        function datavar = salinity(obj); datavar = obj.data(:, 3); end
        function datavar = time(obj); datavar = obj.data(:, 4); end
        function datavar = longitude(obj); datavar = obj.data(:, 5); end
        function datavar = latitude(obj); datavar = obj.data(:, 6); end
    
        


        
        %% ----------------------------------------------------------------
        % -----------------------------------------------------------------
        % -----------------------------------------------------------------
        
        %%
%         function obj = squarelim(obj, xy0, xydist)
%             
%             %
%             
%             
%             %
%             lonlims = [xy0(1)-xydist, xy0(1)+xydist];
%             latlims = [xy0(2)-xydist, xy0(2)+xydist];
%             
%             %
%             obj = setlims(lonlims, 'longitude');
%             obj = setlims(lonlims, 'latitude');
%             
%         end
        

        %%
        
    end
    
end