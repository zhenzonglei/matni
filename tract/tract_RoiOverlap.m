function  ovp = dwiRoiOverlap(dwiDir, sessid, runName,roiName)
% ovp = dwiRoiOverlap(dwiDir, sessid, runName, roiName)
% runName is a cell array.
% roiName is a cell array.

% overlap array
ovp = nan(length(roiName), length(roiName), length(runName), length(sessid));
for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('Calc ROI overlap for (%s, %s)\n',sessid{s}, runName{r});
        runDir = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin');
        % use ref image info to convert the acpa coords to img coords
        refImg = niftiRead(fullfile(runDir,'bin','b0.nii.gz'),[]);
        
        for i = 1:length(roiName)
            roiFile = fullfile(runDir,'ROIs',roiName{i});
            if exist(roiFile, 'file')
                roi = dtiReadRoi(roiFile);
                coords = roi.coords;
                % convert vertex acpc coords to img coords
                imgCoords  = mrAnatXformCoords(refImg.qto_ijk, coords);
                % get coords for the unique voxels
                roiCoords{i} = unique(ceil(imgCoords),'rows');
            else
                roiCoords{i} = [];
            end
            
        end
        ovp(:,:,r,s) = cellOverlap(roiCoords);
        clear roiCoords
    end
end


function  ovpMat = cellOverlap(cellArray)
nCell = length(cellArray);
ovpMat = nan(nCell);
for i = 1:nCell
    A = cellArray{i};
    if ~isempty(A)
        for j = (i+1):nCell
            B = cellArray{j};
            if ~isempty(B)
                C  = intersect(A, B,'rows');
                ovpMat(i,j) = size(C,1)/(size(A,1) + size(B,1));         
            end
        end
    end
end
ovpMat = ovpMat*2;
