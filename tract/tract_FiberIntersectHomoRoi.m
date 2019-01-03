function  [fiberCount, voxCount, totalFiber,totalVoxel] = dwiFiberIntersectHomoRoi(dwiDir, sessid, ...
    runName, fgName, roiName, radius,foi)
% dwiFiberIntersectRoi_savefile(dwiDir, sessid, runName, fgName, roiName, foi, radius)
% roiName, must be a Nx2 arrray, each corresponds a hemisphere
% foi, vector, a Nx1 vector
% radius, scalar
% fgName should be specified according to the afq dir
if nargin < 7, foi = 1; end
if nargin < 6, radius = 5; end
minLength = 20;

nFg = length(foi);
nRoi = size(roiName,1);
nRun = length(runName);
nSubj = length(sessid);
nHemi = 2;
% total number of fiber
totalFiber = nan(nRoi,nFg,nHemi,nRun,nSubj);
% total number of voxel in roi
totalVoxel = nan(nRoi,nHemi,nRun, nSubj);
% the number of fibers touching the ROI
fiberCount = nan(nRoi,nFg,nRun,nSubj);
% the number of ROI's voxel touching the fibers
voxCount = nan(nRoi,nFg,nHemi,nRun,nSubj);
[~,fgNameWoExt] = fileparts(fgName);
for s = 1:nSubj
    for r = 1:nRun
        fprintf('Fiber count for (%s, %s, %s)\n',...
            sessid{s}, runName{r}, fgName);
        runDir = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin');
        fgFile = fullfile(runDir,'fibers','afq',fgName);
        load(fgFile);
        fg = fg(foi);
        
        %% remove fiber less than 2cm, and get the terminate for fg        
        FT = {};
        for i = 1:nFg
            L = fgGet(fg(i),'nodesperfiber');
            fg(i).fibers = fg(i).fibers(L > minLength);
            
            nfiber = fgGet(fg(i),'nfibers');
            ft = zeros(nfiber*2,3);
            % Get fiber terminate
            for k =1:nfiber
                ft((k-1)*2+1,:) = fg(i).fibers{k}(:,1);
                ft((k-1)*2+2,:) = fg(i).fibers{k}(:,end);
            end
            FT{i} = ft;
        end
        
        % use ref image info to convert the acpa coords to img coords
        refImg = niftiRead(fullfile(runDir,'bin','b0.nii.gz'),[]);
        dist = radius + nthroot(prod(refImg.pixdim),3);
        
        for i = 1:nRoi
            roiFile1 = fullfile(runDir,'ROIs',roiName{i,1});
            roiFile2 = fullfile(runDir,'ROIs',roiName{i,2});
            
            if exist(roiFile1, 'file') && exist(roiFile2, 'file')
                % Read ROI1
                roi1 = dtiReadRoi(roiFile1);
                % convert vertex acpc coords to img coords
                imgCoords  = mrAnatXformCoords(refImg.qto_ijk, roi1.coords);
                % transfer back to acpc coords
                rc1 = mrAnatXformCoords(refImg.qto_xyz, unique(round(imgCoords),'rows'));
                totalVoxel(i,1,r,s)= size(rc1,1);
                
                % Read ROI2
                roi2 = dtiReadRoi(roiFile2);
                % convert vertex acpc coords to img coords
                imgCoords  = mrAnatXformCoords(refImg.qto_ijk, roi2.coords);
                % transfer back to acpc coords
                rc2 = mrAnatXformCoords(refImg.qto_xyz, unique(round(imgCoords),'rows'));
                totalVoxel(i,2,r,s)= size(rc2,1);
                
                for j = 1:nFg
                    ft = FT{j};
                    
                    % fiber connecting with roi1
                    D1 = reshape(pdist2(ft,rc1),2,nfiber,size(rc1,1));
                    kD1 = D1 < dist;
                    kD1 = squeeze(xor(kD1(1,:,:),kD1(2,:,:)));
                    voxCount(i,j,1,r,s) = sum(any(kD1,1));
                    % fiber idx of a fg which connect a roi
                    idx1 = any(kD1,2);
                    totalFiber(i,j,1,r,s) = sum(idx1);
                    
                    
                    % fiber connecting with roi2
                    D2 = reshape(pdist2(ft,rc2),2,nfiber,size(rc2,1));
                    kD2 = D2 < dist;
                    kD2 = squeeze(xor(kD2(1,:,:),kD2(2,:,:)));
                    voxCount(i,j,2,r,s) = sum(any(kD2,1));
                    % fiber idx of a fg which connect a roi
                    idx2 = any(kD2,2);
                    totalFiber(i,j,2,r,s) = sum(idx2);
                    
                    
                    % fiber connecting two rois
                    idx = idx1 & idx2;
                    fiberCount(i,j,r,s)= sum(idx);
                    
                    F = fg(j);
                    F.name = sprintf('%s_%s',[roi1.name,'_',roi2.name], F.name);
                    F.fibers = F.fibers(idx);
                    roifg(j) = F;
                    fidx{j}  = idx;
                end
                
                % save the fiber group intersecting with roi
                [~,roiName1] = fileparts(roiName{i,1});
                [~,roiName2] = fileparts(roiName{i,2});
                roifgFile = fullfile(runDir,'fibers','afq',...
                    sprintf('%s_r%.2f_%s.mat',[roiName1,'_',roiName2],radius,fgNameWoExt));
                save(roifgFile, 'roifg','fidx');
                clear roifg fidx;
            end
        end
    end
end
