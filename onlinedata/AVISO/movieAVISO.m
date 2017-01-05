function F = movieAVISO(datapath, lonlatbox, timebox)
% MOVIEAVISO(datapath, lonlatbox, timebox)
%
%   inputs:
%       - datapath: directory with 
%       - lonlatbox (optional):
%       - timebox (optional):
%
%
%
% Olavo Badaro Marques, 26/Dec/2016.


%% Subset the data according to the inputs:

if isdir(datapath)
    avisodata = subsetAVISO(datapath, lonlatbox, timebox); 
else
    avisodata = load(datapath); 
end


%%

arrowScale = 50;

lonplt = repmat(avisodata.lon', length(avisodata.lat), 1);
latplt = repmat(avisodata.lat, 1, length(avisodata.lon));
% uplt = squeeze(avisodata.u(:, :, 1));
% vplt = squeeze(avisodata.v(:, :, 1));
% 
% lonplt = lonplt(:);
% latplt = latplt(:);
% uplt = uplt(:);
% vplt = vplt(:);
% 
% makeArrowPlot(arrowScale, lonplt, latplt, uplt, vplt, lonlatbox, [1 1])
% axis equal

%%
% 
movieSvar.indvar1 = avisodata.lon;
movieSvar.indvar2 = avisodata.lat;

movieSvar.datmov = avisodata.sla;
movieSvar.datmov = permute(movieSvar.datmov, [2, 1, 3]);
movieSvar.dimmov = 3;

movieSvar.dintitle = cell(length(avisodata.time), 1);
for i = 1:length(avisodata.time)
    movieSvar.dintitle{i} = datestr(avisodata.time(i));
end

F = obmmovies(movieSvar);
