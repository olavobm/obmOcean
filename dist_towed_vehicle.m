function outvar_twyd = dist_towed_vehicle(veh_depth, wire_out)
% outvar_twyd = DIST_TOWED_VEHICLE(veh_depth, wire_out)
%
%   inputs
%       - veh_depth: vector with the towed vehicle depth, in
%                    meters (i.e. derived from pressure sensor).
%       - wire_out: vector (same length as veh_depth) with the
%                   towyo cable pay out, in meters.
%
%   outputs
%       - outvar_twyd: struct variable with the following fields.
%           * towedDist: the horizontal towyo distance, in meters.
%           * angleWire: angle cable makes with the vertical (in degrees).
%           * l_dgtw: logical value, with true if at least one point has
%                     depth greater than wire (dgtw) out. See comments
%                     below.
%           * maxdiff: maximum difference (in meters, positive value)
%                      for when the depth is greater than the wire out.
%           * ind_maxdiff: index of the input vector correspondent to
%                          the location of "maxdiff" in the input vectors.
%
% DIST_TOWED_VEHICLE.m calculates the horizontal distance of a
% towed vehicle. This is the simplest calculation, that is, it
% assumes the towed cable has no curvature in the water. The
% horizontal distance is then one side of the right triangle,
% where the other sides are "veh_depth" and "wire_out". With
% this assumption, the calculated distance is the maximum possible
% towed horizontal distance (and the real distance may be smaller
% if the cable is curved).
%
%   - This function This is physically impossible but practically possible
%     because the 0 ....
%
%   - Offset should be small...
% 
%   - This assumes that wire_out has no offset. From my experience,
%     ``significant" wire_out offset naturally increases over the
%     course of several hours. So watch out for when the wire_out
%     may have a big offset...
%
%
% TO DO:
%   - Write documentation.
%   - Deal with multiple maxima (this is very unlikely though).
%
% Olavo Badaro Marques, 01/May/2019.

%
diff_depth_wire = wire_out - veh_depth;
ldepth_gt_wout = diff_depth_wire < 0;

%
if any(ldepth_gt_wout)
    
    %
	[max_wiredepth_diff, ind_maxdiff] = min(diff_depth_wire);
    
    if length(ind_maxdiff)~=1
        error('Multiple maxima. Need to improve code!')
    end
    
    %
    wire_out = wire_out + abs(max_wiredepth_diff);
    
else
    
    %
    max_wiredepth_diff = NaN;
    ind_maxdiff = NaN;
    
end


%
cos_wire = veh_depth ./ wire_out;

%
arc_wire = acosd(cos_wire);

%
dist_towed = wire_out .* sind(arc_wire);


%% Organize outpu variable

outvar_twyd.towedDist = dist_towed;
outvar_twyd.angleWire = arc_wire;

%
outvar_twyd.l_dgtw = any(ldepth_gt_wout);
outvar_twyd.maxdiff = abs(max_wiredepth_diff);
outvar_twyd.ind_maxdiff = ind_maxdiff;

