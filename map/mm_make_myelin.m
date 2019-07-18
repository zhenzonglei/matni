ls
% main script to pool data from all donors 
clear; close all

projDir = '/nfs/e5/stanford/ABA';
addpath(fullfile(projDir,'analysis','code'));

dataDir = fullfile(projDir, 'data');
donors_id = {'H0351.1009', 'H0351.1012', 'H0351.1015', ...
    'H0351.1016','H0351.2001','H0351.2002'};
n_donor = length(donors_id);



for d = 1:n_donor
    t1w = niftiRead(fullfile(dataDir,donors_id{d},'stru','T1.nii.gz'));
    t2w = niftiRead(fullfile(dataDir,donors_id{d},'stru','T2.nii.gz'));
    
    mask = t1w.data & t2w.data;
    ratio = zeros(t1w.dim);
    ratio(mask) = t1w.data(mask)./t2w.data(mask);
    
    % make myelin img data
    myelin = t1w;
    myelin.data = ratio;
    myelin.cal_min = min(ratio(:));
    myelin.cal_max = max(ratio(:));
    
    % write the nifti file
    myelin.fname = fullfile(dataDir,donors_id{d},'stru','myelin.nii.gz');
    niftiWrite(myelin);
end
