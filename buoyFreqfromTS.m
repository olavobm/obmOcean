function N2 = buoyFreqfromTS(lat, p, t, s, p0, zcut, ptscode)
% N2 = BUOYFREQFROMTS(p, t, s, zcut, ptscode)
%
%   inputs:
%       - lat: latitude (required to compute depth from pressure).
%       - p: pressure (in dbar).
%       - t: in-situ temperature.
%       - s: salinity.
%       - zcut (optional):
%       - ptscode (optional):
%
%   outputs:
%       - N2: structure with two fields -- (1) z, the location in the
%             vertical and (2) N2, the buoyancy frequency squared, in
%             (radians/s)^2.
%
% BUOYFREQFROMTS computes the buoyancy frequency squared by calling
% buoyFreqsqrd.m. Temperature and salinity are used to compute
% potential density (using the Gibbs-SeaWater (GSW) Oceanographic
% Toolbox), then N2 is computed.
%
% Olavo Badaro Marques, 20/Apr/2017.


%%

S0 = 35;

if ~exist('s', 'var') || isempty(s)
    s = S0;
end

%
if numel(s)==1
    s = s .* ones(size(t));
end


%% Choose reference pressure:

if ~exist('p0', 'var') || isempty(p0)
    p0 = 0;                   % does this matter for the gradient of sgth?
end


%% Compute potential density

%
if iscolumn(p)
    pmatrix = repmat(p, 1, size(t, 2)); 
end

%
sgth = gsw_pot_rho_t_exact(s, t, pmatrix, p0);


%% Compute depth from pressure

z = gsw_z_from_p(p, lat);    % output is height (negative for the ocean)
z = - z;


%% Compute buoyancy frequency squared

if ~exist('zcut', 'var')
    N2 = buoyFreqsqrd(z, sgth);
else
    N2 = buoyFreqsqrd(z, sgth, zcut);
end




