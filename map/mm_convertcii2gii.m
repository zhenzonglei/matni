function mm_convertcii2gii(hcp_group_map)
% mm_convertcii2gii(hcp_group_map)
% Convert HCP cifit group map into gifti map

% hcp_group_map = {'MyelinMap_BC', 'corrThickness','thickness'};

nitool = '/nfs/s2/userhome/zhenzonglei/stanford/nitools';
addpath(fullfile(nitool,'gifti'));

target_data_dir = '/nfs/e5/stanford/ABA/data/brainmap/HCP';
hcp_group_dir = fullfile(target_data_dir,'HCP_S1200_GroupAvg_v1');
cd(target_data_dir);


in_stru = {'CORTEX_LEFT', 'CORTEX_RIGHT'};
out_stru = {'L','R'};
for m = 1:length(hcp_group_map)
    group_cifti_file = fullfile(hcp_group_dir, ...
        sprintf('S1200.%s_MSMAll.32k_fs_LR.dscalar.nii',hcp_group_map{m}));
    
    for i = 1:length(in_stru)
        gii_file = sprintf('S1200.%s.%s_MSMAll.32k_fs_LR.func.gii',out_stru{i}, hcp_group_map{m});
        wb_cmd = sprintf('wb_command -cifti-separate %s COLUMN -metric %s %s',...
            group_cifti_file, in_stru{i},gii_file);
        system(wb_cmd);
    end
end
cd(wdir);