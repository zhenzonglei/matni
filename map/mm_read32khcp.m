function [data,index] = mm_read32khcp(hcp_cii,stru_name,hemi)
% [data,index] = mm_read32khcp(hcp_cii,hemi,stru_name)
% hcp_cii, 32k_fsLR metric file
% hemi, lh or rh
% stru_name, stru name which hcp cii contained, include
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

if nargin < 3, hemi = 'lh'; end

switch hemi
    case 'lh'
        hemi = 'left';
    case 'rh'
        hemi = 'right';
    otherwise 
        error('Wrong hemi');
end

stru_name = ['CIFTI_STRUCTURE_',upper(stru_name),'_',upper(hemi)];
header = fullfile('../template','32kfsLR_cifti_header.mat');
load(header,stru_name);
index = eval([stru_name,'.index']);

% read data
wb_dir = '/usr/local/neurosoft/workbench/bin_linux64/wb_command';
cii = ciftiopen(hcp_cii,wb_dir);
offset = eval([stru_name,'.offset']);
cifti_idx = offset(1) + 1:offset(1)+offset(2);
data = cii.cdata(cifti_idx,:);
