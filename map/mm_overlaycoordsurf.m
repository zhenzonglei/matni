function surf_overlay = mm_overlaycoordsurf(sample_coords,surf_coords,radius)
% mm_overlaycoordsurf(sample_coords,surf_coords,radius)
% radius is in mm

if nargin < 3, radius = 5;end

% Euclidean dist between sample coords and surf coords
D = pdist2(sample_coords,surf_coords);
% count the sample on each vertex
surf_overlay = sum(D < radius);