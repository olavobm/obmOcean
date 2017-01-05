function avisoStruct = speedRMSAVISO(datapath, lonlatbox, timebox)
% avisoStruct = SPEEDRMSAVISO(datapath, lonlatbox, timebox)
%
%   inputs:
%       - datapath:
%       - lonlatbox:
%       - timebox (optional):
%
% Function SPEEDRMSAVISO computes the root-mean-square of the
% speed from AVISO data.
%
% Olavo Badaro Marques, 04/Jan/2017.


%%

if ~exist('timebox', 'var')
    timebox = [-Inf, +Inf];
end


%%

if isdir(datapath)
    avisodata = subsetAVISO(datapath, lonlatbox, timebox); 
else
    avisodata = load(datapath); 
end


%% Compute speed and its RMS:

% Speed:
avisodata.speed = sqrt(avisodata.u.^2 + avisodata.v.^2);


% RMS:
nlen = size(avisodata.speed, 3);

avisodata.speedrms = sqrt(sum(avisodata.speed.^2, 3) / nlen);


%% Assign output:

avisoStruct = avisodata;
