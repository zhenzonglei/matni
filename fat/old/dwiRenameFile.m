function  dwiRenameFile(dwiDir, sessid, runName, origName,targName)
% dwiRenameFile(dwiDir, sessid, runName, origName,targName)

for s = 1:length(sessid)
    for r = 1:length(runName)
        runDir = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin');
        origFile = fullfile(runDir,'fibers','afq', origName);
        targFile  = fullfile(runDir,'fibers','afq', targName);
        
        if exist(origFile, 'file')
            movefile(origFile, targFile);
        end
    end
end