function utils_cmdengine(dwiDir,sessid, runName, cmdStr, bkgrnd, verbose)
%  utils_cmdengine(dwiDir,sessid, runName, cmdStr, bkgrnd, verbose)
% Run cmdStr for for subjects and runs
% the engine will generate commands for each session and each run by
% replace sessid string(SESS) and run string(RUN) in the cmdStr
if nargin < 6, verbose = true; end
if nargin < 5, bkgrnd = false; end

wd = pwd;
cd(dwiDir);
for s = 1:length(sessid)
    sessStr = strrep(cmdStr,'SESS',sessid{s});
    for r = 1:length(runName)
        runStr = strrep(sessStr,'RUN',runName{r});
        fprintf('(%s, %s): %s\n',sessid{s},runName{r},runStr);
        
        if bkgrnd
            runStr = ['xterm -e ' runStr ' &'];
        end
        
        tStart=tic;
        % Run the command and get back status and results:
        [status,results] = system(runStr);
        
        % If there was a failure, throw a warning:
        if (status ~=0)
            warning('[%s] There was a failure running the command. \nCommand: %s\nError %s\n',mfilename,results);
        end
        
        % If running the command within the matlab session and verbose, display
        % results, when it returns:
        if (~bkgrnd && verbose), disp(results); end
        totalTime = toc(tStart)/3600;
        fprintf('(%s, %s): %.2f\n',sessid{s},runName{r},totalTime);
    end
end
cd(wd);






