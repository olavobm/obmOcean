function distalongtran = distAlongTransect(a, x, lEarth)
%
% distalongtran = DISTALONGTRANSECT(a, x, lEarth)
% 
%   inputs:
%       - x: MxN matrix, containing the coordinates of M points
%            in a N-dimensional space.
% 
%       - a: 2xN matrix. The first (second) row have the coordinates
%            of the points representing the beginning (end) of the
%            transect in a N-dimensional space.
%
%       - lEarth (optional): true or false to indicate whether the other
%                            inputs refer to lon/lat coordinates on the
%                            surface of the Earth. Default is true.
% 
%   outputs:
%       - distalongtran: The (euclidean) distance between the beginning of
%                        the transect, a(1, :), and the projection of each
%                        point in x onto the line defined by a(1, :) and
%                        a(2, :). The result come out as 1xM vector in
%                        kilometers if lEarth==true or the units of the
%                        input if lEarth==false.
% 
% OR SHOULD IT BE a Mx1 vector????
% 
% This functions computes the distance along a transect, i.e. a line
% segment that begins at a(1, :) and ends at a(2, :). This function was
% originally written for points specified on the surface of the Earth
% with lon/lat coordinates. HOWEVER, meaningful results are only obtained
% if the lon/lat points DO NOT span a significant portion of the Earth's
% surface, meaning that a plane is locally a good approximation of the
% Earth's surface.
%
% make some tests -- and a demo! -- including near the equator, near the
% poles, meridional and zonal sections across basins and an example
% where it fails.
% 
% The distance along the transect is computed by finding the projection
% along the transect using the dot product. If vector "t" goes from the
% beginning of the transect to the end of it and vector "d" goes from the
% beginning of the transect to a location d1, we have
%       dotprod = t . d = abs(t) x abs(d) x cos(ang),
% 
% such that the distance of d1 along the transect (the projection) is:
%       abs(d) x cos(ang) = t . d / abs(t)
% 
% Olavo Badaro Marques, 30/Jun/2016 - creation.
%                       19/Sep/2016 - edited comments and minor changes.


%% Check whether optional input was specified and
% whether we have lon/lat input (default) or not:
if exist('lEarth', 'var')
    lsphere = lEarth;
else
    lsphere = true;
end


%% Check if number of columns of a are the same as in input x
% (i.e. points in both inputs are both in the same N-dimensional space):

[rx, cx] = size(x);
[ra, ca] = size(a);

if ca~=cx
    error(['The length/size of ...a... must be equal ' ...
           'to the number of columns of x'])
end


%% Create a distance factor to convert degrees of longitude and
% latitude to kilometers. When not on the surface of the Earth
% (lsphere==false), distfac is filled with 1's (i.e. there is
% no effective scaling).

if lsphere
   
    lat2km = 60 * 1.852;               % true for the Earth
    lon2km = abs(cosd(mean(x(:, 2)))) * lat2km;  % use the mean latitude
                                                 % to create the lon2km
                                                 % factor.              
    distfac = [lon2km lat2km];
    
else  
    distfac = ones(1, cx);
    
end


%% Compute vectors for the transect orientation and for
%  each location referenced to the beginning of the line:

% Create line orientation vector and transform it from a lat/lon
% space to one where distances are in kilometers:
linevec = a(2, :) - a(1, :);
linevec = linevec .* distfac;

% Same as above, but for the vectors (each row of xvecs) that go
% from the beginning of the transect to each location in matrix x:
xvecs = x - repmat(a(1, :), rx, 1);
xvecs = xvecs .* repmat(distfac, rx, 1);


%% Compute distance along the section:

% First compute dot products:
dotprods = linevec * xvecs';

% The projection is the dot product divided by the magnitude of linevec:
mag_linevec = sqrt(sum(linevec.^2));
distalongtran = dotprods ./ mag_linevec;
