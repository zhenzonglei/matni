function dwiVol2Surf(dwiDir, sessid, runName, volName, hemi, projfrac, nsmooth, interp)
% dwiVol2Surf(dwiDir, sessid, runName, volName, hemi, projfrac, nsmooth, interp)
% Project epd volume to surface, and binarize it
% interp: <nearest> or trilinear
% volName should be assigned according to the runDir, cell array
if nargin < 8, interp = 'nearest'; end
if nargin < 7, nsmooth = 10; end
if nargin < 6, projfrac = 0; end

cwd = pwd;
for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('Project Volume to Surface for (%s, %s)\n',sessid{s}, runName{r});
        runDir = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin');
        
        for i = 1:length(volName)
            [fPath,volNameWoExt] = fileparts(volName{i});
            [~,volNameWoExt] = fileparts(volNameWoExt);
            volDir = fullfile(runDir,fPath);
            cd(volDir);
         
            if exist([volNameWoExt,'.nii.gz'], 'file')
                % project volume to surface for individuals
                vol2surf = sprintf('mri_vol2surf --mov %s.nii.gz --hemi %s --regheader %s --projfrac-max %.2f %.2f 0.25 --interp %s --o %s_surf.mgz',...
                    volNameWoExt, hemi, sessid{s},-projfrac, projfrac, interp, volNameWoExt);
                system(vol2surf);
                
                % project individual surface to fsaverage
                surf2surf = sprintf('mri_surf2surf --srcsubject %s --sval %s_surf.mgz --trgsubject fsaverage --tval %s_surf_fsaverage.mgz  --hemi %s --nsmooth-out %d ',...
                    sessid{s},volNameWoExt, volNameWoExt,hemi,nsmooth);
                system(surf2surf);
                
            end
        end
    end
end
cd(cwd);

