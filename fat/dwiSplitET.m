function dwiSplitET(dwiDir, sessid, runName, fgName, fold)
% dwiSplitET(dwiDir, sessid, runName, fgName, fold)

if nargin < 5, fold = 5; end

[~,fname] = fileparts(fgName);

for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('Randomly split ET for %s:%s\n',sessid{s},runName{r});
        runDir = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin');
        
        % ET connectome
        etFile = fullfile(runDir,'fibers',fgName);
        et = fgRead(etFile);
        nfiber = fgGet(et,'nfibers');
        idx = randperm(nfiber);
        NF = nfiber/fold;
        sg = 1:NF;
        for i = 1:fold
            % Create fg structure
            fg = fgCreate;
            
            % Set name and fibers for subgroup et
            fg.name = sprintf('%s_sg%d',fname,i);
            fg.fibers = et.fibers(idx(sg+(i-1)*NF));
            
            fgFile = fullfile(runDir,'fibers',sprintf('%s_sg%d.mat',fname,i));
            fgWrite(fg, fgFile,'mat');
        end
    end
end

