function dwiCreateConnectome(dwiDir, sessid, runName)
% dwiCreateConnectome(dwiDir, sessid, runName)
% Create tractograhpy for a combination of lmax and curv

algo = {'prob'}; % Probabilistic tractography will use mrTrix
lmax = 2:2:12; % 8, CSD envelope parameter (8 allows for 4 crossing fibers)
nSeeds = 200000; % Number of streamlines to generate, default=200000
wmMaskName = 'wm_mask_resliced.nii.gz';
curvature = 1; % curvature = [0.5 1 2] is a good range;

for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('Create Connectome for (%s, %s)\n',sessid{s},runName{r});
        dtFile = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin','dt6.mat');
        fibersFolder = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin','fibers');
        wmMask = fullfile(dwiDir,sessid{s},runName{r},'t1',wmMaskName);
        for i = 1:length(lmax)
            for j = 1:length(curvature)
                feTrack(algo,dtFile,fibersFolder,lmax(i),nSeeds,wmMask,curvature(j));
            end
        end
    end
end


