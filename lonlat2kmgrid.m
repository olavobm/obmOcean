function [xpts, ypts] = lonlat2kmgrid(lonlat0, lonpts, latpts)
% [xpts, ypts] = LONLAT2KMGRID(lonlat0, lonpts, latpts)
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
% ONE OR MULITPLE POINTS???
%
%
% Olavo Badaro Marques, 18/Jun/2018.



%%

[distpts, azymthpts]  = distance(lonlat0(2), lonlat0(1), ...
                                 latpts, lonpts);

%
distpts_km = deg2km(distpts);


%%

xpts = distpts_km .* sind(azymthpts);

ypts = distpts_km .* cosd(azymthpts);