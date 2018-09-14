function  [fiberCount, voxCount, totalFiber,totalVoxel] = fatFiberIntersectRoi(fatDir,fgDir, sessid, ...
    runName, fgName, roiName, foi, radius)
% fatFiberIntersectRoi(fatDir, sessid, runName, fgName, roiName, foi, radius)
% roiName, cell array
% foi, vector
% radius, scalar
% fgName should be specified according to the afq dir 

if nargin < 8, radius = 5; end
minLength = 20;

nRoi = length(roiName);
nFg = length(foi);
% total number of fiber
totalFiber = nan(nFg);
% total number of voxel in roi
totalVoxel = nan(nRoi);
% the number of fibers touching the ROI
fiberCount = nan(nRoi,nFg);
% the number of ROI's voxel touching the fibers
voxCount = fiberCount;
[~,fgNameWoExt] = fileparts(fgName);

        fprintf('Fiber count for (%s, %s, %s)\n',...
            sessid, runName, fgName);
        runDir = fullfile(fatDir,sessid,runName,'dti96trilin');
        fgFile = fullfile(fgDir,fgName);
        load(fgFile);
        if exist('fg')==1
         fg = fg(foi); 
        else
        fg = roifg(foi);
        end

        
        % remove fiber that are less than 2cm, and 
        % calculate total fiber for each fg
        for i = 1:nFg
            L = fgGet(fg(i),'nodesperfiber');
            fg(i).fibers = fg(i).fibers(L > minLength);
            totalFiber(i) = fgGet(fg(i),'nfibers');
        end
        
        % use ref image info to convert the acpa coords to img coords
        refImg = niftiRead(fullfile(runDir,'bin','b0.nii.gz'),[]);
        dist = radius + nthroot(prod(refImg.pixdim),3);
       
        for i = 1:nRoi
            roiFile = fullfile(runDir,'ROIs',roiName{i});
            if exist(roiFile, 'file')
                roi = dtiReadRoi(roiFile);
                coords = roi.coords;
                % convert vertex acpc coords to img coords
                imgCoords  = mrAnatXformCoords(refImg.qto_ijk, coords);
                % get coords for the unique voxels
                imgCoords = unique(round(imgCoords),'rows');
                % transfer back to acpc coords
                rc = mrAnatXformCoords(refImg.qto_xyz, imgCoords);
                
                totalVoxel(i)= size(rc,1);
                nvox = totalVoxel(i);
                for j = 1:nFg
                    nfiber = totalFiber(j);
                    fc = zeros(nfiber*2,3);
                    % Get fiber terminate
                    for k =1:nfiber
                        fc((k-1)*2+1,:) = fg(j).fibers{k}(:,1);
                        fc((k-1)*2+2,:) = fg(j).fibers{k}(:,end);
                    end
                    % distance betwee a fg and a roi
                    D = reshape(pdist2(fc,rc),2,nfiber,nvox);
                    D = permute(D,[2,3,1])< dist;
                    D = xor(D(:,:,1),D(:,:,2)); 
                    voxCount(i,j) = sum(any(D,1)); 
                    % fiber idx of a fg which connect a roi
                    idx = any(D,2); 
                    fiberCount(i,j)= sum(idx); 
                    
                    % create roi's fiber
                    F = fg(j);                  
                    F.name = sprintf('%s_%s',roi.name, F.name);
                    F.fibers = F.fibers(idx);
                    roifg(j) = F;
                    fidx{j}  = idx; 
                end
                
                % save the fiber group intersecting with roi
                [~,roiNameWoExt] = fileparts(roiName{i});
                roifgFile = fullfile(runDir,'fibers','afq',...
                    sprintf('%s_r%.2f_%s.mat',roiNameWoExt,radius,fgNameWoExt));
                save(roifgFile, 'roifg','fidx');
                clear roifg fidx;            
             end
        end
    end

