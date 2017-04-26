function [Smodel, S, m] = fitSfromT(t, s, T)
% [Smodel, S, m] = FITSFROMT(t, s, T)
%
%   inputs:
%       - t: temperature.
%       - s: salinity.
%       - T (optional):
%
%   outputs:
%       - Smodel: anonymous function with the fit created by this function.
%       - S: salinity estimated from the optional input T.
%       - m: model parameters.
%
% FITSFROMT fits a third-order polynomial to
% estimate salinity from temperature.
%
% s and t must have NaNs in the same locations.
% If t has more NaNs, the fit will give an error.
%
% Olavo Badaro Marques, 26/Nov/2016.


%% Fit cubic polynomial and get model paramaters:

npowerfit = 3;

imf.power = 0:1:npowerfit;

[~, m] = myleastsqrs(t, s, imf);


%% Created anonymous function for cubic estimation:

Smodel = @(T) m(1) + m(2)*T + m(3)*(T.^2) + m(4)*(T.^3);


%% End function or estimate salinity for a given input T:

if ~exist('T', 'var')
    
    return    % end the function
    
else
    
    S = Smodel(T);
    
end