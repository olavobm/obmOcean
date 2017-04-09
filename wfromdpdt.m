function wout  = wfromdpdt(t, p, ntunits, tskip)
% wout = WFROMDPDT(t, p, ntunits, tskip)
%
%   inputs:
%       - t: time vector.
%       - p: pressure (same length as t).
%       - ntunits (optional): normalization to the units.
%       - tskip (optional): time difference to disconsider the
%                           calculation between two pressure values.
%
%   outputs:
%       - tout: time for the vertical velocity output.
%       - w: vertical velocity.
%
% Compute vertical velocity (w) from differentiating a
% pressure time series. This can be an useful calculation
% for profiling instuments in the ocean.
%
% The optional input ntunits can be used to return the output
% in the units the user prefer. Input tskip is useful in the
% case when the time series has gaps.
%
% Olavo Badaro Marques, 20/Mar/2017.


%% If ntunits is not given, choose default value of 1:


if ~exist('ntunits', 'var') || isempty(ntunits)
    warning(['ntunits is not given as input. For now, make sure the ' ...
             'script is not expecting the old version of ' ...
             'function ' mfilename ''])
    ntunits = 1;
end


%% A few useful parameters:

if ~exist('tskip', 'var')
    warning(['tskip is not given as input. For now, make sure the ' ...
             'script is not expecting the old version of ' ...
             'function ' mfilename ''])
    tskip = Inf;
end


%% Make both inputs column vectors:

t = t(:);
p = p(:);


%% Compute w from pressure differentiation:

t_diff = diff(t);
p_diff = diff(p);

lskip = (t_diff > tskip);

%
dpdt = p_diff ./ t_diff;

%
dpdt(lskip) = NaN;

%
w = dpdt / ntunits;

tout = (t(1:end-1) + t(2:end))/2;


%% Have an option to filter w (which is noisy after differentiation)


%% Assign output:

wout.time = tout;
wout.w = w;