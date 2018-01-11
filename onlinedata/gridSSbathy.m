function bathyStruct = gridSSbathy(bathyfile)
% bathyStruct = GRIDSSBATHY(bathyfile)
%
%   inputs
%       - bathyfile: a *.cgi (text file) with Smith-Sandwell
%                    bathymetry in a Nx3 array.
%
%   outputs
%       - bathyStruct: structure with the fields "lon", "lat"
%                      (vectors) and "bathy" (matrix).
%
%
% The .cgi can be obtained at http://topex.ucsd.edu/cgi-bin/get_data.cgi,
% in which you select the longitude/latitude limits.
%
%
% Olavo Badaro Marques, 11/Jan/2018.

%
bathymatrix = load(bathyfile);

%
[rb, cb] = size(bathymatrix);

%
ind_diff_lat = find(bathymatrix(:, 2)~=bathymatrix(1, 2), 1, 'first');

%
nlon = ind_diff_lat - 1;
nlat = rb / (nlon);

%
bathyStruct.lon = bathymatrix(1:nlon, 1);
bathyStruct.lat = bathymatrix(1:nlon:rb, 2);

bathyStruct.bathy = reshape(bathymatrix(:, 3), nlon, nlat);
bathyStruct.bathy = bathyStruct.bathy';