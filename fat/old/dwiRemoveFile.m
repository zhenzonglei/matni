function dwiRemoveFile(dwiDir,sessid, runName,fileName)
% dwiRemoveFile(dwiDir,sessid, runName,fileName)
% fileName, cell array, it should be specificed according to the rundir(i.e.,96dir_runN)
% can only remove file,but not dir. for dir, it is dangous

for s = 1:length(sessid)
    for r = 1:length(runName)
        runDir = fullfile(dwiDir,sessid{s}, runName{r});
        for f = 1:length(fileName)
            fprintf('Delete (%s, %s, %s)\n',sessid{s},runName{r},fileName{f});            
            rmFile(fullfile(runDir,fileName{f}));
        end
    end
end



function rmFile(fileName)
% rmFile(fileName), remove file
% wildcard supported in fileName

if exist(fileName,'dir')
    rmdir(fileName,'s');
else
    files = dir(fileName);
    path = fileparts(fileName);
    
    for i = 1:length(files)
        ff = fullfile(path, files(i).name);
        if files(i).isdir
            rmdir(ff,'s');
        else
            delete(ff);
        end
    end
end