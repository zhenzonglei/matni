function  dwiCheck(dwiDir, sessid, runName, stepName)
% dwiCheck(sesspar, sessid, runDir, stepName)
% checkDiffusion whether Diffusion file is existed for each step
% sesspar: parent dir, cell
% sessid: sessid,cell

fprintf('Checking %s \n', stepName)
for r = 1:length(runName)
    fprintf('Subjects who are not %s in %s, include: \n', ...,
        stepName, runName{r});
    
    targFile = checkFile(runName{r}, stepName);
    
    for s = 1:length(sessid)
        targ  = fullfile(dwiDir,sessid{s}, targFile);
        if ~exist(targ,'file');
            fprintf('%s\n', sessid{s});
        end
    end
end


function targFile = checkFile(runDir, stepName)

switch stepName
    case 'dwiPrepare'
        k = strfind(runDir,'_') + 1;
        targFile = fullfile(runDir, 'raw', [runDir(k:end),'.nii.gz']);
    case 'dwiMakeWMmask'
        targFile = fullfile(runDir, 't1', 'wm_mask_resliced.nii.gz');
        
    case 'dwiPreprocess'
        targFile = fullfile(runDir, 'dti96trilin','dt6.mat');
        
    case 'dwiRunET'
        targFile = fullfile(runDir, 'dti96trilin','fibers','ETconnectome_candidate.mat');
        
    case 'dwiRunLife'
        targFile = fullfile(runDir, 'dti96trilin','fibers','ETconnectome_candidate_optimize_niter500.mat');
        
    otherwise
        error('Wrong stepName');
end




