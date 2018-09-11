function  dwiFindFile(dwiDir, sessid, runName, fileName)
% dwiFindFile(dwiDir, sessid, runName, fileName)


for r = 1:length(runName)
    flag = zeros(length(sessid),1);
    
    for s = 1:length(sessid)
        runDir = fullfile(dwiDir,sessid{s},runName{r});
        targFile = fullfile(runDir,fileName);
        if exist(targFile, 'file')
            flag(s) = 1;
        end
    end

    fprintf('%d subjs has %s for run %s\n',sum(flag),fileName,runName{r});
    
end