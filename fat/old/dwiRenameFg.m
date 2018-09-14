function  dwiRenameFg(dwiDir, sessid, runName, fgName)
% dwiRenameFg(dwiDir, sessid, runName, fgName)

if nargin < 4, fgName = 'ETconnectome_candidate_classified_clean.mat'; end


for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('Rename Fg for %s:%s\n',sessid{s},runName{r});
        runDir = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin');
        fgFile = fullfile(runDir,'fibers','afq',fgName);
        if exist(fgFile,'file')
            load(fgFile);
            fg = fg_clean;
            
            save(fgFile,'fg');
        end
        
    end
end


% statFile = fullfile('~','analysis','data',...
%     sprintf('%s_stats.mat',fName));
% save(statFile,'nfiber');