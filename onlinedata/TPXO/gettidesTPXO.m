function tidepred = gettidesTPXO(time, lon, lat, tidevar)
% tidepred = GETTIDESTPXO(time, lon, lat, tidevar)
%
%   inputs
%       - time:
%       - lon:
%       - lat:
%       - tivedar:
%
%   outputs
%       - tidepred:
%
% GETTIDESTPXO uses tidepredictTPXO to make tidal predictions
% from TPXO.The main goal of GETTIDESTPXO is to allow more
% flexible specification of longitude, latitude and time.
%
% See also: tmd_tide_pred.m and tmd_tide_pred.m
%
% Olavo Badaro Marques, 12/Jan/2017.

%%

[lonmesh, latmesh] = meshgrid(lon, lat);


%%

% if isvector(time) && ~isvector(lon) && ~isvector(lat)
%     
% end

%%

tidepred = tidepredictTPXO(time, lonmesh, latmesh);
