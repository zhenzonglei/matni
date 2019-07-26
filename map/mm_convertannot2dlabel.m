function mm_convertannot2dlabel(annotDir)

% ------------ map vcAtlas to fsLR-------------
brainmap_dir = '/nfs/e5/stanford/ABA/brainmap';
surf_dir = fullfile('HCP','HCP_S1200_GroupAvg_v1');
cd(brainmap_dir)

if nargin < 1
  annotDir = fullfile(brainmap_dir,'vcAtlas'); 
end

%%  vcAtlas to gii
cd(annotDir);
xh = {'lh','rh'};
for h = 1:2
     mris_convert = ...
         sprintf('mris_convert --annot %s.vcAtlas.annot %s.white %s.vcAtlas.func.gii',...
         xh{h},xh{h},xh{h});
    
    system(mris_convert);
end



%% map benson template(gii format) from fsaverage to fs_LR
in_mesh = 164;out_mesh = 32;
raw_hemi = {'lh','rh'};
fs_hemi = {'L','R'};

resamp_fs_dir = 'resample_fsaverage_to_fsLR';
for h = 1:2    
    metric_in = fullfile('kevin_atlas',sprintf('%s.face_place.func.gii', raw_hemi{h}));
    
    metric_out = fullfile('vcAtlas',sprintf('vcAtlas.%s.%dk_fs_LR.func.gii',fs_hemi{h},out_mesh));
    
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
    
    wb_cmd = [wb_cmd,' -largest'];
    
      system(wb_cmd);
end
cd(wdir);


%% gii to dense scalar
cd(brainmap_dir)
lh_metric = fullfile('vcAtlas',sprintf('vcAtlas.%s.32k_fs_LR.func.gii','L'));
rh_metric = fullfile('vcAtlas',sprintf('vcAtlas.%s.32k_fs_LR.func.gii','R'));
lr_metric = fullfile('vcAtlas','vcAtlas.32k_fs_LR.dscalar.nii');
cifti_create_dense_scalar = ...
sprintf('wb_command -cifti-create-dense-scalar %s -left-metric %s -right-metric %s',...
lr_metric,lh_metric, rh_metric);
system(cifti_create_dense_scalar);


%% remove medial wall
template = fullfile(surf_dir,'S1200.MyelinMap_BC_MSMAll.32k_fs_LR.dscalar.nii');
cifti_create_dense_from_template = ...
sprintf('wb_command -cifti-create-dense-from-template %s  %s -cifti %s',template,lr_metric,lr_metric);
system(cifti_create_dense_from_template);



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



%% IMPORT A GIFTI LABEL FILE FROM A METRIC FILE(func.nii or dscalar.nii)
%    wb_command -metric-label-import

% The GIFTI format is an established data file format intended for use with
% surface-based data.  It has subtypes for geometry (.surf.gii), continuous
% data (.func.gii, .shape.gii), and integer label data (.label.gii).  The
% files that contain data, rather than geometry, consist mainly of a 2D array,
% with one dimension having length equal to the number of vertices in the
% surface.  Label files (.label.gii) also contain a list of integer values
% that are used in the file, plus a name and a color for each one.  In
% workbench, the files for continuous data are called 'metric files', and
% .func.gii is usually the preferred extension, but there is no difference in
% file format between .func.gii and .shape.gii.  Geometry files are simply
% called 'surface files', and must contain only the coordinate and triangle
% arrays.  Notably, other software may put data arrays (the equivalent of a
% metric file) into the same file as the geometry information.  Workbench does
% not support this kind of combined format, and you must use other tools to
% separate the data array from the geometry.

