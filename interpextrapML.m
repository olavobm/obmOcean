function n2new = interpextrapML(z, n2, D, sml, bml, zgrid)
% n2new = EXTRAPN2(z, n2, D, sml, bml, zgrid)
%
%   inputs:
%       - z:
%       - n2:
%       - D: bottom depth.
%       - sml: 1x2 array with surface mixed layer depth and value.
%       - bml: 1x2   "     "   bottom   "     "     "    "    "
%       - zgrid (optional): interpolate onto new grid.
%
%   outputs:
%       -
%       -
%
% WOULD BE REALLY NICE, IF z COULD MATRIX (N2 NOT REGULAR).
%
% Olavo Badaro Marques, 27/Nov/2016.


ncols = size(n2, 2);

%%

if ~exist('zgrid', 'var')
    zgrid = z;
end


%%

if (sml(1) > z(1)) || (bml(1) < z(end))
    error('Not allowed.')
end


%%

% Dealing with surface gap:
if sml(1)>0
    zsgap = repmat([0; sml(1)], 1, 1);
    n2sgap = repmat(sml(2), 2, 1);
else % sml(1)==0
    zsgap = zeros(1, 1);
    n2sgap = repmat(sml(2), 1, ncols);
end


% Dealing with bottom gap:
if bml(1)<D
    zbgap = repmat([bml(1); D], 1, 1);
    n2bgap = repmat(bml(2), 2, ncols);
else % bml(1)==D
    zbgap = repmat(D, 1, 1);
    n2bgap = repmat(bml(2), 1, ncols);
end

% Concatenate to the data:
zaux  = [zsgap; z; zbgap];
n2aux = [n2sgap; n2; n2bgap];


%% Loop through columns and interpolate:

n2new = NaN(length(zgrid), ncols);

for i = 1:ncols
    
    lok = ~isnan(n2aux(:, i));
    
	n2new(:, i) = interp1(zaux(lok), n2aux(lok, i), zgrid);
    
end

