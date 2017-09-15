function xinterp = interpextrapML(z, x, D, sml, bml, zgrid)
% xinterp = INTERPEXTRAPML(z, x, D, sml, bml, zgrid)
%
%   inputs
%       - z: depth points where x is given.
%       - x: variable to interpolate/extrapolate.
%       - D: bottom depth.
%       - sml: 1x2 array with surface mixed layer depth and value.
%       - bml: 1x2   "     "   bottom   "     "     "    "    "
%       - zgrid: grid to interpolate x onto.
%
%   outputs
%       - xinterp: x interpolated onto zgrid. Extrapolation obeys the
%                  specification of mixed layers.
%
%
%
% Note that sml(1) and bml(1) are the depths of the bottom and upper
% limits, respectively, of these mixed layers.
%
% MAYBE TO DO:
%   - would be really nice, if z could matrix (n2 not regular).
%
% Olavo Badaro Marques, 27/Nov/2016.


%% Code operates independently for each column of x

ncols = size(x, 2);


%% Check input parameters

if (sml(1) > z(1)) || (bml(1) < z(end))
    error('Not allowed because.. should be though.')
end


%%

% Dealing with surface gap:
if sml(1)>0
    zsgap = repmat([0; sml(1)], 1, 1);
    xsgap = repmat(sml(2), 2, 1);
else % sml(1)==0
    zsgap = zeros(1, 1);
    xsgap = repmat(sml(2), 1, ncols);
end


% Dealing with bottom gap:
if bml(1)<D
    zbgap = repmat([bml(1); D], 1, 1);
    xbgap = repmat(bml(2), 2, ncols);
else % bml(1)==D
    zbgap = repmat(D, 1, 1);
    xbgap = repmat(bml(2), 1, ncols);
end

% Concatenate to the data:
zaux  = [zsgap; z; zbgap];
xaux = [xsgap; x; xbgap];


%% Loop through columns and interpolate:

xinterp = NaN(length(zgrid), ncols);

for i = 1:ncols
    
    lok = ~isnan(xaux(:, i));
    
	xinterp(:, i) = interp1(zaux(lok), xaux(lok, i), zgrid);
    
end

