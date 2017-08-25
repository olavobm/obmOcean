function ctdtab = ctd2table(id, P, T, S, time, lon, lat)
% ctdtab = CTD2TABLE(id, P, T, S, time, lon, lat)
%
%   inputs
%       - id: string with the identification of the data.
%       - p: pressure (in dbar).
%       - t: temperature 
%       - s: salinity
%       - time: 
%       - lon: longitude
%       - lat: latitude
%
%   outputs
%       - ctdtab: a Matlab table with all the data.
%
% CTD2TABLE creates a variable of class table from CTD data. Note this
% format is a more natural way to subset the data in any of the variables
% or manipulate the dataset as a whole.
% 
% Input id must be one string that identifies all the data in the other
% inputs. These should be double arrays (vectors or matrices). Except for
% lon and lat, the data arrays must have the same size.
%
% Lon and lat may also be one value (for each), in which case they are
% copied for all the other data points.
%
% MAYBE TO DO:
%       - include varargin for other variables (such as O2).
%
% Olavo Badaro Marques, 27/Jul/2017.


%% Turn all variables into column vectors and get length of them

%
P = P(:);
T = T(:);
S = S(:);

time = time(:);
lon = lon(:);
lat = lat(:);

%
N = length(P);


%% Get length of lon/lat and adjust size appropriately

%
llon1 = (length(lon)==1);
llat1 = (length(lat)==1);
if llon1 && llat1
    lon = repmat(lon, N, 1);
    lat = repmat(lat, N, 1);
elseif ~llon1 && ~llat1
else
    error('Number of longitudes is different than latitudes.')
end


%% Transform ID into cell array and create table

%
ID = cell(N, 1);
ID(:) = {id};

%
ctdtab = table(ID, P, T, S, time, lon, lat);


