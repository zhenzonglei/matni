function  nfiber = dwiFiberStat(dwiDir, sessid, runName, fgName)
% dwiFiberStat(dwiDir, sessid, runName, roiName, fgName)

if nargin < 4, fgName = 'ETconnectome_candidate_classified_clean.mat'; end


% [~,fName] = fileparts(fgName);

nfiber = zeros(26,length(runName),length(sessid));
for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('Fibers stats for %s:%s\n',sessid{s},runName{r});
        runDir = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin');
        fgFile = fullfile(runDir,'fibers','afq',fgName);
        if exist(fgFile,'file')
            fg = load(fgFile);
            fg = fg.fg;
            
            for f = 1:length(fg)
                nfiber(f,r,s) = fgGet(fg(f),'nfibers');
            end
        end
    end
end


% statFile = fullfile('~','analysis','data',...
%     sprintf('%s_stats.mat',fName));
% save(statFile,'nfiber');