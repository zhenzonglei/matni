function [sample_data,sample_idx]  = mm_vol2sample(nii_vol,sample_coords,...
    nii_data,dist_thr,interp)
% [sample_data,sample_idx]  = mm_vol2sample(nii_vol,sample_coords,...
%     nii_data,dist_thr,interp)
% nii_vol and sample_coords are asssumed in the same space, 
% such as MNI152 space.
% ineterp, nn(Nearest Neighbor), nm(Neighbor Mean), nw(Neighbor weighted)
% sample_data, the vol data projected on the sample. If no vol data are 
% provided,sample_data are number of projected voxel for each sample
% sample_idx, the index of the sample which has voxel projected on


if nargin < 5, interp  = 'nm';end
if nargin < 4, dist_thr = 5; end
if nargin < 3, nii_data = [];end

% source coords
mask = nii_vol.data ~= 0;
[ic,ir,is] = ind2sub(size(mask),find(mask));
src_coords = mrAnatXformCoords(nii_vol.qto_xyz, [ic,ir,is]);

% source data
if ~isempty(nii_data)
    src_data = nii_data.data;
end

% target coords
targ_coords = sample_coords;

[sample_data,sample_idx] = mm_neighborinterp(src_coords,targ_coords, ...
    src_data,dist_thr,interp);