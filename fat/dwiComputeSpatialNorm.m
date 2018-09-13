function dwiComputeSpatialNorm(dwiDir, sessid, runName)
% dwiComputeSpatialNorm(dwiDir, sessid, runName)
% Compute spatial normalization(sn) for each run
for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('Compute spatial normalization for (%s, %s)\n',sessid{s}, runName{r});
        runDir = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin');
        dtFile = fullfile(runDir, 'dt6.mat');
        
        % compute spatial transform using b0 image
        dtiComputeSpatialNorm(dtFile);
    end
end

