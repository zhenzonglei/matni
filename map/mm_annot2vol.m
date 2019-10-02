function mm_annot2vol(atlasDir)

if nargin < 1
    atlasDir = '/sni-storage/kalanit/users/zhenzl/AllenHumanBrainGeneExpression/data/vcAtlas';
end

cwd = pwd;
cd(atlasDir);

label = extractfield(dir('*.annot'),'name');
fsDir = getenv('FREESURFER_HOME');
regMat = fullfile(fsDir,'average/mni152.register.dat');
fslDir = getenv('FSLDIR');
refVol = fullfile(fslDir, '/data/standard/MNI152_T1_2mm.nii.gz');

for i = 1%:length(label)
    cmd = sprintf('mri_label2vol --annot %s --hemi %s --subject fsaverage --temp %s --reg %s  --o %s',...
        label{i}, label{i}(1:2), refVol, regMat, [label{i},'.nii.gz']);
    system(cmd);
end

