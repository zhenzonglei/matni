function dwiMakefsROI(dwiDir,sessid,force)
% dwiMakefsROI(dwiDir,sessid,force)
% use fs_roisFromAllLabels(fsIn,outDir,type,refT1)
% to convert the freesurfer segmentation into ,mat ROIs
% for each subject
anatDir = '/sni-storage/kalanit/biac2/kgs/projects/Longitudinal/Anatomy/';
fsDir   = getenv('SUBJECTS_DIR');

for s = 1:length(sessid)
    % data info
    fsROIdir = fullfile(anatDir,sessid{s},'T1','fsROI');
    fsIn = fullfile(fsDir,sessid{s},'mri','aparc+aseg.mgz');
    refT1 = fullfile(anatDir,sessid{s},'T1','T1_QMR_1mm.nii.gz');
    if ~exist(fsROIdir,'dir') || force
        fprintf('Make fsROI for %s\n', sessid{s});
        % do conversion
        fs_roisFromAllLabels(fsIn,fsROIdir,'mat',refT1);
    end
end

