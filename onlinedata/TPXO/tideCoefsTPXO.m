function tideCoef = tideCoefsTPXO(lon, lat, tidevar, tideconst, tpxomodel)
% tideCoef = TIDECOEFSTPXO(lon, lat, tidevar, tideconst, tpxomodel)
%
%   inputs:
%       - lon: longitude.
%       - lat: latitude.
%       - tidevar:
%       - tideconst (optional): cell array (or one string) with the name
%                               of the tidal constituents.
%       - tpxomodel (optional):
%
%   outputs:
%       - tideCoef:
%
% Olavo Badaro Marques, 27/Apr/2017.


%%

if ~exist('tpxomodel', 'var')
    tpxomodel = defaultTPXO;
end


%%

[x, y, amp, phase] = tmd_get_coeff(tpxomodel, type, cons);