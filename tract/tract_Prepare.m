function dwiPrepare(dwiDir,sessid)
% dwiPrepare(dwiDir, sessid)
% modify from nimsToFileBranch
% This function will take two nims folders and turn them into the
% appropriate folder branching that we will use for the longitudinal study.
% This will create a 96dir_run1, 96dir_run2, and 96dir_concat folders. The
% first two will be used for tractography and LiFE, the concatenated data
% will be used to look at diffusion in cortex.

anatDir = '/sni-storage/kalanit/biac2/kgs/projects/Longitudinal/Anatomy/';
for s = 1:length(sessid)
    % Identify the two runs
    subjDir = fullfile(dwiDir,sessid{s});
    cd(subjDir);
    nims = dir('*DTI_2mm*'); % This assumes the nims dti data folder hasn't been renamed
    nims = {nims.name};
    
    nRun = length(nims);
    if isempty(nims)
        fprintf('%s:%d run\n', sessid{s},nRun)
        continue
    else
        if nRun ~=2
            fprintf('%s:%d run\n', sessid{s},nRun)
            % continue
        end
    end
    
    % reorgnize data directory for each run
    for i = 1:nRun
        % rename run dir
        movefile(nims{i}, ['96dir_run' num2str(i)]);
        cd(['96dir_run' num2str(i)])
        
        % make raw dir for each run
        mkdir('raw');
        
        % move data to rawdir and rename them
        nifti = dir('*.nii.gz*'); nifti = {nifti.name};
        bval = dir('*.bval*'); bval = {bval.name};
        bvec = dir('*.bvec*'); bvec = {bvec.name};
        movefile(nifti{1}, ['raw/run' num2str(i) '.nii.gz']);
        movefile(bval{1}, ['raw/run' num2str(i) '.bval']);
        movefile(bvec{1},['raw/run' num2str(i) '.bvec']);
        
        % make soft link for anat dir
        system(['ln -s ' anatDir  sessid{s} '/T1 t1']);
        cd('..')
    end
    
    % make a concat dti folder
    mkdir('96dir_concat');
    % make an anatomy softlink
    system(['ln -s ' anatDir  sessid{s} '/T1  96dir_concat/t1']);
    
    % concate dwi, bvec and bval
    bvec =[];bval=[];
    for i = 1:nRun
        % load nifti data, but concate late
        ni(i) = readFileNifti(sprintf('96dir_run%d/raw/run%d.nii.gz',i,i));
        
        % concatenate bval and bvec
        bval = [bval, dlmread(sprintf('96dir_run%d/raw/run%d.bval',i,i))];
        bvec = [bvec, dlmread(sprintf('96dir_run%d/raw/run%d.bvec',i,i))];
    end
    
    % make raw dir
    mkdir('96dir_concat','raw');
    
    % concate data
    niConcat = ni(1);
    niConcat.data = cat(4,ni.data);
    % Change dimensions field in the nifti to reflect new size:
    niConcat.dim(1,4) = size(niConcat.data,4);
    niConcat.fname = '96dir_concat/raw/concat.nii.gz';
    
    % Write out the new concatenated nifti:
    writeFileNifti(niConcat);
    clear niConcat;
    
    % write concated bvec and bval
    dlmwrite('96dir_concat/raw/concat.bvec',bvec);
    dlmwrite('96dir_concat/raw/concat.bval',bval);
end



