function fatVistaRoi2DtiRoi(fatDir, sessid, runName, roiName, t1_name)
% fatVistaRoi2DtiRoi(fatDir, sessid, runName, roiName)
% runName, a cell array for run name
% roiName, a cell array for roi name 

        fprintf('Make ROI for (%s, %s)\n',sessid,runName);
   
        runDir = fullfile(fatDir,sessid,runName);
        
        % Path to the dt6 file
        dtFile = fullfile(runDir,'dti96trilin','dt6.mat');
        
        % Path to anatomy file
        vAnatFile = fullfile(runDir,'t1',t1_name);
     
        % Path to fROI file        
        roiList = fullfile(runDir,'t1','ROIs',roiName);

        % Do convert
        dtiXformMrVistaVolROIs(dtFile, roiList, vAnatFile)        
    end
