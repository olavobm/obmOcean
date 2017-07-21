function wavefreq = tidalFreq(wavecode)
% wavefreq = TIDALFREQ(wavecode)
%
%   inputs:
%       - wavecode:
%
%   outputs:
%       - wavefreq:
%
%
% Olavo Badaro Marques, 21/Jul/2017.


%%
if ~iscell(wavecode)
    wavecode = {wavecode};
end

nWaves = length(wavecode);


%% Database of tidal frequencies

% Periods (in hours)
tidesDataBase.M2.period = 12.42;
tidesDataBase.K1.period = 24;
% tidesDataBase.S2.period = ;
% tidesDataBase.O1.period = ;

% Get the names of the tidal constituents in the database
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
