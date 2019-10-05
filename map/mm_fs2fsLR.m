function mm_fs2fsLR(fs_map,hemi,fs_res,fsLR_res)
% mm_fs2fsLR(fs_map,hemi,fs_res,fsLR_res)
% Transform fs surface map to fsLR surface map
% hemi, lh or rh
% fs_map, fs map file in gii format
% fs_res and fsLR_res: mesh resolution for fs and fsLR

if nargin < 4, fsLR_res = '32k';end
if nargin < 3, fs_res = '164k';end
if strcmp(hemi,'lh')
    hemi = 'L';
elseif strcmp(hemi,'rh')
    hemi = 'R';
else
    error('hemi should be lh or rh');
end

rsfs = fullfile('/nfs/e5/stanford/ABA/brainmap/surface',...
'standard_mesh_atlases/resample_fsaverage');


[map_dir,map_name,map_ext] = fileparts(fs_map);
fsLR_map = fullfile(map_dir,sprintf('%s_fsLR.%s',map_name, map_ext));


fs_sph = fullfile(rsfs,...
    sprintf('fsaverage_std_sphere.%s.%s_fsavg_%s.surf.gii',hemi,fs_res,hemi));

fsLR_sph = fullfile(rsfs,...
    sprintf('fs_LR-deformed_to-fsaverage.%s.sphere.%s_fs_LR.surf.gii',hemi,fsLR_res));

fs_shape =  fullfile(rsfs,...
    sprintf('fsaverage.%s.midthickness_va_avg.%s_fsavg_%s.shape.gii',hemi,fs_res,hemi));

fsLR_shape =  fullfile(rsfs,...
    sprintf('fs_LR.%s.midthickness_va_avg.%s_fs_LR.shape.gii',hemi,fsLR_res));

wb_cmd = sprintf('wb_command -metric-resample %s %s %s ADAP_BARY_AREA %s -area-metrics %s %s',...
    fs_map, fs_sph, fsLR_sph, fsLR_map, fs_shape, fsLR_shape);
system(wb_cmd);



% %% gii to dense scalar
% lh_metric = sprintf('%s.%s.32k_fs_LR.gii',data_file_str,'L');
% rh_metric = sprintf('%s.%s.32k_fs_LR.gii',data_file_str, 'R');
% lr_metric = sprintf('%s.32k_fs_LR.dscalar.nii', data_file_str);
% cifti_create_dense_scalar = ...
% sprintf('wb_command -cifti-create-dense-scalar %s -left-metric %s -right-metric %s',...
% lr_metric,lh_metric, rh_metric);
% system(cifti_create_dense_scalar);
% 
% 
% %% remove medial wall
% surf_dir = fullfile('/nfs/e5/stanford/ABA/brainmap','HCP','HCP_S1200_GroupAvg_v1');
% template = fullfile(surf_dir,'S1200.MyelinMap_BC_MSMAll.32k_fs_LR.dscalar.nii');
% cifti_create_dense_from_template = ...
% sprintf('wb_command -cifti-create-dense-from-template %s  %s -cifti %s',template,lr_metric,lr_metric);
% system(cifti_create_dense_from_template);
% 
% 
% 
% 
% %% Using -cifti-label-import to convert dscalar.nii to dlabel.nii
% if ~isempty(cifti_label_table)
%     scalar_file = sprintf('%s.32k_fs_LR.dscalar.nii', data_file_str);
%     label_file = strrep(scalar_file,'dscalar','dlabel');
%     cifti_label_import = ...
%         sprintf('wb_command -cifti-label-import %s %s %s',scalar_file, cifti_label_table, label_file);
%     system(cifti_label_import);
% end

