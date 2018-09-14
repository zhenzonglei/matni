function fatDilateRoi(fatDir, sessid, runName, roiName, radius)
% fatDilateRoi(fatDir, sessid, runName, roiName, radius, meth)
% runName, cell array for run name
% roiName, a str

if nargin < 5, radius = 6; end

        fprintf('Dilate ROI for (%s,%s)\n',sessid,runName);
        
        % Path to run directory
        runDir = fullfile(fatDir,sessid,runName,'dti96trilin');
        
        % load froi
        roiFile = fullfile(runDir,'ROIs',roiName);
        if exist(roiFile, 'file')
            roi = dtiReadRoi(roiFile);
        else
            return
        end
        
        % dilate the ROI
        roi = dtiRoiClean(roi,radius,{'fillholes', 'dilate', 'removesat'});
        roi.name = sprintf('%s_dilate_%d',roi.name, radius);
        
        
        %% Save out the ROI
        [~,rName] = fileparts(roiName);
        dilateRoiName = sprintf('%s_dilate_%d.mat',rName,radius);
        
        dilateRoiFile= fullfile(runDir,'ROIs',dilateRoiName);
        dtiWriteRoi(roi,dilateRoiFile);

