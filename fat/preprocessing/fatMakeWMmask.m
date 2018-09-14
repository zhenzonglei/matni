function fatMakeWMmask(fatDir, anatDir, anatid, sessid, t1_name, ventMeth, force)
% fatMakeWMmask(fatDir, anatid, ventMeth, force)
% ventMeth: method to generate ventricle mask
% This function will do:
% 1. generate ventrical mask from aseg
% 2. convert freesurfer ribbon.mgz to the T1_QMR_1mm.nii.gz' using  fs_ribbon2itk
% 3. generate wm mask which do not include ventrical, for use in tractography.

if nargin < 5, force = false; end
if nargin < 4, ventMeth = 'wm'; end

subdir   = getenv('SUBJECTS_DIR');

if isempty(subdir),
    fshome = getenv('FREESURFER_HOME');
    subdir = fullfile(fshome, 'subjects');
end

cwd = pwd;
% name for target file
ventFS  =  'T1_fs_vent.nii.gz'; % ventricle mask from freesurfer
ventQMR = 'T1_ventQMR_1mm.nii.gz'; % resample ventrice to QMR
classQMR = 't1_class.nii.gz'; % QMR from freesurfer ribbion volume
alignTo = t1_name;
resample_type ='nearest';

% generate T1_fs_vent from FS
for s = 1:length(anatid)
    t1Dir = fullfile(anatDir, anatid{s});
    cd(t1Dir);
    
    if ~exist(ventQMR,'file')||force
        
        % generate T1_ventQRM_1mm through aseg.mgz
        if strcmp(ventMeth, 'aseg')
            asegFile = fullfile(subdir, anatid{s}, 'mri', 'aseg.mgz');
            ventID = '4 5 14 15 43 44 72';
            bincmd = sprintf('mri_binarize --i %s --o %s --match %s',...
                asegFile, ventFS, ventID);
            
            % generate T1_ventQRM_1mm through wm.mgz
        elseif strcmp(ventMeth, 'wm')
            wmFile = fullfile(subdir, anatid{s}, 'mri', 'wm.mgz');
            bincmd = sprintf('mri_binarize --i %s --min 240 --o %s',...
                wmFile, ventFS);
            
        end
        
        system(bincmd);
        
    end
end

% convert T1_fs_vent to T1_ventQMR_1mm
rescmd = sprintf('mri_convert  --reslice_like %s -rt %s %s %s', ...
    alignTo, resample_type, ventFS, ventQMR);
for s = 1:length(anatid)
    t1Dir = fullfile(anatDir, anatid{s});
    cd(t1Dir)
    
    if ~exist(ventQMR,'file')||force
        system(rescmd);
        % delete(ventFS);
    end
end

% generate 'T1_classQMR_1mm.nii.gz' from ribbon.nii.gz of FS
%  fillWithCSF = false;
%  for s = 1:length(anatid)
%     t1Dir = fullfile(anatDir, anatid{s});
%     cd(t1Dir)
%     
%     if ~exist(classQMR,'file') ||force
%         fs_ribbon2itk(anatid{s}, classQMR, fillWithCSF, alignTo, resample_type);
%     end
%  end


% generate wm_mask_resliced
for s = 1:length(anatid)
    t1Dir = fullfile(anatDir, anatid{s});
    cd(t1Dir)
    
    if ~exist('wm_mask_resliced.nii.gz','file') || force
        % read QMR class volume
        ni = readFileNifti(classQMR);
        
        % The values 3 and 4 correspond to right and left white matter voxels.
        % Turn all other values to zero and then turn the WM voxels to 1.
        wm = (ni.data==3 | ni.data==4);
        ni.data(wm) = 1;
        ni.data(~wm) = 0;
        
        % read ventricle volume and turn ventrical voxel to 0
        vent = readFileNifti(ventQMR);
        ni.data(vent.data == 1) = 0;
        clear vent;
        
        % write image
        ni.fname = 'wm_mask.nii.gz';
        writeFileNifti(ni);
        clear ni;
        
        % Downsample and resize
        % We have to make sure the wm mask is 2mm isotropic like the diffusion data
        % and that it is of the same nifti size. We will use the wmProb mab in the
        % bin folder to align to. This requires the fat data to have been
        % preprocessed.
        refVol = fullfile(fatDir, sessid{s}, ...
            '96dir_run1/dti96trilin/bin/wmProb.nii.gz');
        if ~exist(refVol, 'file')
            fprintf('%s: 96dir_run1 wmProb.nii.gz not exist\n', anatid{s})
            continue
        end
        
        system(['mri_convert ' 'wm_mask.nii.gz ' '-rl ' refVol ...
            ' -rt ' 'nearest wm_mask_resliced.nii.gz']);
    end
end
cd(cwd);
