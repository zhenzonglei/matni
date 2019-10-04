function mm_writenii(nii_ref, vol_data, vol_idx, fout)
% mm_writenii(nii_ref, vol_data, vol_idx, fout)
% fout, filename for output gii file
% vol_data, N sample * M features
% vol_idx, index of vertics, Nx1
% fout, string if filename

% assemble data into nii
sdim = nii_ref.dim(1:3); tdim = size(data,2);
D = zeros(prod(sdim),tdim);
D(vol_idx,:) = vol_data;
D = reshape(D,[sdim,tdim]);
nii_ref.data = D;
nii_ref.cal_min = min(D(:));
nii_ref.cal_max = max(D(:));
nii_ref.dim = size(D);

% write the nifti file
nii_ref.fname = fout;
niftiWrite(nii_ref);




