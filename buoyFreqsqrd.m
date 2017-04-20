function N2 = buoyFreqsqrd(sgth, p, rho0)
% N2 = BUOYFREQSQRD(sgth, p, rho0)
%
%   inputs:
%       -
%       -
%       -
%
%   outputs:
%       -
%
% If you want to have the buoyancy frequency in [cyc/s] then
% calculate sqrt(n2)./(2*pi).
%
% Olavo Badaro Marques, 20/Apr/2017.


%%

g  = 9.80655;

if ~exist('rho0', 'var')
    rho0 = 1025;
end


%%

N2 = ;

N2 = g/rho0 * N2;


%%


MMP.n2 = NaN(size(MMP.sgthlow));
for i = 1:length(MMP.yday)
    indok = find(~isnan(MMP.sgthlow(:, i)));
    MMP.n2(indok, i) = centeredDeriv(MMP.z2(indok), MMP.sgthlow(indok, i));
end

% Scale by g and rho_0 to make it N2:
MMP.n2 = MMP.n2 .* (9.8/1025);
