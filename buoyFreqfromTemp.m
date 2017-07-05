function N2 = buoyFreqfromTemp(p, t, S0, p0)
% N2 = BUOYFREQFROMTEMP(p, t, S0)
%
%   inputs:
%       - p:
%       - t:
%       - S0 (optional):
%       - p0 (optional): reference pressure for computing density.
%
%   outputs:
%       - N2: buoyancy frequency squared in (radians/s)^2.
%
%
%
% Olavo Badaro Marques, 27/Jun/2017.


%% If not given, set deafult values for S0 and p0:

if ~exist('S0', 'var')
    S0 = 35 .* ones(size(t));
end

if ~exist('p0', 'var')
    p0 = 0;
end


%%

if iscolumn(p)
    p = repmat(p, 1, size(t, 2)); 
end


%% Compute density using a given salinity:

rho = gsw_pot_rho_t_exact(S0, t, p, p0);


%% Compute N2:

rho0 = mean(rho(:));

g = 9.7963;

%
N2 = (g/rho0) .* (diff(rho, 1, 1) ./ diff(p, 1, 1));


