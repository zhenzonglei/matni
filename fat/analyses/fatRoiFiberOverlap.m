function fiberCount = fatRoiFiberOverlap(fatDir, sessid, runName, fgName, roiName, foi, radius)
% fatRoiFiberUnique(fatDir, sessid, runName, fgName, roiName, foi, radius)
% roiName, cell array
% foi, vector
% radius, scalar
% fgName should be specified according to the afq dir
if nargin < 7, radius = '0.00'; end

nRoi = length(roiName);
nFg = length(foi);
nRun = length(runName);
nSubj = length(sessid);
fiberCount = nan(nRoi,nFg,nRun,nSubj);

fprintf('Fiber unique for %s\n', fgName);
for s = 1:nSubj
    for r = 1:nRun
        fprintf('(%s, %s)\n', sessid{s}, runName{r});
        runDir = fullfile(fatDir,sessid{s},runName{r},'dti96trilin');

        %% Read fg from all rois
        roi = [];
        for i = 1:nRoi
            roifgFile = fullfile(runDir,'fibers','afq',...
                sprintf('%s_r%s_%s.mat',roiName{i},radius,fgName));
            if exist(roifgFile,'file')
                roi = [roi,i];
                F = load(roifgFile);
                fg(length(roi),:) = F.roifg(foi);
                idx(length(roi),:) = F.fidx(foi);
            end
        end
        
        if exist('idx','var')
            %% Remove overlap fibers
            for f = 1:nFg
                % Get unique fiber for a fg
                U = sum(reshape(cell2mat(idx(:,f)),[],length(roi)),2)>1;
                for i = 1:length(roi)
                    A = idx{i,f}; % old idx
                    B = A & U; % new non-overlaping fiber idx
                    idx{i,f} = B;
                    [~,ia,~] = intersect(find(A),find(B));
                    fg(i,f).fibers = fg(i,f).fibers(ia);
                    
                    % count the fiber
                    fiberCount(roi(i),f,r,s) = length(ia);
                end
            end
            
            %% save unique fibers for existed roi
            for i = 1:length(roi)
            roifgFile = fullfile(runDir,'fibers','afq',...
                sprintf('%s_%s_r%s_%s_overlap.mat',roiName{1},roiName{2},radius,fgName))
                roifg = fg(i,:);
                fidx = idx(i,:);
                
                save(roifgFile, 'roifg','fidx');
                clear roifg fidx;
            end
%             
%             for i = 1:1
%                 roifgFile = fullfile(runDir,'fibers','afq',...
%                     sprintf('%s_r%s_%s_overlap.mat',roiName{i},radius,fgName))
%             end
%             roifg = fg(i,:);
%             fidx = idx(i,:);
%             
%             save(roifgFile, 'roifg','fidx');
%             clear roifg fidx;
%         end


             clear fg idx;
        end
    end
end
