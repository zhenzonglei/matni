function map_convert_cii2gii()
% split the hcp cifit group map into gifti map
clear; close all
abadir = '/nfs/e5/stanford/ABA';
nitool = '/nfs/s2/userhome/zhenzonglei/stanford/nitools';
addpath(fullfile(nitool,'gifti'));
wb_dir = '/usr/local/neurosoft/workbench/bin_linux64/wb_command';



wdir = pwd;
target_data_dir = '/nfs/e5/stanford/ABA/data/brainmap/HCP';
hcp_group_dir = fullfile(target_data_dir,'HCP_S1200_GroupAvg_v1');
cd(target_data_dir);
in_stru = {'CORTEX_LEFT', 'CORTEX_RIGHT'};
out_stru = {'L','R'};
group_map = {'MyelinMap_BC', 'corrThickness','thickness'};
for m = 1:length(group_map)
    group_cifti_file = fullfile(hcp_group_dir, ...
        sprintf('S1200.%s_MSMAll.32k_fs_LR.dscalar.nii',group_map{m}));
    
    figure('units','normalized','outerposition',[0 0 1 1],'name',group_map{m});
    for i = 1:length(in_stru)
        gii_file = sprintf('S1200.%s.%s_MSMAll.32k_fs_LR.func.gii',out_stru{i}, group_map{m});
        wb_cmd = sprintf('wb_command -cifti-separate %s COLUMN -metric %s %s',...
            group_cifti_file, in_stru{i},gii_file);
         system(wb_cmd);
        
        %% check the output
        g = gifti(fullfile(target_data_dir,gii_file));
        data = g.cdata; data = data(data~=0);
        subplot(1,2,i), histogram(data),axis square,title(in_stru{i});
    end
end
cd(wdir);


%% cifti read and write code
% %% make group mean cifti map by self
% allsubj_cifiti_file = fullfile('/nfs/e5/stanford/myelin/data',...
%     'MyelinMap_BC_MSMAll.32k_fs_LR.dscalar.nii');
% 
% % cii = ciftiopen(allsubj_cifiti_file,wb_dir);
% % data = mean(cii.cdata,2);
% % 
% group_data_dir = '/nfs/e5/stanford/ABA/data/brainmap/HCP';
% group_cifti_file = fullfile(group_data_dir,...
%     'HCP_Myelin_BC_MSMAll.32k_fs_LR.dscalar.nii');
% % cii.cdata = data;
% % ciftisavereset(cii,group_cifti_file,wb_dir);

