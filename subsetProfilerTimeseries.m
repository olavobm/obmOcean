function [xout] = subsetProfilerTimeseries(x, varfields, d, dlims, t, tavgstep)
% [xout] = SUBSETPROFILERTIMESERIES(x, varfields, d, dlims, t, tavgstep)
%
%   inputs:
%       - x:
%       - varfields:
%       - d:
%       - dlims:
%       - t:
%       - tavgstep:
%
%
%   outputs:
%       - xout:
%
%
%
% Olavo Badaro Marques, 13/Mar/2017.


%%


if ischar(d)
    d = {d};
end

indvarcell = d;

indvarlims = dlims;

%
xaux = subsetStruct(indvarcell, indvarlims, x, varfields);

%%

% Take the time difference and identify different profiles:
lsameprof = diff(xaux.(t)) < tavgstep;

inddiffprof = find(~lsameprof);
ndiffprof = length(inddiffprof);


% Pre-allocate:
avgfields = [d, varfields];
xout = xaux;

for i = 1:length(avgfields)
    xout.(avgfields{i}) = NaN(ndiffprof, 1);
end

%
indbeg = 1;

% Loop over profiles and take the average:
for i1 = 1:ndiffprof
    
    indend = inddiffprof(i1);
    
    indavg = indbeg : indend;
    
    for i2 = 1:length(avgfields)
            
            xout.(avgfields{i2})(i1) = mean(xaux.(avgfields{i2})(indavg));
        
    end
   
%     if (xaux.(t)(indend)-xaux.(t)(indbeg)*24*60)>1
%         warning('!!!')
%     end
    
    % Update indice:
    indbeg = indend + 1;
    
end