function  selVal = fatRoiSelectivity(fatDir, sessid, mapName, roiName)
% selVal = fatRoiSelectivity(fatDir, sessid, mapName, roiName)
% sessid, a 1xN cell array
% mapName, a 1xN cell array
% roiName, a 1xN cell array
cDir = pwd;

nSubj = length(sessid);
nRoi = length(roiName);
nMap = length(mapName);
selVal = NaN(nRoi,nMap,nSubj);
for s = 1:nSubj
    sessDir = fullfile(fatDir,sessid{s},'96dir_run1','bold');
    if exist(sessDir, 'dir')
        cd(sessDir);
        
        for m = 1:nMap
            fprintf('Extract Roi selectivity(%s, %s)\n',sessid{s},mapName{m});
            if exist(fullfile('Gray','GLMs',mapName{m}),'file')
                fName = fullfile('Gray','GLMs',mapName{m});
                % fprintf('%s-%s\n',sessid{s}, mapName{m})
                
            elseif exist(fullfile('Gray','GLMs',strrep(mapName{m}, '_', '-')),'file');
                fName = fullfile('Gray','GLMs',strrep(mapName{m}, '_', '-'));
                % fprintf('%s-%s\n',sessid{s}, strrep(mapName{m}, '_', '-'))
                
            else
                fprintf('%s-No %s\n',sessid{s}, mapName{m});
                continue
            end
           
            % read map val and map coords
            map = load(fName);
            mapVal = map.map{1};
            coords = load(fullfile('Gray','coords.mat'),'coords');
            mapCoords = coords.coords;
            for i = 1:nRoi
                % read roi coords
                if exist(fullfile('3DAnatomy','ROIs',roiName{i}),'file');
                    ROI = load(fullfile('3DAnatomy','ROIs',roiName{i}),'ROI');
                    roiCoords = ROI.ROI.coords;
                    % find index for the vertex in the roi
                    [~,idx] = intersect(mapCoords',roiCoords','rows');
                    selVal(i,m,s) = mean(mapVal(idx));
                end
            end
        end
    end
end
cd(cDir);
