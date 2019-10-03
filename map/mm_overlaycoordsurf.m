function surf_overlay = mm_overlaycoordsurf(sample_coords,gii_surf,radius)
% surf_overlay = mm_overlaycoordsurf(sample_coords,surf_coords,radius)
% radius is in mm

if nargin < 3, radius = 5;end

% surf coordinates N x 3
surf_coords = gii_surf.vertices; 
 
% Euclidean dist between sample coords and surf coords
D = pdist2(sample_coords,surf_coords);


% count the sample on each vertex
surf_overlay = sum(D < radius)';