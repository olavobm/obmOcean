function N2 = buoyFreqsqrd(z, sgth, zcut, ptscode, rho0, g)
% N2 = BUOYFREQSQRD(z, sgth, zcut, ptscode, rho0, g)
%
%   inputs:
%       - z: pressure increasing downwards.
%       - sgth: potential density (vector or matrix).
%       - zcut (optional): 
%       - ptscode (optional): integer greater or equal than 1. This code
%                             indicates to whether to compute at the mid
%                             points where input is given (default) or to
%                             use a centered difference to compute in the
%                             interior points where the input is given.
%       - rho0 (optional): density reference.
%       - g (optional): gravitational acceleration (default is Earth's g).
%
%   outputs:
%       - N2: structure with two fields -- (1) z, the location in the
%             vertical and (2) N2, the buoyancy frequency squared, in
%             (radians/s)^2.
%
% Note that N2 is negative if density above is greater than below.
%
% To obtain frequency in cycles/s, do sqrt(N2)/(2*pi).
%
% Olavo Badaro Marques, 20/Apr/2017.


%% Set constant values:

if ~exist('g', 'var')
    g = 9.7963;
end

if ~exist('rho0', 'var')
    rho0 = 1025;
end


%% Set optional values:

if ~exist('ptscode', 'var')
    ptscode = 1;
else
    
    ptscode_list = [1, 2];
    
    if ~any(ptscode_list == ptscode)
        error(['Input ptscode does not match any of the implemented ' ...
               'integers (see variable ptscode_list).m'])
    end
end

if ~exist('zcut', 'var')
    zcut = +Inf;
end



%% Compute the d(sgth)/dz using different discretizations
% depending indicated by input ptscode:

if ptscode==1
    
    N2.z = (z(1:end-1) + z(2:end))/2;
    
    N2.N2 = (sgth(2:end, :) - sgth(1:end-1, :)) ./ ...
             repmat(z(2:end) - z(1:end-1), 1, size(sgth, 2));
    
elseif ptscode==2
    
    N2.z = z(2:end-1);
    
    N2.N2 = centeredDeriv(z, sgth);
    % At some point, I should implement xcut inside centeredDeriv
    
    % Exclude the edges (where my function
    % computes forward/backward differences:
    N2.N2 = N2.N2(2:end-1, :);
    
end


%% For finite input zcut, substitute N2 by NaN
% where the input spacing is larger than zcut:

if ~isinf(zcut)
    
    dz = z(2:end) - z(1:end-1);

    if ptscode==1

        lbigdz = (dz > zcut);
       
    elseif ptscode==2

        lbigdz = (dz(1:end-1)>zcut || dz(1:end-2)>zcut);
    end
    
    % Add NaN where the vertical difference is too big:
    N2.N2(lbigdz, :) = NaN;
    
end


%% Scale N2 by the constants:

N2.N2 = (g/rho0) * N2.N2;


