function tideCoef = tideCoefsTPXO(lonlim, latlim, tidevars, tideconst, tpxomodel)
% tideCoef = TIDECOEFSTPXO(lonlim, latlim, tidevars, tideconst, tpxomodel)
%
%   inputs:
%       - lonlim:
%       - latlim:
%       - tidevars (optional):
%       - tideconst (optional):
%       - tpxomodel (optional):
%
%   outputs:
%       - tideCoef: struct array with the fields ....... Its length is
%                   equal to the number of tidal constituents.
%
% Olavo Badaro Marques, 27/Apr/2017.


%%

if ~exist('tpxomodel', 'var')
    tpxomodel = defaultTPXO;
end


%%

if ~exist('tidevars', 'var') || isempty(tidevars)
    tidevars = 'u';
end


%%

if ~exist('tideconst', 'var')
    tideconst = {'M2'};
else
    if ~iscell(tideconst)
        tideconst = {tideconst};
    end
end

N = length(tideconst);

%%

if length(lonlim)==1
    lonlim = [lonlim, lonlim];
end

if length(latlim)==1
    latlim = [latlim, latlim];
end


lonlatLims = [latlim; lonlim];


%% Get tidal coefficients:

varFields = {'const', 'lon', 'lat', 'amp', 'phase'};

tideCoef = createEmptyStruct(varFields, N);

% Loop over tidal constituents:
for i = 1:N
    
    %
    [x, y, amp, phase] = tmd_get_coeff(tpxomodel, tidevars, tideconst{i});
    % x is 0.125 : 0.25 : 359.8750
    % y is -90 : 0.25 : 90

    %
    tideCoef(i).const = tideconst{i};

    tideCoef(i).lon = x;
    tideCoef(i).lat = y(:);

    tideCoef(i).amp = amp;
    tideCoef(i).phase = phase;
    
    tideCoef(i) = subsetStruct({'lat', 'lon'}, lonlatLims, tideCoef(i));
    
end


