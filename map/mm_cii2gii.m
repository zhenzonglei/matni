function mm_cii2gii(hcp_map)
% mm_cii2gii(hcp_map)
% Convert HCP cifit map into gifti map
% hcp_map = {'MyelinMap_BC', 'corrThickness','thickness'};

nitool = '/nfs/s2/userhome/zhenzonglei/stanford/nitools';
addpath(fullfile(nitool,'gifti'));

target_data_dir = '/nfs/e5/stanford/ABA/data/brainmap/HCP';
hcp_dir = fullfile(target_data_dir,'HCP_S1200_GroupAvg_v1');
cd(target_data_dir);


in_stru = {'CORTEX_LEFT', 'CORTEX_RIGHT'};
out_stru = {'L','R'};
for m = 1:length(hcp_map)
    group_cifti_file = fullfile(hcp_dir, ...
        sprintf('S1200.%s_MSMAll.32k_fs_LR.dscalar.nii',hcp_map{m}));
    
    for i = 1:length(in_stru)
        gii_file = sprintf('S1200.%s.%s_MSMAll.32k_fs_LR.func.gii',out_stru{i}, hcp_map{m});
        wb_cmd = sprintf('wb_command -cifti-separate %s COLUMN -metric %s %s',...
            group_cifti_file, in_stru{i},gii_file);
        system(wb_cmd);
    end
end
cd(wdir);