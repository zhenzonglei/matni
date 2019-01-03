function  dwiSegFiberWithROI(dwiDir, sessid, runName, roiName, fgName)
% dwiSegFiberWithROI(dwiDir, sessid, runName, fgName, roiName,kernel)

if nargin < 5, fgName = 'ETconnectome_candidate_classified_clean.mat'; end


[~,fName] = fileparts(fgName);
for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('Seg Fibers for %s:%s\n',sessid{s},runName{r});
        
        runDir = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin');
        load(fullfile(runDir,'fibers','afq',fgName));
        
        for i = 1:length(roiName)
            roiFile = fullfile(runDir,'ROIs',roiName{i});
            if exist(roiFile, 'file')
                roi = dtiReadRoi(roiFile);
            else
                continue
            end
            
                       

            for j = 1:length(fg)
                % intersect fg with roi
                fg_roi(j) = dtiIntersectFibersWithRoi([],'and',[],roi,fg(j));
            end
            
            [~,rName] = fileparts(roiName{i});
            fiberFile = fullfile(runDir,'fibers','afq',...
                sprintf('%s_%s.mat',rName,fName));
            fgWrite(fg_roi,fiberFile,'mat');
        end
    end
end