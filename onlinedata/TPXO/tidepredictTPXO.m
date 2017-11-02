function tidepred = tidepredictTPXO(time, lon, lat, tidevar, tideconst, tpxomodel)
% tidepred = TIDEPREDICTTPXO(time, lon, lat, tidevar, tideconst, tpxomodel)
%
%   inputs:
%       - time: time in datenum format(UTC????)
%       - lon: longitude.
%       - lat: latitude.
%       - tidevar:
%       - tideconst (optional): cell array (or one string) with the name
%                               of the tidal constituents.
%       - tpxomodel (optional):
%
%   outputs:
%       - tidepred:
%
% TIDEPREDICTTPXO uses the tmd_toolbox (the tmd_tide_pred.m function)
% to make a tidal prediction using the TPXO model.
%
% See also: tmd_tide_pred.m
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
    
    tidevar = {'u', 'v', 'z'};
    
else
    if ~iscell(tidevar)
        tidevar = {tidevar};
    end
end


%% Tidal constituents:

% These seem to be the default constituents that TPXO computes:
tidalconstNames = {'M2', 'S2', 'N2', 'K2', 'K1', 'O1', 'P1', 'Q1', ...
                   'MF', 'MM', 'M4', 'MS4', 'MN4'};
tidalconstIndices = 1:13;

mapConst = containers.Map(tidalconstNames, tidalconstIndices);

% Get indices of tidal constituents to estimate:
if ~exist('tideconst', 'var')
    
    tideInds = tidalconstIndices;
    
else
    
    if ~iscell(tideconst)
        tideconst = {tideconst};
    end
    
    tideInds = NaN(1, length(tideconst));
    
    for i = 1:length(tideconst)
        tideInds(i) = mapConst(upper(tideconst{i}));
    end
    
end

% % Nconst = length(tideconst);


%%
time = time(:);

if isrow(lon)
    lon = lon(:);
end

if isrow(lat)
    lat = lat(:);
end


%%

varFiels = [{'time', 'lon', 'lat'}, tidevar];

tidepred = createEmptyStruct(varFiels);

%
tidepred.time = time;
tidepred.lon = lon;
tidepred.lat = lat;


%% Uses evalc so that things are not printed on the screen:

% strTimeCoords = 'time, lat, lon';
% strVar = tidevar;
%
% strRun = ['tidepred = tmd_tide_pred(''' tpxomodel ''', ' strTimeCoords ', ''' strVar ''');'];
% evalc(strRun);



for i = 1:length(tidevar)
    
    tidepred.(tidevar{i}) = tmd_tide_pred(tpxomodel, time, lat, lon, tidevar{i}, tideInds);
    
end

% % [tidepred.umaj, tidepred.umin, ...
% %  tidepred.upha, tidepred.uincl] = tmd_ellipse(tpxomodel, lat, lon, 'M2');

% % % [a, b] = tmd_extract_HC(tpxomodel, lat, lon, 'u', tideInds);

