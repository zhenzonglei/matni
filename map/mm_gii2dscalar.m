function mm_gii2dscalar(lh_gii, rh_gii, lr_cii)
% mm_gii2dscalar(lh_gii, rh_gii, lr_cii)
% convert scalar gii maps from two hemispheres 
% into a scalar cii file

% convert two gifti scalar maps to a dscalar cifti map
cifti_create_dense_scalar = ...
sprintf('wb_command -cifti-create-dense-scalar %s -left-metric %s -right-metric %s',...
lr_cii,lh_gii, rh_gii);
system(cifti_create_dense_scalar);


% remove medial wall of cifti
template = fullfile('/nfs/e5/stanford/ABA/brainmap/HCP/HCP_S1200_GroupAvg_v1',...
    'S1200.MyelinMap_BC_MSMAll.32k_fs_LR.dscalar.nii');
cifti_create_dense_from_template = ...
sprintf('wb_command -cifti-create-dense-from-template %s  %s -cifti %s',template,lr_cii,lr_cii);
system(cifti_create_dense_from_template);
