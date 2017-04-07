function wout  = wfromdpdt(t, p, ntunits, tskip)
% [tout, w] = WFROMDPDT(t, p, tskip)
%
%   inputs:
%       - t: time.
%       - p: pressure.
%       - ntunits (optional): normalization to the units.
%       - tskip (optional):
%
%   outputs:
%       - tout: time for the vertical velocity output.
%       - w: vertical velocity.
%
%
%
% Olavo Badaro Marques, 20/Mar/2017.


%%


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