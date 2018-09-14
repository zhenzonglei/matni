function D = dwiFiberOverlap(dwiDir, sessid,runName, fgName, roiName, foi,radius)
%  D = dwiFiberOverlap(dwiDir, sessid,runName, fgName, roiName, foi,radius)
%  
nRoi = length(roiName);
nFg = length(foi);
hemisphere = {'lh','rh'};
nHemi = length(hemisphere);
nRun = length(runName);
nSubj = length(sessid);
D = nan(nRoi,nRoi,nFg,nHemi,nRun,nSubj);
for s = 1:nSubj
    for r = 1:nRun
        fprintf('Calculate fiber overlap for (%s, %s, %s)\n',...
            sessid{s}, runName{r}, fgName);
        runDir = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin');
        afqDir = fullfile(runDir,'fibers','afq');
        
        for h = 1:nHemi
            idx = false(nRoi,1);
            roifg = cell(nFg,nRoi);
            
            for i = 1:nRoi
                roifgFile = fullfile(afqDir,sprintf('%s_%s_fROI_r%.2f_%s',hemisphere{h},roiName{i},radius,fgName));
                if exist(roifgFile, 'file')
                    idx(i) = true;
                    load(roifgFile,'fidx');
                    roifg(:,i)= fidx(foi);
                end
            end
            
            for f = 1:nFg
                % extract fiber index from a fg
                M = cat(2,roifg{f,:});
                D(idx,idx,f,h,r,s) = dice(M);
            end
        end
    end
end

