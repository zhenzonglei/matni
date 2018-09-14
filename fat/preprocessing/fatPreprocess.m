function fatPreprocess(dwiDir,sessid,runName,t1_name,force)
% fatPreprocess(dwiDir, sessid, runName)
% The function will preprocess the data and produce a dt6 file

if nargin < 5, force = false; end

% Init the params through vistasoft
dwParams = dtiInitParams('clobber',1);
dwParams.eddyCorrect = true;
for s = 1:length(sessid)
    for r = 1:length(runName)
    fprintf('Run preprocess for (%s,%s)\n',sessid{s},runName{r});
        
        runDir = fullfile(dwiDir,sessid{s},runName{r});
        dtFile = fullfile(runDir,'dti96trilin','dt6.mat');
        
        % if a dt6 file exists, skip the run
        if ~exist(dtFile,'file') || force
            
            k = strfind(runName{r},'_')+1;
            dtiNiftiPath = fullfile(runDir, 'raw',...
                sprintf('%s.nii.gz',runName{r}(k:end)));
            t1NiftiPath  = fullfile(runDir,'t1',t1_name);
            dwParams.dt6BaseName = fullfile(runDir,'dti96trilin');
            
              
            % Now process
            fprintf('Beginning dwi preprocess for (%s,%s)\n',...
                sessid{s},runName{r})
            
            dtiInit(dtiNiftiPath,t1NiftiPath,dwParams);
            
            fprintf('Succesfully created dt6 file for for (%s,%s)\n',...
                sessid{s},runName{r});
        else
            fprintf('DT6 already made for (%s,%s)\n',sessid{s}, runName{r})
            
        end
    end
end
