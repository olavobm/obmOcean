function indmin = closestLonLat(long, latg, loni, lati)
% indmin = CLOSESTLONLAT(long, latg, loni, lati)
%
%   inputs
%       -
%       -
%       -
%       -
%
%   outputs
%       -
%
%
% See also: gsw_distance.m.
%
% Olavo Badaro Marques, 23/Jan/2018.


%%

[nr, nc] = size(long);

npts = length(loni);


%%
% I could also do in a way that I don't store all the distances

distArray = NaN(nr, nc);


%%

for i1 = 1:nr
    
    for i2 = 1:nc
        
        for i3 = 1:npts
        
            distArray(i1, i2, i3) = gsw_distance([long(i1, i2), loni(i3)], ...
                                                 [latg(i1, i2), lati(i3)]);
            
        end
        
        
    end
end


%%

%
indmin = NaN(1, npts);

%
for i1 = 1:npts

    [~, indmin_aux] = min(reshape(distArray(:, :, i1), nr*nc, 1));

    indmin(i1) = indmin_aux;
end


%%


