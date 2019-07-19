function [fsLR_idx,data] = mm_read32kfsLRcii(file_name,stru_name,fsLR_idx_only)
%[data,fsLR_idx] = read_32kfsLR_cifti(file_name,stru_name)
% file_name, 32k_fsLR metric file
if nargin < 3
  fsLR_idx_only = false;
end

wb_dir = '/usr/local/neurosoft/workbench/bin_linux64/wb_command';

% clear; close all
% clear
% stru_name = 'AMYGDALA_RIGHT'; 



stru_name = ['CIFTI_STRUCTURE_',stru_name];
hcp_dir = '/nfs/e5/stanford//ABA/data/brainmap/HCP';
load(fullfile(hcp_dir,'32kfsLR_cifti_header.mat'),stru_name);


fsLR_idx = eval([stru_name,'.index']);
if fsLR_idx_only
    data = [];
    return;
end

% read data
cii = ciftiopen(file_name,wb_dir);
offset = eval([stru_name,'.offset']);
cifti_idx = offset(1) + 1:offset(1)+offset(2);
data = cii.cdata(cifti_idx,:);
