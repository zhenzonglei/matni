function fiberLenDist = dwiFiberLenDist(dwiDir, sessid, runName, fgName, nFg)
% fiberLenDist: 10 x nRUN x nSubj
if nargin < 5, nFg = 4; end

% edges = [0,20,35,50,65,80,95,110,130,150,175,200];

edges = 0:5:200;
fiberLenDist = nan(length(edges)-1, nFg, length(runName), length(sessid));
for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('Fiber length dist for %s:%s\n',...
            sessid{s},runName{r});
        
        fiberDir = fullfile(dwiDir,sessid{s},runName{r},...
            'dti96trilin','fibers','afq');
        
        % fg = fgRead(fullfile(fiberDir,fgName));
        fgFile = fullfile(fiberDir,fgName);
        if exist(fgFile,'file')
            fg = load(fgFile);
            fg = fg.roifg;
            
            for f = 1:length(fg)
                fiberLen = fgGet(fg(f), 'nodesperfiber');
                fiberLenDist(:,f,r,s) = histcounts(fiberLen,edges);
                %,...'Normalization','probability');
            end
        end
    end
end








