function val = dwiRoiProperties(dwiDir, sessid, runName, roiName,faThr)
% val = dwiRoiProperties(dwiDir, sessid, runName, roiName)
% runName, cell array for run name
% roiName, cell array for roi name
% val, diffusion properties array, 4(fa, md,rd, ad) x nRun X nSubj 
if nargin < 5, faThr = 0.2; end

nSubj = length(sessid);
nRun = length(runName);
val = NaN(4,nRun, nSubj);
for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('Extract ROI Properties(%s,%s)\n',sessid{s},runName{r});
        
        % Path to run directory
        runDir = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin');
        dt6File = fullfile(runDir,'dt6.mat');
        roiFile = fullfile(runDir,'ROIs',roiName);
        
        if exist(roiFile, 'file')
            roi = dtiReadRoi(roiFile);
            dt=dtiLoadDt6(dt6File);
            [fa,md,rd,ad] = dtiGetValFromTensors(dt.dt6, roi.coords, inv(dt.xformToAcpc),'fa md ad rd','nearest');
            
            idx = fa > faThr;
            val(:,r,s) = nanmean([fa(idx),md(idx),rd(idx),ad(idx)]);
        end
    end
end
