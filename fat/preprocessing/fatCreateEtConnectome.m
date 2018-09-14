function fatCreateEtConnectome(fatDir, sessid, runName)
% fatCreateConnectome(fatDir, sessid, runName)
% Create tractograhpy for a combination of lmax and curv

algo = {'prob'}; % Probabilistic tractography will use mrTrix
lmax = 8; % 8, CSD envelope parameter (8 allows for 4 crossing fibers)
nSeeds = 200000; % Number of streamlines to generate, default=200000
wmMaskName = 'wm_mask_resliced.nii.gz';
curvature = [0.25 0.5 1 2 4]; % curvature = [0.5 1 2] is a good range;

for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('Create Connectome for (%s, %s)\n',sessid{s},runName{r});
        dtFile = fullfile(fatDir,sessid{s},runName{r},'dti96trilin','dt6.mat');
        fibersFolder = fullfile(fatDir,sessid{s},runName{r},'dti96trilin','fibers');
        wmMask = fullfile(fatDir,sessid{s},runName{r},'t1',wmMaskName);
        for i = 1:length(lmax)
            for j = 1:length(curvature)
                % will do fiber tracking using mrtrix % this function is
                % part of an older LIFE version
                fatFeTrack(algo,dtFile,fibersFolder,lmax(i),nSeeds,wmMask,curvature(j),0.1); 
            end
        end
    end
end


