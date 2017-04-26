function [N2, zout] = buoyFreqMaster(z, sgth, varargin)
% [N2, zout] = BUOYFREQMASTER(z, sgth, varargin)
%
%   inputs:
%       - z:
%       - sgth:
%       - varargin:
%
%   outputs:
%       - N2: the buoyancy frequency squared, in (radians/s)^2.
%       - zout: vertical location where N2 is calculated.
%
%       - Should be able to output filtered inputs (in case
%         they are filtered).
%
% High level function to compute the buoyancy frequency squared (N2).
%
%
% TO DO -- I need this function to:
%       1 - Take either potential density OR TS
%       2 - Filter input profiles AND/OR output (or no filtering).
%       3 - (a) Compute as it is, (b) interpolate to the grid where we
%           have data points or (c) interpolate to a given grid. Maybe
%           make (b) the default option.
% 
% Olavo Badaro Marques, 20/Apr/2017.


%% Parse inputs:

% Create input Parser variable:
p = inputParser;

% Default values:
defaultMaxGap = +Inf;
defaultInterp = NaN;
defaultFilt = true;
defaultFiltParam = 20;
defaultnegN2 = false;


% Add Parameters to p:
addParameter(p, 'MaxGap', defaultMaxGap);
addParameter(p, 'Interp', defaultInterp);
addParameter(p, 'Filt', defaultFilt);
addParameter(p, 'FiltParam', defaultFiltParam);
addParameter(p, 'negN2', defaultnegN2);

% ------------------------------------------------------------------------
% In case, I want to check required inputs, I have to do something like:
% argName = 'z';
% addRequired(p, argName);
% parse(p, argName, varargin{:})
% ------------------------------------------------------------------------

% Fill inputParser variable p with inputs or default values:
parse(p, varargin{:})


%% Filtering inputs:

if p.Results.Filt
    
    sgth4n2 = obmBinAvg(z, sgth', p.Results.FiltParam);
	sgth4n2 = sgth4n2';
    
else
    
    sgth4n2 = sgth;
    
end


%% Calculate N2:

n2struct = buoyFreqsqrd(z, sgth4n2, p.Results.MaxGap);


%% Assign outputs:

N2 = n2struct.N2;
zout = n2struct.z;


%% If parameter is true, replace negative
% N2 by closest N2 greater or equal to 0:

if p.Results.negN2
    
    %
    lneg = (N2 < 0);
    lpos = (N2 >= 0);
    
    %
    indcolsNeg = find(any(lneg, 1));
    
    % Loop over columns of N2 with at least 1 negative value:
    for i = 1:length(indcolsNeg)
        
        % Find the indices of depths with positive N2 closest
        % to the depths where there is negative N2:
        zwithN2pos = zout(lpos(:, indcolsNeg(i)));
        indClosest = dsearchn(zwithN2pos, zout(lneg(:, indcolsNeg(i))));

        % In fact, the indices above are for the vector zwithN2pos,
        % Now find indices for the vector zout
        % (maybe should use ismember to be clearer):
        indNew = dsearchn(zout, zwithN2pos(indClosest));
                
        % Replace negative values by closest positive (or zero) N2:
        N2(lneg(:, indcolsNeg(i)), indcolsNeg(i)) = N2(indNew, indcolsNeg(i));
    end

    
end