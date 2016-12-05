function [section] = extractSection(x, y, z, pt1, pt2, npts)
% [xsec, ysec, zsec] = EXTRACTSECTION(x, y, z, pt1, pt2, npts)
%
%   inputs:
%       - x:
%       - y:
%       - z:
%       - pt1: Nx2 array with coordinates of the beginning of the section.
%       - pt2: Nx2 array with coordinates of the end of the section.
%       - npts: number of points between pt1 and pt2 (include
%               edges) to interpolate z on.
%
%   outputs:
%       - section: struct variable with 3 fields:
%               - x:
%               - y:
%               - z:
%
% Function EXTRACTSECTION interpolates z along the section defined by pt1
% and pt2. The interpolation is done on a regular grid with npts points.
% If pt1/pt2 are Nx2 arrays, then extract N sections.
% 
% Olavo Badaro Marques, 04/Dec/2016.


%% Number of sections to be extracted:

nsecs = size(pt1, 1);


%% Pre-allocate space for the output:

section = struct('x', cell(1, nsecs), ...
                 'y', cell(1, nsecs), ...
                 'z', cell(1, nsecs));

             
%% Loop through sections and interpolate z on it:

for i = 1:nsecs
    
    section(i).x = linspace(pt1(i, 1), pt2(i, 1), npts);
    section(i).y = linspace(pt1(i, 2), pt2(i, 2), npts);
    
    section(i).z = interp2(x, y, z, ...
                           section(i).x, section(i).y);
end
