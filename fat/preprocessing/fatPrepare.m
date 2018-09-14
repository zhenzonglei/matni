
function dwiPrepare(dwiDir,sessid, anatDir_system, anatDir_system_output, run)

% modify from niftisToFileBranch
% This function will take two niftis folders and turn them into the
% appropriate folder branching that we will use for the longitudinal study.
% This will create a 96dir_run1, 96dir_run2, and 96dir_concat folders. The
% first two will be used for tractography and LiFE, the concatenated data
% will be used to look at diffusion in cortex.

    % Identify the two runs
    subjDir = fullfile(dwiDir,sessid);
    cd(subjDir{1});
    niftis = dir('*DTI_2mm*.nii.gz'); % This assumes the niftis dti data folder hasn't been renamed
    niftis = {niftis.name};
    bvals = dir('*.bval*');
    bvals = {bvals.name};
    bvecs = dir('*.bvec*');
    bvecs = {bvecs.name};
    
    % reorgnize data directory for each run
        cd(subjDir{1});
        % rename run dir
        name=['96dir_run' num2str(run)]
        mkdir(name)
        copyfile(niftis{run}, ['96dir_run' num2str(run)]);
        copyfile(bvals{run}, ['96dir_run' num2str(run)]);
        copyfile(bvecs{run}, ['96dir_run' num2str(run)]);
        cd(['96dir_run' num2str(run)])
        
        % make raw dir for each run
        mkdir('raw');
        
        % move data to rawdir and rename them
        nifti = dir('**DTI_2mm*.nii.gz*'); 
        nifti = {nifti.name};
        bval = dir('*.bval*');
        bval = {bval.name};
        bvec = dir('*.bvec*');
        bvec = {bvec.name};
        
        movefile(nifti{1}, ['raw/run' num2str(run) '.nii.gz']);
        movefile(bval{1}, ['raw/run' num2str(run) '.bval']);
        movefile(bvec{1},['raw/run' num2str(run) '.bvec']);

%system(['ln -s ' anatDir_system  ' ' anatDir_system_output]);
    end



%     % make a concat dti folder
%     mkdir('96dir_concat');
%     % make an anatomy softlink
%     system(['ln -s ' anatDir  sessid{s} '/T1  96dir_concat/t1']);
%     
%     % concate dwi, bvec and bval
%     bvec =[];bval=[];
%     for i = 1:nRun
%         % load nifti data, but concate late
%         ni(i) = readFileNifti(sprintf('96dir_run%d/raw/run%d.nii.gz',i,i));
%         
%         % concatenate bval and bvec
%         bval = [bval, dlmread(sprintf('96dir_run%d/raw/run%d.bval',i,i))];
%         bvec = [bvec, dlmread(sprintf('96dir_run%d/raw/run%d.bvec',i,i))];
%     end
%     
%     % make raw dir
%     mkdir('96dir_concat','raw');
%     
%     % concate data
%     niConcat = ni(1);
%     niConcat.data = cat(4,ni.data);
%     % Change dimensions field in the nifti to reflect new size:
%     niConcat.dim(1,4) = size(niConcat.data,4);
%     niConcat.fname = '96dir_concat/raw/concat.nii.gz';
%     
%     % Write out the new concatenated nifti:
%     writeFileNifti(niConcat);
%     clear niConcat;
%     
%     % write concated bvec and bval
%     dlmwrite('96dir_concat/raw/concat.bvec',bvec);
%     dlmwrite('96dir_concat/raw/concat.bval',bval);



