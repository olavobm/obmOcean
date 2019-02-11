function trackStruct = trackfromPoints(lonlatpts, npts)
% TRACKSTRUCT = TRACKFROMPOINTS(lonlatpts, npts)
%
%   inputs
%       - lonlatpts: Nx2 matrix with longitudes (first column)
%                    and latitudes (second column) of the points
%                    we want to go through on the track.
%       - npts: if npts is a vector, then it only contains
%               the number of points in between the reference
%               points (which is different than when it is a scalar).
%
%   outputs
%       - trackStruct: structure with the following fields:
%               * lon: longitude.
%               * lat: latitude.
%               * dist: distance (in km) from the (lon, lat).
%
%
%
%
% TO DO:
%   - This function creates coordinates with equal number of
%     points, such that the spacing is varying between segments.
%     I might also want to include equal spacing as opposed to
%     equal number of points.
%
% Olavo Badaro Marques, 10/Feb/2019.


%% First get the number of refenrence
% points and segments (between points)

Npts_ref = size(lonlatpts, 1);
Nseg_ref = Npts_ref - 1;


%% Now get a vector "npts_perseg" with the total number of
% points in each segment (without counting the reference
% points). Also get the (scalar) total number of points Ntotal

if length(npts)==1
    
    %
    npts_between = npts - Npts_ref;
    
	%
    npts_perseg_scalar = floor(npts_between./Nseg_ref);
    npts_perseg_extra = mod(npts_between, Nseg_ref);
    npts_perseg = npts_perseg_scalar .* ones(Nseg_ref, 1);
    
    %
    Ntotal = npts;
    
    %
    if npts_perseg_extra~=0
        
        %
        nadd_extra = ones(npts_perseg_extra, 1);
        npts_perseg(1:npts_perseg_extra) = npts_perseg(1:npts_perseg_extra) + nadd_extra;
        
    end
        

else
    
    %
    npts_perseg = npts;
    
    %
    Ntotal = sum(npts_perseg) + Npts_ref;
    
end


%% Pre-allocate space for the coordinates

%
trackStruct.lon = NaN(Ntotal, 1);
trackStruct.lat = NaN(Ntotal, 1);


%% Now find the locations where the reference
% points are added and just fill them (lonlatpts)
% into the output structure

%
npts_perseg_all = NaN(2*Npts_ref-1, 1);
npts_perseg_all(1) = 1;

%
for i = 2:length(npts_perseg_all)
    if mod(i, 2)==0
        npts_perseg_all(i) = npts_perseg(i/2);
    else
        npts_perseg_all(i) = 1;
    end
	
end

%
cs_npts = cumsum(npts_perseg_all);

%
inds_all_aux = 1:length(npts_perseg_all);
lfill_ref = (mod(inds_all_aux, 2)~=0);

%
inds_fill_ref = cs_npts(lfill_ref);

%
trackStruct.lon(inds_fill_ref) = lonlatpts(:, 1);
trackStruct.lat(inds_fill_ref) = lonlatpts(:, 2);


%% For each segment between reference points, calculate
% the coordinates for evenly spaced coordinates (in this
% segment only) along the great circle (i.e. shortest
% path) between the two reference points

%
for i = 1:Nseg_ref
    
    %
    [dist_aux, az_aux] = distance(lonlatpts(i, 2), lonlatpts(i, 1), ...
                                  lonlatpts(i+1, 2), lonlatpts(i+1, 1));
                              
    %
    dists_perseg_aux = linspace(0, dist_aux, npts_perseg(i)+2);
    
    %
    [lat_perseg_aux, ...
     lon_perseg_aux] = reckon(lonlatpts(i, 2), lonlatpts(i, 1), ...
                              dists_perseg_aux, az_aux);
	     
                          
	%
    inds_fill_aux = inds_fill_ref(i)+1:inds_fill_ref(i+1)-1;
    
    %
    trackStruct.lon(inds_fill_aux) = lon_perseg_aux(2:end-1);
    trackStruct.lat(inds_fill_aux) = lat_perseg_aux(2:end-1);
    
end


%% Calculate distance between points and do cumulative
% sum to get distance from the starting coordinate

all_dist_diff = distance([trackStruct.lat(1:end-1), trackStruct.lon(1:end-1)], ...
                         [trackStruct.lat(2:end), trackStruct.lon(2:end)]);
                     
all_dist_diff = deg2km(all_dist_diff);

all_dist_cs = cumsum(all_dist_diff);

trackStruct.dist = [0; all_dist_cs];
