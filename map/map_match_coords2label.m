function [coords_voi,roi_id] = map_match_coords2label(coords,surf_file,label_file,dist_thr)
% surf_coords,surf_label is from 
if nargin < 4, dist_thr = 2; end

% load surf geometry
surf = gifti(surf_file);
surf_coords = double(surf.vertices);

% load surf label
surf_label = gifti(label_file);
surf_label = surf_label.cdata;
roi_id = unique(surf_label);
roi_id(roi_id==0) = [];
n_roi = length(roi_id);

n_samp = size(coords,1);
coords_voi = false(n_samp,n_roi);
for i = 1:n_roi
    % get coors for a roi
    roi_coords = surf_coords(surf_label==roi_id(i),:);
    
    % samples near the roi Is assigned to the roi
    D = pdist2(coords,roi_coords);
    idx = any(D < dist_thr,2);
    coords_voi(idx,i) = true;
end


