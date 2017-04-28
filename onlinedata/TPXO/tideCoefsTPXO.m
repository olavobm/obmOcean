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
    tidevars = {'z', 'u', 'v'};
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

%
lonlatLims = [latlim; lonlim];


%%

x_UV_TPXO = 0.125 : 0.25 : 359.8750;
x_Z_TPXO = 0.25 : 0.25 : 360;
y_TPXO = -90 : 0.25 : 90;

indinlon_UV = (x_UV_TPXO>=lonlim(1) & x_UV_TPXO<=lonlim(2));
indinlon_Z = (x_Z_TPXO>=lonlim(1) & x_Z_TPXO<=lonlim(2));

indinlat = (y_TPXO>=latlim(1) & y_TPXO<=latlim(2));


%% Get tidal coefficients:

varFields = [{'const', 'lon', 'lat'}, tidevars];

tideCoef = createEmptyStruct(varFields, N);

for i1 = 1:N

    for i2 = 1:length(tidevars)

        tideCoef(i1).(tidevars{i2}) = createEmptyStruct({'amp', 'phase'});

    end
end

% Loop over tidal constituents:
for i1 = 1:N
    
    %
    tideCoef(i1).const = tideconst{i1};

    %
    for i2 = 1:length(tidevars)
        
        %
        [x, y, amp, phase] = tmd_get_coeff(tpxomodel, tidevars{i2}, tideconst{i1});
        
        %
        tideCoef(i1).(tidevars{i2}).amp = amp(indinlat, indinlon_UV);
        tideCoef(i1).(tidevars{i2}).phase = phase(indinlat, indinlon_UV);

    end

    %
    tideCoef(i1).lon = x(indinlon_UV);
    tideCoef(i1).lat = y(indinlat);
    tideCoef(i1).lat = tideCoef(i1).lat(:);
    
    %
%     tideCoef(i1) = subsetStruct({'lat', 'lon'}, lonlatLims, tideCoef(i1));
    
end


