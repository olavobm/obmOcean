function N2 = buoyFreqfromTS(p, t, s, zcut, ptscode)
% N2 = BUOYFREQFROMTS(p, t, s, zcut, ptscode)
%
%   inputs:
%       - p:
%       - t:
%       - s:
%       - zcut (optional):
%       - ptscode (optional):
%
%   outputs:
%       - N2: structure with two fields -- (1) z, the location in the
%             vertical and (2) N2, the buoyancy frequency squared, in
%             (radians/s)^2.
%
% This function computes potential density (relative to the surface,
% using the seawater toolbox) from the inputs and calls the function
% buoyFreqsqrd.m to calculate the buoyancy squared from the potential
% density.
%
% Olavo Badaro Marques, 20/Apr/2017.


%% Compute potential density:

% Choose reference pressure:
refpres = 0;    % does this matter for the gradient of sgth???

%
sgth = sw_pden(s, t, p, refpres);


%% Compute buoyancy frequency squared:

N2 = buoyFreqsqrd(p, sgth, zcut, ptscode);


