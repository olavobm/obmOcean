function [indmin, distmin] = closestLonLat(long, latg, loni, lati)
% indmin = CLOSESTLONLAT(long, latg, loni, lati)
%
%   inputs
%       - long: array of longitude grid (output of meshgrid!).
%       - latg:   "   "  latitude    ".
%       - loni: vector of longitude points.
%       - lati:    "   "  latitude    ".
%
%   outputs
%       - indmin: index of (long, latg) of the grid point
%                 with mininum distance to the points (loni, lati).
%       - distmin: distance (in meters) between the closest
%                  point in git dilong/latg to loni/lati.
%
% TO DO:
%   - allow long and latg to be vectors of a regular array.
%   - include the possibility of an irregular array
%     (where there is no optimization).
%
% A much (much!) simpler code can be written
% if a planar approximation is used.
%
% See also: gsw_distance.m.
%
% Olavo Badaro Marques, 23/Jan/2018.


%%

if ~isvector(long) % && ~isvector(latg)
    
    lmgrid = true;
else
	lmgrid = false;
end

%%

if lmgrid
    
    [nr, nc] = size(long);
    
    %
    lonvec = long(1, :);
    lonvec = lonvec(:);
        
    latvec = latg(:, 1);
% %         latvec = latvec(:);

else
    
    nr = length(latg);
    nc = length(long);

    %
    lonvec = long(:);
    latvec = latg(:);
end

%
npts = length(loni);


%%

%
lenpts = 10;    % must be even

%
ind_nearbypts = NaN(lenpts+1, lenpts+1, npts);

%
for i1 = 1:npts
    
    %
    indlon_closest = dsearchn(lonvec, loni(i1));
    indlat_closest = dsearchn(latvec, lati(i1));

    %
    rsubs = (indlat_closest-(lenpts/2)) : 1 : (indlat_closest+(lenpts/2));
    csubs = (indlon_closest-(lenpts/2)) : 1 : (indlon_closest+(lenpts/2));

    [csubs_grid, rsubs_grid] = meshgrid(csubs, rsubs);

    %
    loutgrid = rsubs_grid<1 | csubs_grid<1 | csubs_grid>nc | rsubs_grid>nr;

    csubs_grid(loutgrid) = NaN;
    rsubs_grid(loutgrid) = NaN;

    %
    ind_nearbypts(:, :, i1) = sub2ind([nr, nc], rsubs_grid, csubs_grid);


    
end


%%
% I could also do in a way that I don't store all the distances

%
nr_subg = lenpts + 1;
nc_subg = nr_subg;

%
distArray = NaN(nr_subg, nc_subg, npts);


%%

for i1 = 1:nr_subg
    
    for i2 = 1:nc_subg
        
% % %         %
% % %         if lreggrid
% % %             indlon_aux = i2;
% % %             indlat_aux = i1;
% % %         else
% % %             indlon_aux = (mod(i1+1, nr) + 1) + ((i2-1) * nr);
% % %             indlat_aux = indlon_aux;
% % %         end
        
        %
        for i3 = 1:npts
            
            distArray(i1, i2, i3) = ...
                  gsw_distance([long(ind_nearbypts(i1, i2, i3)), loni(i3)], ...
                               [latg(ind_nearbypts(i1, i2, i3)), lati(i3)]);
                           
        end
           
    end
end


%%

%
indmin = NaN(1, npts);
distmin = NaN(1, npts);

%
for i1 = 1:npts

    %
    [~, indmin_aux] = min(reshape(distArray(:, :, i1), nr_subg*nc_subg, 1));

    %
    [i_aux, j_aux] = ind2sub([nr_subg, nc_subg], indmin_aux);
    
    %
%     indmin(i1) = ind_nearbypts(indmin_aux);
    indmin(i1) = ind_nearbypts(i_aux, j_aux, i1);
    
    %
    distmin(i1) = distArray(i_aux, j_aux, i1);
end

