function  [endOvp,endVol] = dwiFiberEndOverlap(dwiDir, sessid, ...
    runName, fgName, roiName, foi, radius)
% dwiFiberEndOverlap(dwiDir, sessid,runName, fgName, roiName, foi, radius)
% roiName, cell array
% foi, vector
% radius, scalar
% fgName should be specified according to the afq dir

if nargin < 7, radius = 5; end

nRoi = length(roiName);
nFg = length(foi);
nRun = length(runName);
nSubj = length(sessid);

% 2 mean two terminate of one fiber
endOvp  = nan(nRoi,nRoi,nFg,2,nRun,nSubj);
endVol  = nan(nRoi,nFg,2,nRun,nSubj);
[~,fgNameWoExt] = fileparts(fgName);

for s = 1:nSubj
    for r = 1:nRun
        fprintf('Fiber endpoint overlap for (%s, %s, %s)\n',sessid{s},runName{r},fgName);
        runDir = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin');
        % use ref image info to convert the acpa coords to img coords
        refImg = niftiRead(fullfile(runDir,'bin','b0.nii.gz'),[]);
        
        fgEp = cell(nRoi,nFg,2);
        for i = 1:nRoi
            [~,roiNameWoExt] = fileparts(roiName{i});
            roifgFile = fullfile(runDir,'fibers','afq',...
                sprintf('%s_r%.2f_%s.mat',roiNameWoExt,radius,fgNameWoExt));
            if exist(roifgFile, 'file')
                fg = load(roifgFile);
                fg = fg.roifg(foi);
                for j = 1:nFg
                    nfiber = fgGet(fg(j),'nfibers');
                    ft = zeros(nfiber*2,3);
                    % Get fiber terminate
                    for k =1:nfiber
                        ft((k-1)*2+1,:) = fg(j).fibers{k}(:,1);
                        ft((k-1)*2+2,:) = fg(j).fibers{k}(:,end);
                    end
                    
                    % Convert acpc coords to img coords
                    imgCoords  = round(mrAnatXformCoords(refImg.qto_ijk, ft));
                    fgEp{i,j,1} = unique(imgCoords(1:2:end,:),'rows');
                    fgEp{i,j,2} = unique(imgCoords(2:2:end,:),'rows');
                    endVol(i,j,1,r,s) = size(fgEp{i,j,1},1);
                    endVol(i,j,2,r,s) = size(fgEp{i,j,2},1);
                end
            end
        end
        
        for t = 1:2
            for i = 1:nFg
                for j = 1:nRoi
                    for k = (j+1):nRoi
                        A = fgEp{j,i,t};
                        B = fgEp{k,i,t};
                        
                        if ~(size(A,2) ~= 3 || size(B,2) ~= 3)
                            C = intersect(A,B,'rows') ;
                            endOvp(j,k,i,t,r,s) = 2*size(C,1)/(size(A,1)+size(B,1));
                        end
                    end
                end
            end
        end
    end
end

