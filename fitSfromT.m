function [Smodel, S] = fitSfromT(t, s, T)
% S = FITSFROMT(t, s, T)
%
%   inputs:
%       - t: potential temperature.
%       - s:
%       - T:
%
%   outputs:
%       - S:
%
% FITSFROMT fits a third-order polynomial ...
%
% s and t must have NaNs in the same locations. If t has more NaNs, the fit
% will give an error.
%
% Ideally, we need salinity to compute potential temperature, which we want
% to use to estimate salinity. Gladly the error associated with computing
% potential temperature from 2000dbar relative to the surface is less than
% 1%, for salinities between 30 and 35.
%
% Olavo Badaro Marques, 26/Nov/2016.


%% Fit cubic polynomial and get model paramaters:

npowerfit = 3;

imf.power = 0:1:npowerfit;

[~, m] = myleastsqrs(t, s, imf);


%% If input T is row vector, make it a column vector:

if isrow(T)
    T = T';
end


%% Fit Salinity from Temperature:

S = NaN(size(T));

% Loop through columns:
for i = 1:size(T, 2)
    
    laux = ~isnan(T(:, i));
    
    naux = length(find(laux));
    
    S(laux, i) = [ones(naux, 1), T(laux, i), ...
                  T(laux, i).^2, T(laux, i).^3] * m;
    
end

