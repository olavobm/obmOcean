function gradX = gradOnEarth(lon, lat, x)
% gradX = GRADONEARTH(lon, lat, x)
%
%   inputs
%       - lon: vector
%       - lat: vector
%       - x:
%
%   outputs
%       - gradX:
%
%
%
% See also: distance.m
%
% Olavo Badaro Marques, 01/Nov/2017.


%%

x_grad = NaN(length(lat), length(lon));
y_grad = x_grad;


%%

[long, latg] = meshgrid(lon, lat);


%%

dlon_1 = distance(latg(:, 1:end-2), long(:, 1:end-2), ...
                  latg(:, 3:end), long(:, 3:end));
dlon_2 = distance(latg(:, 1), long(:, 1), ...
                  latg(:, 2), long(:, 2));
dlon_3 = distance(latg(:, end-1), long(:, end-1), ...
                  latg(:, end), long(:, end));
              
dlon_1 = 1000 * deg2km(dlon_1);
dlon_2 = 1000 * deg2km(dlon_2);
dlon_3 = 1000 * deg2km(dlon_3);

x_grad(:, 2:end-1) = (x(:, 3:end) - x(:, 1:end-2)) ./ dlon_1;
x_grad(:, 1)   = (x(:, 2) - x(:, 1)) ./ dlon_2;
x_grad(:, end) = (x(:, end) - x(:, end-1)) ./ dlon_3;


%%

dlat_1 = distance(latg(1:end-2, :), long(1:end-2, :), latg(3:end, :), long(3:end, :));
dlat_2 = distance(latg(1, :), long(1, :), latg(2, :), long(2, :));
dlat_3 = distance(latg(end-1, :), long(end-1, :), latg(end, :), long(end, :));
              
dlat_1 = 1000 * deg2km(dlat_1);
dlat_2 = 1000 * deg2km(dlat_2);
dlat_3 = 1000 * deg2km(dlat_3);

y_grad(2:end-1, :) = (x(3:end, :) - x(1:end-2, :)) ./ dlat_1;
y_grad(1, :)   = (x(2, :) - x(1, :)) ./ dlat_2;
y_grad(end, :) = (x(end, :) - x(end-1, :)) ./ dlat_3;


%%

gradX = x_grad + 1i.*y_grad;

