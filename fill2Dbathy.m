function hfill = fill2Dbathy(x, z, zbound, varargin)
% hfill = FILL2DBATHY(x, z, zbound, varargin)
%
%   inputs
%       - x:
%       - z:
%       - zbound (optional):
%
%   outputs
%       - hfill:
%
%
% If z is negative, then just add a negative
% zbound to close the polygon appropriately.
%
% Olavo Badaro Marques, 22/Jun/2018.


%%

if isgraphics(x)

    %
    haxsplt = x;
    
    %
    x = z;
    z = zbound;
    
    if nargin<4
        zbound = [];
    else
        %
        zbound = varargin{1};
        
        %
        if length(varargin)>1
            varargin = varargin(2:end);
        else
            varargin = {};
        end
    end

else
    
    haxsplt = gca;
       
end


%%

if ~exist('zbound', 'var') || isempty(zbound)
	zbound = 5000;
end


%%

xplt = [x; x(end); x(1)];

zplt = [z; zbound; zbound];


%%

def_clrplt = [0.5, 0.5, 0.5];
clr_plt = def_clrplt;


%%

% Turn haxsplt into the current axes handle (newer Matlab
% versions can probably take haxsplt as the first input
% of fill.m, so making these axes current would not be necessary)
axes(haxsplt)

%
hold(haxsplt, 'on')

%
hfill = fill(xplt, zplt, clr_plt);


%%

if ~isempty(varargin)
    for i = 1:(length(varargin)/2)
        hfill.(varargin{2*i - 1}) = varargin{2*i};
    end
end


