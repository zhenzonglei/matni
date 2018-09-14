function [vol,coords,hemiOvlp,roiOvlp] = dwiRoiStat(dwiDir, sessid, runName, roiName)
% [vol,coords, ovlp] = dwiRoiStat(dwiDir, sessid, runName, roiName)
% runName, cell array for run name
% roiName, cell array for roi name
hemisphere = {'lh','rh'};
nHemi = length(hemisphere);
nRun = length(runName);
nRoi = length(roiName);
nSubj = length(sessid);

vol = NaN(nRoi,nHemi,nRun,nSubj);
coords = NaN(3,nRoi,nHemi,nRun,nSubj);
hemiOvlp = NaN(nRoi,nRun,nSubj);
roiOvlp = NaN(nRoi,nRoi,nHemi,nRun,nSubj);
for s = 1:nSubj
    for r = 1:nRun
        fprintf('Stat ROI for %s:%s\n',sessid{s},runName{r});
        % Path to run directory
        runDir = fullfile(dwiDir,sessid{s},runName{r});
        % use ref image info to convert the acpa coords to img coords
        refImg = niftiRead(fullfile(runDir,'dti96trilin','bin','b0.nii.gz'),[]);
        R = cell(nRoi,nHemi);
        for i = 1:nRoi
            for j = 1:nHemi
                roiFile = fullfile(runDir,'dti96trilin','ROIs',sprintf('%s_%s.mat',hemisphere{j},roiName{i}));
                % load froi
                if exist(roiFile, 'file')
                    froi = dtiReadRoi(roiFile);
                else
                    continue
                end
                
                % Get center coords
                coords(:,i,j,r,s) = mean(froi.coords);
                
                if j == 1
                    froi.coords(:,1) = -froi.coords(:,1);
                end
                imgCoords  = mrAnatXformCoords(refImg.qto_ijk, froi.coords);
                imgCoords = unique(ceil(imgCoords),'rows');
                
                % calculate the volume
                vol(i,j,r,s) = size(imgCoords,1);% *prod(refImg.pixdim);
                R{i,j} = imgCoords;
            end
        end
   
        
            hemiOvlp(:,r,s) = roiHemiOverlap(R);
            roiOvlp(:,:,:,r,s) = roiOverlap(R);
        end
    end
end


function ov = roiHemiOverlap(R)
% R is a nRoixnHemi array
[nRoi,~] = size(R);
ov = NaN(nRoi,1);
for i = 1:size(R,1);
    if ~any(cellfun('isempty',R(i,:)))
        C = intersect(R{i,1},R{i,2},'rows');
        ov(i) = size(C,1)/(size(R{i,1},1) + size(R{i,2},1));
    end
end
ov = 2*ov;
end


function  ov = roiOverlap(R)
% R is a nRoixnHemi array
[nRoi,nHemi] = size(R);
ov = nan(nRoi,nRoi,nHemi);

for h = 1:nHemi
    for i = 1:nRoi
        A = R{i,h};
        if ~isempty(A)
            for j = (i+1):nRoi
                B = R{j,h};
                if ~isempty(B)
                    C  = intersect(A, B,'rows');
                    ov(i,j,h) = size(C,1)/(size(A,1) + size(B,1));
                end
            end
        end
    end
end
ov = ov*2;
end



