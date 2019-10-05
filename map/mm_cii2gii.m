function mm_cii2gii(hcp_map,stru_name)
% mm_cii2gii(hcp_map)
% Convert HCP cifit map into gifti map
% hcp_map, MyelinMap_BC, corrThickness,thickness;

if nargin < 2,  stru_name = {'CORTEX_LEFT', 'CORTEX_RIGHT'}; end


nitool = '/nfs/s2/userhome/zhenzonglei/stanford/nitools';
addpath(fullfile(nitool,'gifti'));

hcp_dir = '/nfs/e5/stanford/ABA/data/brainmap/HCP';
hcp_dir = fullfile(hcp_dir,'HCP_S1200_GroupAvg_v1');
cd(hcp_dir);


out_stru = {'L','R'};
for i = 1:length(stru_name)
    gii_out = sprintf('S1200.%s.%s_MSMAll.32k_fs_LR.func.gii',out_stru{i}, hcp_map);
    wb_cmd = sprintf('wb_command -cifti-separate %s COLUMN -metric %s %s',...
        hcp_map, stru_name{i},gii_out);
    system(wb_cmd);
end

cd(wdir);