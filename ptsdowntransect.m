function [lonlatout] = ptsdowntransect(lonlat0, azangle, npts, disttransect)
% [lonlatout] = PTSDOWNTRANSECT(lonlat0, azangle, npts, disttransect)
%
%   inputs
%       - lonlat0: 2-element vector with (lon, lat) coordinates.
%       - azangle: azymuth angle, in degrees, CW from North.
%       - npts: number of points along the transect.
%       - disttransect: length of the transect in km.
%
%   outputs
%       - lonlatout: array of size [npts x 2] with (lon, lat)
%                    coordinates of the npts down the transect
%                    (the first row is lonlat0).
%
%
%
% 1 degree of ARCLEN along a great circle on a spherical
% Earth is equal to 60 * 1852 m = 111.12 km.
%
%
% Olavo Badaro Marques, 25/Apr/2018.


%%

%
arclen_transect = disttransect / 111.12;

arclen_pts = linspace(0, arclen_transect, npts);


%%
%
[lat_out, lon_out] = reckon(lonlat0(2), lonlat0(1), ...
                            arclen_pts, azangle);
                        
%
lonlatout = [lon_out(:), lat_out(:)];