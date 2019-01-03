function map_convert_fs2fsLR(data_file_str,cifti_label_table)
% fs_to_fsLR(data_file,label_file)
% data_file_str, the data to be converted in gifti format. if data file 
% is named like rh.mydata.gii, then data_file_str should be mydata.
% The funciton should be run in the dir which data_file located

if nargin < 2, cifti_label_table = []; end



%% map benson template(gii format) from fsaverage to fs_LR
in_mesh = 164;out_mesh = 32;
raw_hemi = {'lh','rh'};
fs_hemi = {'L','R'};

resamp_fs_dir = fullfile('/nfs/e5/stanford/ABA/brainmap','resample_fsaverage_to_fsLR');
for h = 1:2
    metric_in = sprintf('%s.%s.gii', raw_hemi{h},data_file_str);
    
    metric_out = sprintf('%s.%s.%dk_fs_LR.gii',data_file_str,fs_hemi{h},out_mesh);
    
    curr_sph = fullfile(resamp_fs_dir,...
        sprintf('fsaverage_std_sphere.%s.%dk_fsavg_%s.surf.gii',fs_hemi{h},in_mesh,fs_hemi{h}));
    
    new_sph = fullfile(resamp_fs_dir,...
        sprintf('fs_LR-deformed_to-fsaverage.%s.sphere.%dk_fs_LR.surf.gii',fs_hemi{h},out_mesh));
    
    curr_area =  fullfile(resamp_fs_dir,...
        sprintf('fsaverage.%s.midthickness_va_avg.%dk_fsavg_%s.shape.gii',fs_hemi{h},in_mesh,fs_hemi{h}));
    
    new_area =  fullfile(resamp_fs_dir,...
        sprintf('fs_LR.%s.midthickness_va_avg.%dk_fs_LR.shape.gii',fs_hemi{h},out_mesh));
    
    wb_cmd = sprintf('wb_command -metric-resample %s %s %s ADAP_BARY_AREA %s -area-metrics %s %s',...
        metric_in, curr_sph, new_sph, metric_out, curr_area, new_area);
    
    if ~isempty(cifti_label_table)
        wb_cmd = [wb_cmd,' -largest'];
    end
    
    system(wb_cmd);
end

%% gii to dense scalar
lh_metric = sprintf('%s.%s.32k_fs_LR.gii',data_file_str,'L');
rh_metric = sprintf('%s.%s.32k_fs_LR.gii',data_file_str, 'R');
lr_metric = sprintf('%s.32k_fs_LR.dscalar.nii', data_file_str);
cifti_create_dense_scalar = ...
sprintf('wb_command -cifti-create-dense-scalar %s -left-metric %s -right-metric %s',...
lr_metric,lh_metric, rh_metric);
system(cifti_create_dense_scalar);


%% remove medial wall
surf_dir = fullfile('/nfs/e5/stanford/ABA/brainmap','HCP','HCP_S1200_GroupAvg_v1');
template = fullfile(surf_dir,'S1200.MyelinMap_BC_MSMAll.32k_fs_LR.dscalar.nii');
cifti_create_dense_from_template = ...
sprintf('wb_command -cifti-create-dense-from-template %s  %s -cifti %s',template,lr_metric,lr_metric);
system(cifti_create_dense_from_template);




%% Using -cifti-label-import to convert dscalar.nii to dlabel.nii
if ~isempty(cifti_label_table)
    scalar_file = sprintf('%s.32k_fs_LR.dscalar.nii', data_file_str);
    label_file = strrep(scalar_file,'dscalar','dlabel');
    cifti_label_import = ...
        sprintf('wb_command -cifti-label-import %s %s %s',scalar_file, cifti_label_table, label_file);
    system(cifti_label_import);
end


% %% make label file and convert to dlabel
% label_txt  = fullfile('cytoAtlas','cytoLabel.txt');
% fid = fopen(label_txt);
% label = textscan(fid,'%d %s');
% roi_id = label{1}; roi_name = label{2};
% fclose(fid);
% 
% label_id = unique(mpm);
% label_id(label_id==0) = [];
% n_label = length(label_id);
% label_color = round(linspecer(n_label)*255);
% 
% p = randperm(n_label);
% label_color = label_color(p,:);
% 
% cifti_label  = fullfile('cytoAtlas','cytoLabel_cifti');
% fid = fopen(cifti_label,'w');
% for i = 1:n_label
%     L = label_id(i);
%     
%     fprintf(fid,'%s\n%d %d %d %d %d\n',...
%         roi_name{L},roi_id(L),label_color(i,1),label_color(i,2),label_color(i,3),255);
%     
% end
% fclose(fid);



