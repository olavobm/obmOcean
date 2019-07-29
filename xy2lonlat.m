function [lonpts, latpts] = xy2lonlat(lonlat0, xpts, ypts)
% [lonpts, latpts] = XY2LONLAT(lonlat0, xpts, ypts)
%
%   inputs
%       - lonlat0: double array with two numbers -- reference
%                  longitude and latitude, in that order.
%       - xpts: array with x coordinates.
%       - ypts: array, same length as xpts, with y coordinates.
%
%   outputs
%       - lonpts: longitude array.
%       - latpts: latitude array.
%
%
% XY2LONLAT.m calculates the longitude and latitude coordinates
% from cartesian coordinates (x, y), in kilometers, where the
% origin is associated with the point lonlat0.
%
% Naturally, this calculation is only approximate because the
% Earth is a sphere and the cartesian coordinates lie on a
% plane.
%
% See also: lonlat2kmgrid.m
%
% Olavo Badaro Marques, 16/Jun/2019.


%%

%
londeg_dist = xpts ./ (60 * 1.852 * cosd(lonlat0(2)));

%
latdeg_dist = ypts ./ (60*1.852);


%%

%
lonpts = lonlat0(1) + londeg_dist;

%
latpts = lonlat0(2) + latdeg_dist;


% % %%
% % 
% % distkm_fromref = sqrt(xpts.^2 + ypts.^2);
% % 
% % 
% % %%
% % %
% % % Using this on a sphere is only an approximation,
% % % which is only valid at small scales. It turns out
% % % this a very bad approximation even at small scales.
% % %
% % % I can improve on that later, though not really meaningful.
% % 
% % azimuth_fromxy = atan2(ypts, xpts);
% % 
% % 
% % %%
% % 
% % distdegrees_fromref = km2deg(distkm_fromref);
% % 
% % 
% % %%
% % 
% % [latpts, lonpts] = reckon(lonlat0(2), lonlat0(1), ...
% %                           distdegrees_fromref, azimuth_fromxy);
