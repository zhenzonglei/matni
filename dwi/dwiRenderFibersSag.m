function  dwiRenderFibersSag(dwiDir, sessid, runName, fgName,foi)
%  dwiRenderFibers(dwiDir, sessid, runName, fgName, hemi)
% fgName: full name of fg including path and postfix
% foi, a vector to indicate fiber of interest

if nargin < 5, foi = [3:4, 11:12, 17:20]; end
if nargin < 4, fgName = 'ETconnectome_candidate_classified.mat'; end

[~,fName] = fileparts(fgName);
foi = reshape(foi,2,[]);
cameraView = [-90,0;90,0];
imgPos =  [-2, 0, 0; 2,0,0];
hemisphere = {'lh','rh'};


colorMap= jet(length(foi));
for s = 1:length(sessid)
    for r = 1:length(runName)
        close all
        fprintf('Plot fiber %s-%s:%s\n',sessid{s},runName{r},fgName);
        
        runDir = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin');
        afqDir = fullfile(runDir, 'fibers','afq');
        imgDir = fullfile(afqDir,'image');
  
        %% Load fg
        fgFile = fullfile(afqDir,fgName);
        load(fgFile);
        
        b0 = readFileNifti(fullfile(runDir,'bin','b0.nii.gz'));
        
        for i = 1:length(hemisphere)
            AFQ_RenderFibers(fg(foi(i,1)),'numfibers',400,...
                'color',colorMap(1,:),'camera',cameraView(i,:));
           
            for j = 2:length(foi)
                f = foi(i,j);
                AFQ_RenderFibers(fg(f),'numfibers',400,...
                    'color',colorMap(j,:),'newfig',false)
            end
            
            AFQ_AddImageTo3dPlot(b0,[0, 0, -25]);
            AFQ_AddImageTo3dPlot(b0,imgPos(i,:));
        
            foiFig = fullfile(imgDir,sprintf('%s_foi_%s_sag.png',fName, hemisphere{i}));
            print('-dpng','-r200',foiFig); 
        end
        
    end
end