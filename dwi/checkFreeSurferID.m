function checkFreeSurferID(sesspar,sessid)
% checkHeader(sesspar,sessid,runName)

anatDir = '/sni-storage/kalanit/biac2/kgs/projects/Longitudinal/Anatomy/';

fsDir   = getenv('SUBJECTS_DIR');
if isempty(fsDir),
    fshome = getenv('FREESURFER_HOME');
    fsDir = fullfile(fshome, 'subjects');
end


for s = 1:length(sessid)
    dwiAnat = fullfile(anatDir,sessid{s});
    fsAnat = fullfile(fsDir,sessid{s});
    
    fprintf('%s:', sessid{s});
    
    if ~exist(dwiAnat,'dir')
        fprintf('dwiAnat not exist,')
    end
    
    if ~exist(fsAnat,'dir')
        fprintf('fsAnat not exist,')
    end
    
    
    fprintf('\n');
end



