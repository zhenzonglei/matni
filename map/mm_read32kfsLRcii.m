function [data,fsLR_idx] = mm_read32kfsLRcii(file_name,hemi,stru_name)
% [data,fsLR_idx] = mm_read32kfsLRcii(file_name,hemi,stru_name)
% file_name, 32k_fsLR metric file
% hemi, right or left
% stru_name, stru name cii contained, include
% ACCUMBENS
% AMYGDALA
% BRAIN_STEM
% CAUDATE
% CEREBELLUM
% CORTEX
% DIENCEPHALON_VENTRAL
% HIPPOCAMPUS
% PALLIDUM
% PUTAMEN
% THALAMUS

if nargin < 3, hemi = 'right'; end

stru_name = ['CIFTI_STRUCTURE_',upper(stru_name),'_',upper(hemi)];
load(fullfile('../template','32kfsLR_cifti_header.mat'),stru_name);
fsLR_idx = eval([stru_name,'.index']);

% read data
wb_dir = '/usr/local/neurosoft/workbench/bin_linux64/wb_command';
cii = ciftiopen(file_name,wb_dir);
offset = eval([stru_name,'.offset']);
cifti_idx = offset(1) + 1:offset(1)+offset(2);
data = cii.cdata(cifti_idx,:);
