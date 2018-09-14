function dwiMakeEquVolSphRoi(dwiDir, sessid, runName, roiName)
% dwiMakeEquVolSphRoi(dwiDir, sessid, runName, roiName)
% runName, cell array for run name
% roiName, cell array for roi name


for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('Make Sphere ROI with equal volume for %s:%s\n',...
            sessid{s},runName{r});
        
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
            
            % use ref image info to convert the acpa coords to img coords
            refImg = niftiRead(fullfile(runDir,'dti96trilin','bin','b0.nii.gz'),[]);
            imgCoords  = mrAnatXformCoords(refImg.qto_ijk, froi.coords);
            imgCoords = unique(ceil(imgCoords),'rows');  
            % calculate the volume and get radius for the sphere
            roiVol = size(imgCoords,1)*prod(refImg.pixdim);
            radius = round(nthroot((3*roiVol)/(4*pi),3))-0.5;
            
            [~,rName] = fileparts(roiName{i});
            sphRoiName = sprintf('%s_sphere.mat',rName);
            % make sphere roi
            roi = dtiNewRoi(sphRoiName);            
            roi.coords = dtiBuildSphereCoords(mean(froi.coords,1), radius);
            sphRoiFile= fullfile(runDir,'dti96trilin','ROIs',sphRoiName);
            dtiWriteRoi(roi,sphRoiFile);
            
        end
    end
end