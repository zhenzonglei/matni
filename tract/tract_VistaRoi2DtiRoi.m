function dwiVistaRoi2DtiRoi(dwiDir, sessid, runName, roiName)
% dwiVistaRoi2DtiRoi(dwiDir, sessid, runName, roiName)
% runName, a cell array for run name
% roiName, a cell array for roi name 

for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('Make ROI for (%s, %s)\n',sessid{s},runName{r});
   
        runDir = fullfile(dwiDir,sessid{s},runName{r});
        
        % Path to the dt6 file
        dtFile = fullfile(runDir,'dti96trilin','dt6.mat');
        
        % Path to anatomy file
        vAnatFile = fullfile(runDir,'t1','T1_QMR_1mm.nii.gz');
     
        % Path to fROI file        
        for i = 1:length(roiName)
            roiList{i} = fullfile(runDir,'t1','ROIs',roiName{i});
        end
        
        % Do convert
        dtiXformMrVistaVolROIs(dtFile, roiList, vAnatFile)        
    end
end