function [coords_vox,coords_roi,roi_id] = mm_coords2vol(coords,roi_file, dist_thr)
% [coords_vox,coords_roi,roi_id] = mm_matchcoords2vol(coords,roi_file, dist_thr)
% map set of coords to voxel and roi in volume space

if nargin < 3, dist_thr = 2; end

% load roi vol
ni = niftiRead(roi_file);

% match coords to voxel
crs = mrAnatXformCoords(ni.qto_ijk, coords);
coords_vox = sub2ind(size(ni.data),crs(:,1), crs(:,2),crs(:,3));

% match coords to roi
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


