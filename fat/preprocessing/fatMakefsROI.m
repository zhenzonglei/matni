function fatMakefsROI(anatDir,anatid,sessid,force)
% fatMakefsROI(fatDir,sessid,force)
% use fs_roisFromAllLabels(fsIn,outDir,type,refT1)
% to convert the freesurfer segmentation into ,mat ROIs
% for each subject

fsDir   = getenv('SUBJECTS_DIR');

    % data info
    fsROIdir = fullfile(anatDir,anatid,'fsROI');
    fsIn = fullfile(fsDir,anatid,'mri','aparc+aseg.mgz');
    refT1 = fullfile(anatDir,anatid,'t1.nii.gz');
    if ~exist(fsROIdir,'dir') || force
        fprintf('Make fsROI for %s\n', sessid);
        % do conversion
        fs_roisFromAllLabels(fsIn,fsROIdir,'mat',refT1);
    end
end


