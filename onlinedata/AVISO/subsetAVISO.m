function avisoStruct = subsetAVISO(filename, lonlatbox, timebox)
%% avisoStruct = SUBSETAVISO(filename, subdata)
%
%   inputs:
%       - filename: either one file name with the data
%                   or the directory where the AVISO
%                   data files can be found.
%       - lonlatbox: 1x4 element vector with longitude
%                    and latitude limits (specify
%                    longitude between 0 and 360).
%       - timebox (optional): 1x2 element vector with
%                             datenum time interval.
%                  
%   output:
%       - avisoStruct: the subsetted AVISO data.
%
% Function SUBSETAVISO looks in the directory filename (or possibly only
% one file called filename) and subset the AVISO data for the longitude
% latitude limits specified by lonlatbox (a 1x4 vector). It also subsets
% in time if the input timebox is given.
% 
% The output structure always contains the fields "time", "lon" and
% "lat". For the possible dependent variables, this function loads
% from filename those variables whose names match those specified
% by the "varbase" cell array (defined inside the SUBSETAVISO function).
%
% The output dependent variables are 3-dimensional arrays, with the
% number of rows equal to the number of latitudes, columns for longitudes
% and time increasing in the third dimension.
%
% Olavo Badaro Marques, 25/Dec/2016.


%% Variable names that, if present in *.nc
% data files, will be obtained:

varbase = {'adt', 'msla', 'sla', 'u', 'v'};


%% Structure we assume for the file name:

charbegin  = 'dt_global*';
datesinds  = 25:32;
% datesinds  = 26:33;
dateformat = 'yyyymmdd';


% %% Number of subset time intervals from input:
% nsubsets = size(subdata, 1);


%% Check whether the input filename is the name of
% a directory or a file. In the first case, get
% all the file names in it that we want:

if isdir(filename)
    
    % Get all the file names beginning with charbegin:
    data_struct = dir(fullfile(filename, charbegin));
    datafiles = cell(length(data_struct), 1);
    datafiles(:) = {data_struct.name};
    
    % Get the date from the file names such that we can
    % subset the appropriate files in time:
    timefiles = char(datafiles);
    timefiles = cellstr(timefiles(:, datesinds));

    % Transform to datenum format:
    timefiles = datenum(timefiles, dateformat);
    
    % Put the entire path on the name such that we
    % can load it anywhere they might be:
    datafiles = fullfile(filename, datafiles);
    
    % If input timebox was specified, subset timefiles
    % and datafiles for the time interval:
    if exist('timebox', 'var')
        
        lintime = timefiles>=timebox(1) & timefiles<=timebox(2);

        timefiles = timefiles(lintime);
        datafiles = datafiles(lintime);
    end
    
else
    datafiles = filename;     % otherwise, just get the filename from input
    datafiles = {datafiles};  % make into a cell array, to be consistent
                              % with the datafiles from the other if case
end


%% Load longitude and latitude and subset according to input:

lonvec = ncread(datafiles{1}, 'lon');
latvec = ncread(datafiles{2}, 'lat');

indinlon = find(lonvec >= lonlatbox(1) & lonvec <= lonlatbox(2));
indinlat = find(latvec >= lonlatbox(3) & latvec <= lonlatbox(4));

% make sure this works!!! (remember weird lon limits)

%% See what variables in varbase are found in the .nc files:

infoaux = ncinfo(datafiles{1});
ncallvars = {infoaux.Variables(:).Name};

vars2load = intersect(ncallvars, varbase);


%% Create structure output variable:

avisoStruct.time = timefiles;
avisoStruct.lon = lonvec(indinlon);
avisoStruct.lat = latvec(indinlat);

for i = 1:length(vars2load)
    
    avisoStruct.(vars2load{i}) = NaN(length(avisoStruct.lat), ...
                                     length(avisoStruct.lon), ...
                                     length(avisoStruct.time));
                      
end


%% Loop through datafiles and subset
% each in longitude and latitude:

for i1 = 1:length(vars2load)
    
    for i2 = 1:length(datafiles)
        
        varaux = ncread(datafiles{i2}, vars2load{i1}, ...
                                       [indinlon(1), indinlat(2), 1], ...
                                       [length(indinlon), length(indinlat), 1]);

        avisoStruct.(vars2load{i1})(:, :, i2) = varaux';
    end
    
end



