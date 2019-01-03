function map_convert_vol2fsLR(atlasDir)

%% map cytoAtlas to fsLR
brainmap_dir = '/nfs/e5/stanford/ABA/brainmap';
surf_dir = fullfile('HCP','HCP_S1200_GroupAvg_v1');
cd(brainmap_dir)


hemi = {'L','R'};
for h = 1:2
    surface = fullfile(surf_dir, ...
        sprintf('S1200.%s.midthickness_MSMAll.32k_fs_LR.surf.gii',hemi{h}));
    in_surf  = fullfile(surf_dir, ...
        sprintf('S1200.%s.white_MSMAll.32k_fs_LR.surf.gii',hemi{h}));
    out_surf = fullfile(surf_dir, ...
        sprintf('S1200.%s.pial_MSMAll.32k_fs_LR.surf.gii',hemi{h}));
    volume = fullfile('cytoAtlas','cytoPM.nii.gz');
    metric_out = fullfile('cytoAtlas',sprintf('cytoPM.%s.func.gii',hemi{h}));
    
    
    vol_to_surf_mapping = ...
    sprintf('wb_command -volume-to-surface-mapping %s %s %s -ribbon-constrained %s %s',...
        volume, surface,metric_out,in_surf,out_surf);
    
    %
    % vol_to_surf_mapping = ...
    % sprintf('wb_command -volume-to-surface-mapping %s %s %s -trilinear',...
    %     volume, surface,metric_out);
    
%     
%     vol_to_surf_mapping = ...
%         sprintf('wb_command -volume-to-surface-mapping %s %s %s -enclosing',...
%         volume, surface,metric_out);
    
    system(vol_to_surf_mapping);
    
end


%% gii to dense scalar
lh_metric = fullfile('cytoAtlas',sprintf('cytoPM.%s.func.gii','L'));
rh_metric = fullfile('cytoAtlas',sprintf('cytoPM.%s.func.gii','R'));
lr_metric = fullfile('cytoAtlas','cytoPM.32k_fs_LR.dscalar.nii');
cifti_create_dense_scalar = ...
sprintf('wb_command -cifti-create-dense-scalar %s -left-metric %s -right-metric %s',...
lr_metric,lh_metric, rh_metric);
system(cifti_create_dense_scalar);


%% remove medial wall
template = fullfile(surf_dir,'S1200.MyelinMap_BC_MSMAll.32k_fs_LR.dscalar.nii');
cifti_create_dense_from_template = ...
sprintf('wb_command -cifti-create-dense-from-template %s  %s -cifti %s',template,lr_metric,lr_metric);
system(cifti_create_dense_from_template);



%% make mpm file
wb_dir = '/usr/local/neurosoft/workbench/bin_linux64/wb_command';
cii = ciftiopen(lr_metric,wb_dir);
pm = cii.cdata;

pm(:,[1:80,94:100]) = 0;

pm = [zeros(size(pm,1),1), pm];

pm(pm < 0.25) = 0;

[~,mpm] = max(pm,[],2);
mpm(mpm~=0) = mpm(mpm~=0)-1;

nnz(unique(mpm))
cii.cdata = mpm; 
mpm_file = fullfile('cytoAtlas','cytoMPM_thr25.32k_fs_LR.dscalar.nii');
ciftisavereset(cii, mpm_file,wb_dir);


%% make label file and convert to dlabel
label_txt  = fullfile('cytoAtlas','cytoLabel.txt');
fid = fopen(label_txt);
label = textscan(fid,'%d %s');
roi_id = label{1}; roi_name = label{2};
fclose(fid);

label_id = unique(mpm);
label_id(label_id==0) = [];
n_label = length(label_id);
label_color = round(linspecer(n_label)*255);

p = randperm(n_label);
label_color = label_color(p,:);

cifti_label  = fullfile('cytoAtlas','cytoLabel_cifti');
fid = fopen(cifti_label,'w');
for i = 1:n_label
    L = label_id(i);
    
    fprintf(fid,'%s\n%d %d %d %d %d\n',...
        roi_name{L},roi_id(L),label_color(i,1),label_color(i,2),label_color(i,3),255);
    
end
fclose(fid);



%% Using -cifti-label-import to convert dscalar.nii to dlabel.nii
mpm_label_file = strrep(mpm_file,'dscalar','dlabel'); 
cifti_label_import = ...
  sprintf('wb_command -cifti-label-import %s %s %s',mpm_file, label_cifti,mpm_label_file);
system(cifti_label_import);





