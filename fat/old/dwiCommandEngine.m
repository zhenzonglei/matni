function dwiCommandEngine(dwiDir,sessid, runName, cmdStr)
% run cmdStr for for subjects and runs
% the engine will generate commands for each session and each run by
% replace sessid string(SESS) and run string(RUN) in the cmdStr

wd = pwd;
cd(dwiDir);
for s = 1:length(sessid)
    sessStr = strrep(cmdStr,'SESS',sessid{s});
    for r = 1:length(runName)
        runStr = strrep(sessStr,'RUN',runName{r});
        fprintf('(%s, %s): %s\n',sessid{s},runName{r},runStr);
        system(runStr);
    end
end
cd(wd);

