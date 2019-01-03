function dwiSpatialNormReslice(dwiDir, sessid, runName, volName, interpMeth)
 % dwiSpatialNormReslice(dwiDir, sessid, runName, volName, interpMeth)
 % interpMeth: interpolation method
if nargin < 5, interpMeth = 'tril'; end;

% Get interpolation parameters for 
% each interpolation method
if strcmp(interpMeth,'bs')
    interpParam = [7 7 7 0 0 0];
elseif strcmp(interpMeth, 'tril')
    interpParam = [1 1 1 0 0 0];
elseif strcmp(interpMeth, 'nn')
    interpParam = [0 0 0 0 0 0];
end

% Compute spatial normalization(sn) for each run
for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('Normalization & reslcie for (%s, %s)\n',sessid{s}, runName{r});
        runDir = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin');
        dtFile = fullfile(runDir, 'dt6.mat');
        load(dtFile,'t1NormParams')
        
        % Read template and get basic info
        tdir = fullfile(fileparts(which('mrDiffusion.m')), 'templates');
        templateFile = fullfile(tdir,[t1NormParams.name '_EPI.nii.gz']);
        Vtemplate = mrAnatLoadSpmVol(templateFile);
        mm = diag(chol(Vtemplate.mat(1:3,1:3)'*Vtemplate.mat(1:3,1:3)))';
        bb = mrAnatXformCoords(Vtemplate.mat,[1 1 1; Vtemplate.dim]);
       
        % Read the volume to be normalized 
        volFile = fullfile(runDir, volName);
        ni = readFileNifti(volFile);
        ni.data = mrAnatResliceSpm(ni.data, t1NormParams.sn, bb, mm, interpParam, 0);
        
        % Save normalized volume
        [fpath,fname]= fileparts(volFile);
        [~,fname] = fileparts(fname);
        ni.fname = fullfile(fpath,[fname,'_',t1NormParams.name,'.nii.gz']);
        niftiWrite(ni);
    end
end

