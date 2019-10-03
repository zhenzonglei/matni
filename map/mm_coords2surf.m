function [coords_vtx,coords_roi,roi_id] = ...
mm_coords2surf(coords,gii_surf,dist_thr,gii_label)
% [coords_vtx,coords_roi,roi_id] = mm_coords2surf(coords,gii_surf,dist_thr,gii_label)
% mapping set of coords to surface vertex and label 
% gii_surf:  gifti surface object 
% gii_label: gifti scalar object

if nargin < 4, gii_label = []; end
if nargin < 3, dist_thr = 2; end

% Get surf geometry
surf_coords = double(gii_surf.vertices);

% find nearest surf vertex for each coords
n_samp = size(coords,1);
coords_vtx = zeros(n_samp,1);
D = pdist2(coords,surf_coords);
[Y,I] = min(D,[],2); 
coords_vtx(Y < dist_thr) = I(Y < dist_thr);

% map coords to each rois. one coords could be assign multiple rois
if isempty(gii_label)
    n_roi = 1;
    coords_roi = true(n_samp,n_roi);
    roi_id = 1; 
    
else
    % load surf label
    surf_label = gii_label.cdata;
    roi_id = unique(surf_label);
    roi_id(roi_id==0) = [];
    n_roi = length(roi_id);
        
    coords_roi = false(n_samp,n_roi);
    for i = 1:n_roi
        % get coors for a roi
        roi_coords = surf_coords(surf_label==roi_id(i),:);
        
        % samples near the roi Is assigned to the roi
        D = pdist2(coords,roi_coords);
        idx = any(D < dist_thr,2);
        coords_roi(idx,i) = true;
    end
end

