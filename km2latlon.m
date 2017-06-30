function [displat, displon] = km2latlon(L, lat0)
% [displat, displon] = KM2LATLON(L, lat0)
%
%   inputs:
%       - L: distance in kilometers.
%       - lat0: reference latitude (used to compute displon).
%
%   outputs:
%       - displat: latitude displacement, in degress
%       - displon: longitude,    "        "     ".
%
% From a distance in kilometers, compute the correspondent
% displacement in degrees of latitude and longitude (under
% a local plane approximation). Note that the correspondent
% longitudinal displacement is a function of latitude.
%
% Olavo Badaro Marques, 30/Jun/2017.


%% Kilometers in 1 degree of latitude and longitude

lat1degree = 111.19493;
lon1degree = lat1degree .* cosd(lat0);


%% Convert kilometers to degrees

displat = L / lat1degree;
displon = L / lon1degree;
