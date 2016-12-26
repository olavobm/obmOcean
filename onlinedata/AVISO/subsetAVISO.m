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
%
%
%
% Olavo Badaro Marques, 25/Dec/2016.


%% Structure we assume for the file name:

charbegin  = 'dt_global*';
datesinds  = 25:32;
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

%% Create structure output variable:

avisoStruct.time = timefiles;
avisoStruct.lon = lonvec(indinlon);
avisoStruct.lat = latvec(indinlat);
avisoStruct.adt = NaN(length(avisoStruct.lat), ...
                      length(avisoStruct.lon), ...
                      length(avisoStruct.time));


%% Loop through datafiles and subset
% each in longitude and latitude:

for i = 1:length(datafiles)
    
    varaux = ncread(datafiles{i}, 'adt', ...
                                  [indinlon(1), indinlat(2), 1], ...
                                  [length(indinlon), length(indinlat), 1]);
                              
	avisoStruct.adt(:, :, i) = varaux';
end

