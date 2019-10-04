function [sample_on_surf,label_id,label_name] = ...
    mm_coordsonsurfatlas(sample_coords,atlas,hemi,dist_thr)

%[sample_on_surf,label_id,label_name] = ...
%     mm_coordsonsurfatlas(sample_coords,atlas,hemi,dist_thr)
% sample_coords, N x 3 
% atlas, name of atlas
% hemi, lh or rh
% dist_thr, threshod to determine if a sample could be consider as on the surface

if nargin < 4, dist_thr = 5; end
if nargin < 3 , hemi = 'lh'; end;
if nargin < 2 , atlas = 'benson'; end;


% surf setting
brainmap = '/nfs/e5/stanford/ABA/brainmap';
fsLR_surf = fullfile(brainmap,'surface','fsLR',[hemi '_mid.gii']);
fs_surf = fullfile(brainmap,'surface','fsaverage',[hemi '_mid.gii']);
icbm_surf = fullfile(brainmap,'surface','icbm_sym_avg',[hemi '_mid.gii']);

% label setting
switch atlas
    case 'wang'
        fsurf = fs_surf;
        flabel = fullfile(brainmap,'wang_retinotopy','surf',...
            ' lh.wang2015_atlas_32k_fs_LR.func.gii');
        flabel_name = fullfile(brainmap,'wang_retinotopy','surf','wang_atlas_label.txt');
        
    case 'MPM'
        fsurf = fsLR_surf;
        flabel = fullfile(brainmap,'cytoAtlas','MNI152_cytoMPM_thr25_2mm.nii.gz');
        flabel_name  = fullfile(brainmap,'cytoAtlas','cytoLabelShort.txt');
      
        
    case 'yeo'
        fsurf = icbm_surf;
        flabel = fullfile(brainmap,'yeoAtlas',...
            'Yeo2011_7Networks_MNI152_FreeSurferConformed1mm.nii.gz');
        flabel_name = fullfile(brainmap,'yeoAtlas','Yeo2011_7Networks_label.txt');
        
    case 'benson'
        fsurf = fsLR_surf;
        flabel = fullfile(brainmap,'benson_retinotopy','fs_LR',...
            [hemi,'.benson17_varea_32k_fs_LR.func.gii']);
        flabel_name  = {'V1','V2','V3','hV4','VO1','VO2','LO1','LO2','TO1','TO2','V3b','V3a'};
        
    otherwise
        error('Wrong atals');
end
l
% Map samples onto fsurf
surf = gifti(fsurf); label= gifti(flabel);
[~,coords_roi,label_id] = mm_coordsonsurf(sample_coords,surf,label,dist_thr);
sample_on_surf = coords_roi;


% Read label name
if iscell(flabel_name)
    label_name = flabel_name;
else
    fid = fopen(flabel_name);
    label = textscan(fid,'%d %s');
    label_name = label{2};
    fclose(fid);
end







