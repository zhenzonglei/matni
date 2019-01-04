function [coords_vox,coords_roi,roi_id] = map_match_coords2vol(coords,roi_file, dist_thr)
% [coords_vox,coords_roi,roi_id] = map_match_coords2vol(coords,roi_file, dist_thr)
% map set of coords to voxel and roi in volume space

if nargin < 3, dist_thr = 2; end

% load roi vol
ni = niftiRead(roi_file);

% match coords to voxel
[I,J,K] =  ind2sub(size(ni.data),find(ni.data));
vol_coords = mrAnatXformCoords(ni.qto_xyz, [I,J,K]);
D = pdist2(coords,vol_coords);
coords_vox = find(any(D < dist_thr,2));

% mathc coords to roi
roi_id = unique(ni.data(:));
roi_id(roi_id==0) = [];
n_roi = length(roi_id);
n_samp = size(coords,1);
coords_roi = false(n_samp,n_roi);
for i = 1:n_roi
    % get mni coors for a roi
    [I,J,K] =  ind2sub(size(ni.data),find(ni.data == roi_id(i)));
    roi_mni_coords = mrAnatXformCoords(ni.qto_xyz, [I,J,K]);
    
    % samples near the roi Is assigned to the roi
    D = pdist2(coords,roi_mni_coords);
    I = any(D < dist_thr,2);
    coords_roi(I,i) = true;
end


