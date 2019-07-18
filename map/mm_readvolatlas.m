function [meas,roi_id,roi_name] = map_read_volatlas(meas_vol_file, atlas_name)


data_dir = '/nfs/e5/stanford/ABA/brainmap';
switch atlas_name
    case 'wang'
        atlas = fullfile(data_dir,'wang_retinotopy','vol','MNI152_MPM_1mm.nii.gz');
        label = fullfile(data_dir,'wang_retinotopy','vol','wang_atlas_label.txt');
        
    case 'cyto'
        atlas = fullfile(data_dir,'cytoAtlas','MNI152_cytoMPM_thr25_2mm.nii.gz');
        label = fullfile(data_dir,'cytoAtlas','cytoLabelShort.txt');
        % label = fullfile(data_dir,'cytoAtlas','cytoLabel.txt');
        
    case 'fconn'
        atlas = fullfile(data_dir,'buckner',...
            'Buckner2011_7Networks_MNI152_FreeSurferConformed1mm_TightMask.nii.gz');
        label = fullfile(data_dir,'buckner','Buckner2011_7Networks_label.txt');
         
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


%% read atlas
atlas_nii = niftiRead(atlas);
roi_id = unique(atlas_nii.data(atlas_nii.data~=0))'; 



%% read target volume file and extract meas for atlas roi
targ_nii = niftiRead(vol_file);
targ_data = reshape()
for i = 1:length(roi_id)
    roi = atlas_nii.data == roi_id(i);
    d = targ_nii.data(roi,:);
end

    
    


