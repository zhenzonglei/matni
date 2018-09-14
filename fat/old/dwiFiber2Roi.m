 function  [fiberProp, roiProp] = dwiFiber2Roi(dwiDir, sessid, runName, fgName, roiName, foi, radius)
 % dwiFiber2Roi(dwiDir, sessid, runName, fgName, roiName)

if nargin < 7, radius = 6; end
if nargin < 6, foi = [13:14,19:26]; end


% the prop of fibers touching the ROI
fiberProp = nan(length(foi),length(runName), length(sessid));
% the prop of ROI's voxel touching the fibers
roiProp = nan(length(foi),length(runName), length(sessid));

for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('Fiber count for %s-%s-%s\n',...
            sessid{s}, runName{r}, fgName);
        
        runDir = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin');
        
        fgFile = fullfile(runDir,'fibers','afq',fgName);
        % load fg
        load(fgFile);
        
        roiFile = fullfile(runDir,'ROIs',roiName);
        if exist(roiFile, 'file')
        roi = dtiReadRoi(roiFile);
        rc = roi.coords;
        else
            continue
        end 
        
        % number of voxel in roi
        nvox = length(rc);
        for i = 1:length(foi)
            f = foi(i);
            nfiber = fgGet(fg(f),'nfibers');
            fc = zeros(nfiber*2,3);
            for j =1:nfiber
                fc((j-1)*2+1,:) = fg(f).fibers{j}(:,1);
                fc((j-1)*2+2,:) = fg(f).fibers{j}(:,end);
            end
            
            D = pdist2(fc,rc) <= radius; 
            D = reshape(D,2,nfiber,nvox);
            D = squeeze(xor(D(1,:,:),D(2,:,:)));
            
           roiProp(i,r,s) = sum(any(D,1))/nvox;
           fiberProp(i,r,s)= sum(any(D,2))/nfiber;
        end
    end
end
