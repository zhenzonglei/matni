function surf_idx = map_match_coords2surf(coords,surf_file,dist_thr)
% surf_coords,surf_label is from 
if nargin < 4, dist_thr = 2; end

% load surf geometry
surf = gifti(surf_file);
surf_coords = double(surf.vertices);

% find nearest surf node for each coords
D = pdist2(coords,surf_coords);
surf_idx = any(D < dist_thr,2);


