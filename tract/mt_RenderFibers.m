function  dwiRenderFibers(dwiDir, sessid, runName, fgName,foi,hemi)
%  dwiRenderFibers(dwiDir, sessid, runName, fgName, hemi)
% fgName: full name of fg including path and postfix
% foi, a vector to indicate fiber of interest
% hemi, 'rh' or 'lh'
if nargin < 6, hemi = 'lh'; end

[~,fName] = fileparts(fgName);

if strcmp(hemi,'lh')
    cameraView = [-60,20];
    xplane =  [-15, 0, 0];
else strcmp(hemi,'rh')
    cameraView = [60,20];
    xplane =  [15,0,0];
end
zplane = [0, 0, -18];


% colorMap  = linspecer(length(foi));
% colorMap= jet(length(foi));
colorMap = [0 1 0;0 0 1;1 0 0];

% set criteria
maxDist = 3;maxLen = 2;numNodes = 30;M = 'mean';maxIter = 1;count = false;
numfibers = 100;
for s = 1:length(sessid)
    close all
    for r = 1:length(runName)
        fprintf('Plot fiber %s-%s:%s\n',sessid{s},runName{r},fgName);
        runDir = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin');
        afqDir = fullfile(runDir, 'fibers','afq');
        imgDir = fullfile(afqDir,'image');
        if ~exist(imgDir,'dir')
            mkdir(imgDir);
        end
        
        b0 = readFileNifti(fullfile(dwiDir,sessid{s},runName{r},'t1','T1_QMR_1mm.nii.gz'));
        
        %% Load fg
        fgFile = fullfile(afqDir,fgName);
        if exist(fgFile,'file')
            load(fgFile);
            fg = roifg(foi);
            
            for i = 1:length(foi)
                fg(i) = AFQ_removeFiberOutliers(fg(i),maxDist,maxLen,numNodes,M,count,maxIter);
            end
            
            fibers = extractfield(fg, 'fibers');
            I =  find(~cellfun(@isempty,fibers));
            
            AFQ_RenderFibers(fg(I(1)),'numfibers',numfibers,...
                'color',colorMap(I(1),:),'camera',cameraView);
            
            for j = 2:length(I)
                AFQ_RenderFibers(fg(I(j)),'numfibers',numfibers,...
                    'color',colorMap(I(j),:),'newfig',false)
            end
            
            AFQ_AddImageTo3dPlot(b0,zplane);
            AFQ_AddImageTo3dPlot(b0,xplane);
            clear fg roifg
        else
            
            AFQ_AddImageTo3dPlot(b0,zplane);
            AFQ_AddImageTo3dPlot(b0,xplane);
            view(cameraView(1),cameraView(2));
        end
        
        axis off
        axis square
        % print('-depsc',fullfile(imgDir,sprintf('%s.eps',fName)));
        print('-dtiff','-r300',fullfile(imgDir,sprintf('%s.tiff',fName)));
    end
end