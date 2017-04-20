function N2 = buoyFreqMaster()
% N2 = BUOYFREQMASTER()
%
%   inputs:
%       -
%       -
%       -
%
%   outputs:
%       - N2:
%
% High level function to compute the buoyancy frequency squared (N2).
%
% I need this function to:
%       - Take either potential density OR TS
%       - Filter input profiles AND/OR output (or no filtering).
%       - (1) Compute as it is, (2) interpolate to the grid where we
%         have data points or (3) interpolate to a given grid. Maybe make
%         (2) the default option.
% 
% Olavo Badaro Marques, 20/Apr/2017.