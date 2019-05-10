function outvar_twyd = dist_towed_vehicle(veh_depth, wire_out)
% outvar_twyd = DIST_TOWED_VEHICLE(veh_depth, wire_out)
%
%   inputs
%       - veh_depth:
%       - wire_out:
%
%   outputs
%       - outvar_twyd: struct variable with the following fields.
%           * towedDist:
%           * angleWire:    (in degrees)
%           * wire_gt_depth:
%           * maxwire:
%           * ind_mw:
%
% This assumes that wire_out has no offset. From my experience,
% ``significant" wire_out offset naturally increases over the
% course of several hours. So watch out for when the wire_out
% may have a big offset.
%
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

