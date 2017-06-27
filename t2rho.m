function rhoa = ta2rhoa(ta, T0, p0, S0)
% rhoa = TA2RHOA(ta, T0, p0, S0)
%
%   inputs:
%       - ta: temperature anomaly.
%       - T0: reference temperature.
%       - p0: reference pressure.
%       - S0 (optional): reference salinity.
%
%   outputs:
%       - rhoa: density anomaly.
%
% Compute the density anomaly (rhoa) correspondent to the temperature
% anomaly (ta) using a linear approximation, via the thermal expansion
% coefficient.
%
% The coefficient is a function of temperature, salinity and pressure.
% Therefore, computing the coefficient requires "reference" values
% (T0, S0, p0). A default value is chosen for S0, so it does not
% necessarily need to be given as an input.
%
% The coefficient and an associated reference density is
% computed using functions from the Gibbs-SeaWater (GSW)
% toolbox (http://www.teos-10.org).
%
% Olavo Badaro Marques, 26/Apr/2017.


%% Set default parameters if not given as inputs:

if ~exist('S0', 'var')
    S0 = 35;
end


%% Compute thermal expansion coefficient and reference density:

Talpha = gsw_alpha(S0, T0, p0);

rho0 = gsw_rho(S0, T0, p0);


%% Compute the correspondent density anomaly:

rhoa = - rho0 * Talpha * ta;

