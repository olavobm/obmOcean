function tidepred = tidepredictTPXO(time, lon, lat, tidevar, tpxomodel)
% tidepred = TIDEPREDICTTPXO(time, lon, lat, tidevar, tpxomodel)
%
%   inputs:
%       - time: time in datenum format to (UTC????)
%       - lon: longitude.
%       - lat: latitude.
%       - tidevar:
%       - tpxomodel (optional):
%
%   outputs:
%       - tidepred:
%
% TIDEPREDICTTPXO uses the tmd_toolbox to make a tidal prediction
% using the TPXO model.
%
% Olavo Badaro Marques, 12/Jan/2017.


%% If the optional input is not given,
% then use a default TPXO model:


if ~exist('tpxomodel', 'var')
    tpxomodeldir = ['/Users/olavobm/Documents/MATLAB/olavo_toolbox/' ...
                    'others/tmd_toolbox/DATA/'];
	tpxomodelfile = 'Model_tpxo7.2';
    
    tpxomodel = fullfile(tpxomodeldir, tpxomodelfile);
end


%
if exist(tpxomodel, 'file') ~=2
    error(['TPXO*.* file ' tpxomodel ' does not exist'])
end

%%

if ~exist('tidevar', 'var')
    
%     tidevar = {'u', 'v', 'z'};
    tidevar = 'z';

end

%%
time = time(:);

if isrow(lon)
    lon = lon(:);
end

if isrow(lat)
    lat = lat(:);
end


%% Uses evalc so that things are not printed on the screen:

strTimeCoords = 'time, lat, lon';
strVar = tidevar;

strRun = ['tidepred = tmd_tide_pred(''' tpxomodel ''', ' strTimeCoords ', ''' strVar ''');'];
evalc(strRun);

tidepred = tmd_tide_pred(tpxomodel, time, lat, lon, tidevar);
