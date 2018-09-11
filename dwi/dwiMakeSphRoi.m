function dwiMakeSphRoi(dwiDir, sessid, runName, roiName, radius)
% dwiMakeSphRoi(dwiDir, sessid, runName, roiName)
% runName, cell array for run name
% roiName, cell array for roi name


if nargin < 5, radius = 3; end

for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('Make Sphere ROI for %s:%s\n',sessid{s},runName{r});
        
        % Path to run directory
        runDir = fullfile(dwiDir,sessid{s},runName{r});
        
        for i = 1:length(roiName)
            % load froi
            roiFile = fullfile(runDir,'dti96trilin','ROIs',roiName{i});
            if exist(roiFile, 'file')
                froi = dtiReadRoi(roiFile);
            else
                continue
            end
            
            roiVol = size(froi.coords,2)*8;
            radius = round(nthroot((3*roiVol)/(4*pi),3));
            
                        
            [~,rName] = fileparts(roiName{i});
            sphRoiName = sprintf('%s_sphere_%d.mat',rName,radius);
            
            % make sphere roi
            roi = dtiNewRoi(sphRoiName);
            roi.coords = dtiBuildSphereCoords(mean(froi.coords), radius);
            
            sphRoiFile= fullfile(runDir,'dti96trilin','ROIs',sphRoiName);
            dtiWriteRoi(roi,sphRoiFile);
            
        end
    end
end