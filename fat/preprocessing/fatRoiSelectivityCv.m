function selVal = fatRoiSelectivityCv(fatDir, sessid, contrast, roiName)
% sessid, a 1xN cell array
% constrast, a 1xN vector, actvie =1, inactive = -1
% roiName, a 1xN cell array
cDir = pwd;
color = 'g';
radius = 4; % size of spherical convolution kernel
scriptFlag = true; % This was necessary, otherwise roiDilate would change the view struct and it couldn't find the selected ROI

nSubj = length(sessid);
nRoi = length(roiName);
nBold = 3;
nCon = size(contrast,1);
selVal = NaN(nRoi,nSubj,nCon,nBold);
for s = 1:nSubj
    sessDir = fullfile(fatDir,sessid{s},'96dir_run1','bold');
    fprintf('Roi CV selectivity for %s\n',sessid{s});
    if exist(fullfile(sessDir, 'Gray','MotionComp_RefScan1','TSeries','Scan3'), 'dir')        
        cd(sessDir);
        view = initHiddenGray(3,1);
        for i = 1:nRoi
            if exist(fullfile('3DAnatomy','ROIs',roiName{i}),'file');
                [~,rName] = fileparts(roiName{i});
                view = loadROI(view,roiName{i});
                dilateName = [rName '_Dilated' num2str(radius) 'mm'];
                [view, roiDil] = roiDilate(view, view.ROIs(end), radius, dilateName, color, scriptFlag);
                for b = 1:nBold
                    locRun = 1:nBold;locRun(b) = [];
                    % Initialize mv for the Loc runs
                    
                    
                    mvLoc = mv_init(view,roiDil.name,locRun);
                    % Set HRF and events per block
                    mvLoc.params.glmHRF = 3;
                    mvLoc.params.eventsPerBlock = 4;
                    % Run Glm
                    mvLoc = mv_applyGlm(mvLoc);
                    
                    
                    % Initialize mv for the left runs
                    mvSel = mv_init(view,roiDil.name,b);
                    mvSel.params.glmHRF = 3;
                    mvSel.params.eventsPerBlock = 4;
                    mvSel = mv_applyGlm(mvSel);
                 
                    for  c = 1:nCon
                        active  = find(contrast(c,:)==1);
                        inactive= find(contrast(c,:) == -1);
                        % Compute a contrast for Loc runs
                        [stat,ces,tLoc,units] = glm_contrast(mvLoc.glm,active,inactive,'T');
                        %  Compute a contrast for Left run
                        [stat,ces,tSel,units] = glm_contrast(mvSel.glm,active,inactive,'T');
                        
                        % Get sel form left run
                        selVal(i,s,c,b) = mean(tSel(tLoc >= 3));                    
                    end
                end
            end
        end
    end
end

selVal = nanmean(selVal,4);
cd(cDir);
