function [roi_value,roi_id,roi_name] = mm_readroiscalar(scalar_vol, roi_atlas, isnorm)
% [roi_value,roi_id,roi_name] = mm_read_roiscalar(scalar_vol, roi_atlas)
% Read scalar value from volume from a set of roi in an atlas


if nargin < 3, isnorm = true; end

data_dir = '/nfs/e5/stanford/ABA/brainmap';
switch roi_atlas
    case 'wang'
        atlas = fullfile(data_dir,'wang_retinotopy','vol','MNI152_MPM_1mm.nii.gz');
        label = fullfile(data_dir,'wang_retinotopy','vol','wang_atlas_label.txt');
        
    case 'cyto'
        atlas = fullfile(data_dir,'cytoAtlas','MNI152_cytoMPM_thr25_2mm.nii.gz');
        label = fullfile(data_dir,'cytoAtlas','cytoLabelShort.txt');
        % label = fullfile(data_dir,'cytoAtlas','cytoLabel.txt');
        
        
    case 'fconn'
        atlas = fullfile(data_dir,'buckner',...
            'Buckner2011_7Networks_MNI152_FreeSurferConformed1mm_TightMask_MDTB.nii.gz');
        label = fullfile(data_dir,'buckner','Buckner2011_7Networks_label.txt');
        
    case 'fconn17'
        atlas = fullfile(data_dir,'buckner',...
            'Buckner2011_17Networks_MNI152_FreeSurferConformed1mm_TightMask_MDTB.nii.gz');
        label = fullfile(data_dir,'buckner','Buckner2011_17Networks_label.txt');
        
    case 'yeo'
        atlas = fullfile(data_dir,'yeoAtlas',...
            'Yeo2011_7Networks_MNI152_FreeSurferConformed1mm.nii.gz');
        label = fullfile(data_dir,'yeoAtlas','Yeo2011_7Networks_label.txt');
        
        
    case 'mdtb'
        atlas = fullfile(data_dir,'mdtb','mdtb_mni.nii');
        label = fullfile(data_dir,'mdtb','mdtb_label.txt');
        
    otherwise
        error('Wrong volume atlas');
end


% Load atlas label
fid = fopen(label);
label = textscan(fid,'%d %s');
roi_name = label{2};
fclose(fid);

%% read atlas
roi_nii = niftiRead(atlas);
roi_id = unique(roi_nii.data(roi_nii.data~=0))'; 
n_roi = length(roi_id);


%% read target volume file and extract meas for atlas roi
scalar_nii = niftiRead(scalar_vol);
nT = size(scalar_nii.data,4);
scalar_data = reshape(scalar_nii.data,[],nT);
if isnorm, scalar_data = zscore(scalar_data); end
roi_value = zeros(n_roi,nT);
for i = 1:n_roi
    roi = roi_nii.data == roi_id(i);
    roi_value(i,:) = mean(scalar_data(roi,:));
end
