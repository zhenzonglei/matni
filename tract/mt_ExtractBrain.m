function dwiExtractBrain(dwiDir,sessid,meth)
% dwiExtractBrain(dwiDir, sessid,meth)

runName = '96dir_run1';
% anatDir = '/sni-storage/kalanit/biac2/kgs/projects/Longitudinal/Anatomy/';

cwd = pwd;
targ = 'T1_QMR_1mm.nii.gz';
mask = 'T1_classQMR_1mm.nii.gz';
brain = 'T1_QMR_1mm_brain.nii.gz';

for s = 1:length(sessid)
    fprintf('Extract brain:%s\n', sessid{s})
    t1Dir = fullfile(dwiDir, sessid{s}, runName,'t1');
    cd(t1Dir)
    if strcmp(meth,'mask')
        if exist(targ, 'file') && exist(mask, 'file')
            cmd = sprintf('fslmaths %s -mas %s %s',targ,mask,brain);
            system(cmd);
        end
    elseif strcmp(meth,'bet')
        if exist(targ, 'file')
            cmd = sprintf('bet %s %s -B',targ,brain);
            system(cmd);
        end
    end
end
cd(cwd);
