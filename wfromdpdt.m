function wout  = wfrompt(t, p)
% [tout, w] = WFROMPT(t, p)
%
%   inputs:
%       - t: time.
%       - p: pressure.
%
%   outputs:
%       - tout: time for the vertical velocity output.
%       - w: vertical velocity.
%
%
%
% Olavo Badaro Marques, 20/Mar/2017.


%% Make both inputs column vectors:

t = t(:);
p = p(:);


%% A few useful parameters:

limcontmeas = 1/(24*60/5);    % 5 minutes

perday2persec = 1 / (3600*24);


%% Compute w from 

t_diff = diff(t);
p_diff = diff(p);

lskip = (t_diff > limcontmeas);

%
dpdt = p_diff ./ t_diff;

%
dpdt(lskip) = NaN;

%
w = dpdt * perday2persec;

tout = (t(1:end-1) + t(2:end))/2;


%% Filter w 


%%
wout.time = tout;
wout.w = w;