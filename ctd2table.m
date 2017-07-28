function ctdtab = ctd2table(id, P, T, S, time, lon, lat)
% ctdtab = CTD2TABLE(id, P, T, S, time, lon, lat)
%
%   inputs
%       - id:
%       - p:
%       - t:
%       - s:
%       - time:
%       - lon:
%       - lat:
%
%   outputs
%       - ctdtab:
%
%
%
% Olavo Badaro Marques, 27/Jul/2017.


%%

%
P = P(:);
T = T(:);
S = S(:);

time = time(:);
lon = lon(:);
lat = lat(:);

%
N = length(P);


%%

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


%%

%
ID = cell(N, 1);
ID(:) = {id};

%
ctdtab = table(ID, P, T, S, time, lon, lat);


