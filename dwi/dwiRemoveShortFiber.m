function dwiRemoveShortFiber(dwiDir, sessid, runName, fgName, minLen)
%  dwiRemoveShortFiber(dwiDir, sessid, runName, fgName, minLen)

if nargin < 5, minLen = 35; end
if nargin < 4, fgName = 'ETconnectome_candidate.mat'; end

[~,fname] = fileparts(fgName);
for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('Remove fibers for %s:%s\n',...
            sessid{s},runName{r});
        
        fiberDir = fullfile(dwiDir,sessid{s},runName{r},...
            'dti96trilin','fibers');
        
        fg = fgRead(fullfile(fiberDir,fgName));
        fiberLen = fgGet(fg, 'nodesperfiber');
        
        fg.fibers(fiberLen < minLen) = [];
        fg.name = fullfile(fiberDir,sprintf('%s_minLen%d.mat', fname, minLen));
        fgWrite(fg, fg.name, 'mat');
    end
end








