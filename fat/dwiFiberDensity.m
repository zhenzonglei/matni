function dwiFiberDensity(dwiDir, sessid, runName, fgName, foi, norm, endpt)
% dwiFiberDensity(dwiDir, sessid, runName, fgName, foi, norm, endpt)
% foi: fiber of interest, it's a vector with length as 2(hemi) x N(group)
% Odd and Even element in the vector correspond to different hemispheres.
if nargin < 7, endpt = 1; end
if nargin < 6, norm = 1; end

for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('Caclulate density map for %s-%s\n',sessid{s}, runName{r});
        subDir = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin');
        afqDir = fullfile(subDir,'fibers','afq');
        volDir = fullfile(afqDir,'epd');
        if ~exist(volDir,'dir')
            mkdir(volDir)
        end
        
        % read dt6
        dtFile =  fullfile(subDir,'dt6.mat');
        dt = dtiLoadDt6(dtFile);
        
        % read fg and calc endpoint density for each fibers
        fg = dtiReadFibers(fullfile(afqDir,fgName));
        fg = fg(foi);
        nFg = length(fg);
      
        fd = dtiComputeFiberDensityNoGUI(fg, dt.xformToAcpc, size(dt.b0), norm, 1:nFg, endpt);
        
        fdName = fg(1).name;
        for i = 2:nFg
            fdName = [fdName,'_',fg(i).name];
        end
        fdFile = fullfile(volDir,[fdName, '_fd_new.nii.gz']);
        dtiWriteNiftiWrapper(fd,dt.xformToAcpc,fdFile);
    end
end

