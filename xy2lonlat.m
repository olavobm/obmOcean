function [lonpts, latpts] = xy2lonlat(lonlat0, xpts, ypts)
% [lonpts, latpts] = XY2LONLAT(lonlat0, xpts, ypts)
%
%   inputs
%       -
%       -
%       -
%
%   outputs
%       -
%       -
%
%
%
%
%
% See also: lonlat2kmgrid.m
%
% Olavo Badaro Marques, 16/Jun/2019.


%%

distkm_fromref = sqrt(xpts.^2 + ypts.^2);


%%
%
% Using this on a sphere is only an approximation,
% which is only valid at small scales
%
% I can improve on that later, though not really meaningful.

azimuth_fromxy = atan2(ypts, xpts);


%%

distdegrees_fromref = km2deg(distkm_fromref);


%%

[latpts, lonpts] = reckon(lonlat0(2), lonlat0(1), ...
                          distdegrees_fromref, azimuth_fromxy);
