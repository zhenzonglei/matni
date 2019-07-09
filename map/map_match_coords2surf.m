function [coords_vtx,coords_roi,roi_id] = ...
map_match_coords2surf(coords,surf_file,dist_thr,label_file)
% [coords_vtx,coords_roi,roi_id] = ...
% map_match_coords2surf(coords,surf_file,dist_thr,label_file)
% mapping set of coords to surface vertex and label 


if nargin < 4, label_file = []; end
if nargin < 3, dist_thr = 2; end

% load surf geometry
surf = gifti(surf_file);
surf_coords = double(surf.vertices);

% find nearest surf node for each coords
D = pdist2(coords,surf_coords);
coords_vtx = find(any(D < dist_thr,2));

n_samp = size(coords,1);
if isempty(label_file)
    n_roi = 1;
    coords_roi = true(n_samp,n_roi);
    roi_id = 1; 
    
else
    % load surf label
    surf_label = gifti(label_file);
    surf_label = surf_label.cdata;
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
