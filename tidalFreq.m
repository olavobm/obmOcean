function wavefreq = tidalFreq(wavecode)
% wavefreq = TIDALFREQ(wavecode)
%
%   inputs:
%       - wavecode: string (or cell array) with tidal
%                   constituent(s) name(s).
%
%   outputs:
%       - wavefreq: frequency (in cycles per day) of the
%                   tidal constituents requested in the input.
%
% TIDALFREQ returns tidal frequencies (in cycles per day). The 
% function itself contains the definition of the frequency of
% each constituent (a database obtained from the toolbox t_tide,
% by Rich Pawlowicz).
%
% Olavo Badaro Marques, 21/Jul/2017.


%% Make sure input is a cell array

if ~iscell(wavecode)
    wavecode = {wavecode};
end

nWaves = length(wavecode);


%% Database of tidal frequencies

% Periods (in hours)
tidesDataBase.M2.period = 12.4206;
tidesDataBase.S2.period = 12.0000;
tidesDataBase.K1.period = 23.9345;
tidesDataBase.O1.period = 25.8193;


%% Get the names of the tidal constituents in the database
tidalConst = fieldnames(tidesDataBase);
nConst = length(tidalConst);

% Frequency (in cycles per day)
for i = 1:nConst
    
    tidesDataBase.(tidalConst{i}).freq = ...
                                24 / tidesDataBase.(tidalConst{i}).period;
    
end


%% Retrieve the appropriate frequencies from the database

wavefreq = NaN(1, nWaves);

for i = 1:nWaves
    wavefreq(i) = tidesDataBase.(wavecode{i}).freq;
end
