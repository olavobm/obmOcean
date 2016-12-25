function avisoStruct = subsetAVISO(filename, lonlatbox, timebox)
%% avisoStruct = SUBSETAVISO(filename, subdata)
%
%   inputs:
%       - filename: either one file name with the data or the directory
%                where the AVISO data files can be found.
%       - lonlatbox: 1x4 element vector with longitude
%                    and latitude limits.
%       - timebox (optional): 1x4 element vector with longitude
%                             and latitude limits.
%                  
%   output:
%       - avisoStruct: the subsetted AVISO data.
%
%
%
%
% Olavo Badaro Marques, 25/Dec/2016.
