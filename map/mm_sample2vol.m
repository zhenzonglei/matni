function [vol_data,vol_idx] = mm_sample2vol(sample_coords,nii_vol, ...
    sample_data,dist_thr,interp)
% [vol_data,vol_idx] = mm_sample2vol(sample_coords,nii_vol, ...
%     sample_data,dist_thr,interp)
% nii_vol and sample_coords are asssumed in the same space, such as MNI152
% surface
% nii_vol, nifti object
% ineterp, nn(Nearest Neighbor), nm(Neighbor Mean), nw(Neighbor weighted)
% vol_data, the sample data projected on the volume. zeros are assigned to 
% the vox which has no samples projected on. If no sample data are provided, 
% vol_data are number of projected samples in each voxel 
% radius is in mm

if nargin < 5, interp  = 'nm';end
if nargin < 4, dist_thr = 5; end
if nargin < 3, sample_data = [];end


src_coords = sample_coords; 
src_data = sample_data;

% get the targ coords
mask = nii_vol.data(:,:,:, 1) ~= 0;mask_idx = find(mask);

[ic,ir,is] = ind2sub(size(mask),mask_idx);
targ_coords = mrAnatXformCoords(nii_vol.qto_xyz, [ic,ir,is]);
[vol_data,vol_idx] = mm_neighborinterp(src_coords,targ_coords, ...
    src_data,dist_thr,interp);

% convrt index in the coords array to index in the volume
vol_idx = mask_idx(vol_idx);









