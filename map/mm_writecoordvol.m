function mm_writecoordvol(nii_fout,nii_fin,sample_coords,sample_data, ...
 dist_thr,interp)
% [vol_data,vol_idx] = mm_sample2vol(fout,sample_coords,nii_vol,sample_coords, ...
% dist_thr,interp)
% fout, file name for output nifti file
% nii_vol and sample_coords are asssumed in the same space, such as MNI152
% surface
% nii_vol, nifti object
% ineterp, nn(Nearest Neighbor), nm(Neighbor Mean), nw(Neighbor weighted)
% vol_data, the sample data projected on the volume. zeros are assigned to 
% the vox which has no samples projected on. If no sample data are provided, 
% vol_data are number of projected samples in each voxel 

if nargin < 5, interp  = 'nm';end
if nargin < 4, dist_thr = 5; end
if nargin < 3, sample_data = [];end

% read volume
nii_vol = niftiRead(nii_fin);

% project sample data into the volume
[vol_data,vol_idx] = mm_sample2vol(sample_coords,nii_vol,sample_data, ...
    dist_thr,interp);

% organize the data into volume
if isempty(sample_data)
    D = zeros(nii_vol.dim(1:3));
    D(vol_idx) = vol_data;
else
    sdim = nii_vol.dim(1:3); tdim = size(sdata,2);
    D = zeros(prod(sdim),tdim);
    D(vol_idx,:) = vol_data;
    D = reshape(D,[sdim,tdim]);
end
nii_vol.data = D;
nii_vol.cal_min = min(D(:));
nii_vol.cal_max = max(D(:));
nii_vol.dim = size(D);

% write the nifti file
nii_vol.fname = nii_fout;
niftiWrite(nii_vol);




