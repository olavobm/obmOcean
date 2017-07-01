classdef oceanTS_old
    % Class OCEANTS_OLD to deal with temperature/salinity data in the ocean.
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
        function obj = oceanTS_old(p, t, s, time, lon, lat)
            
            %
            obj.operlims = [-Inf(1,6); Inf(1,6)];
            
            %
            if nargin==0
                obj.data = NaN(0, 6);
                return
            end

            % Turn data into column vectors
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
            
            % Remove any entry with NaN
            lpNaN = isnan(p);
            ltNaN = isnan(t);
            lsNaN = isnan(s);
            ltimeNaN = isnan(time);
            llonNaN = isnan(lon);
            llatNaN = isnan(lat);
            
            lgood = ~lpNaN & ~ltNaN & ~lsNaN & ~ltimeNaN & ~llonNaN & ~llatNaN;
            
            %
            obj.data = [p(lgood), t(lgood), s(lgood), ...
                        time(lgood), lon(lgood), lat(lgood)];
            
        end
        
        
        %%
        function obj = add(obj, p, t, s, time, lon, lat)
            obj.data = [obj.data; oceanTS_old(p, t, s, time, lon, lat).data];
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
        
        
        %% Extract one column, satisfying all the limits in operlims:
        function datavar = extract(obj, varstr)
            datavar = obj.data(obj.inlims, obj.indcol(varstr));
        end
        
        
        %%
        function datavar = pressure(obj); datavar = obj.extract('pressure'); end
        function datavar = temperature(obj); datavar = obj.extract('temperature'); end
        function datavar = salinity(obj); datavar = obj.extract('salinity'); end
        function datavar = time(obj); datavar = obj.extract('time'); end
        function datavar = longitude(obj); datavar = obj.extract('longitude'); end
        function datavar = latitude(obj); datavar = obj.extract('latitude'); end
    

        %% ----------------------------------------------------------------
        % -----------------------------------------------------------------
        % -----------------------------------------------------------------
        
        %%
        function obj = squarelims(obj, xy0, kmdist)
            %
            % This will give problems in the longitude branch cut.
            
            %
            [distlat, distlon] = km2latlon(kmdist, xy0(2));
            
            %
            lonlims = [xy0(1) - distlon, xy0(1) + distlon];
            latlims = [xy0(2) - distlat, xy0(2) + distlat];
            
            %
            obj = obj.setlims(lonlims, 'longitude');
            obj = obj.setlims(latlims, 'latitude');
            
        end
        

        %%
        
    end
    
end