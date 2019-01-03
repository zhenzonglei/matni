function map_write_coordsvolscalar(sample_coords, sample_expr,...
    out_prefix, n_ring, surf_space)
% saveSample2Surface(sample_coords, sample_expr,save_file, n_ring, surf_space)
% sample_coords,surf_geometry_file, surf_meas_file are in the same space
% n_ring is the order of the rings
% surf_space, 'MNI305','MNI152','Native'

if nargin < 5, surf_space  = 'MNI152';end
if nargin < 4, n_ring = 2; end

switch surf_space
    case 'MNI305'
        T = [0.9975 -0.0073 0.0176 -0.0429;
            0.0146 1.0009 -0.0024 1.5496;
            -0.0130 -0.0093  0.9971  1.1840;
            0       0        0        1];
        
        sample_coords = [sample_coords,ones(size(sample_coords,1),1)];
        sample_coords = inv(T)*sample_coords';
        sample_ras_coords = sample_coords(1:3,:)';
        
        
    case {'MNI152',}
        hemi = {'L','R'};
        sample_ras_coords = sample_coords;
        
        brainmap_dir = '/nfs/e5/stanford/ABA/brainmap';
        surf_file = fullfile(brainmap_dir,'HCP','HCP_S1200_GroupAvg_v1', ...
            'S1200.%s.midthickness_MSMAll.32k_fs_LR.surf.gii');
        
    otherwise
        error('Wrong surf space');
end

% read cifti template to save sample expr
wb_dir = '/usr/local/neurosoft/workbench/bin_linux64/wb_command';
cii_file = fullfile(brainmap_dir,'HCP','HCP_S1200_GroupAvg_v1',...
    'S1200.MyelinMap_BC_MSMAll.32k_fs_LR.dscalar.nii');
cii = ciftiopen(cii_file,wb_dir);
cii_data = nan(size(cii.cdata,1),size(sample_expr,2));




for h = 1:length(hemi)
    hemi_surf_file = sprintf(surf_file, hemi{h});
    [~,~,geo_ext] = fileparts(hemi_surf_file);
    if strcmp(geo_ext,'.gii')
        gii = gifti(hemi_surf_file);
        vertex_coords = double(gii.vertices);
        faces = gii.faces;
    else
        [vertex_coords, faces] = read_surf(hemi_surf_file);
    end
    
    
    if strcmp(hemi{h},'L')
        hemi_sample_idx = find(sample_ras_coords(:,1) < 0);
        stru_name = 'CIFTI_STRUCTURE_CORTEX_LEFT';        
    else
        hemi_sample_idx = find(sample_ras_coords(:,1) > 0);
        stru_name = 'CIFTI_STRUCTURE_CORTEX_RIGHT';
    end
    hemi_coords = sample_ras_coords(hemi_sample_idx,:);
    
    [sample_surf_idx, sample_on_surf] = ...
        makeSurfRoiCoords(hemi_coords, vertex_coords, faces, n_ring);
    
    hemi_sample_idx = hemi_sample_idx(sample_on_surf);
    
    
    surf_expr = nan(size(vertex_coords,1),...
        length(hemi_sample_idx),size(sample_expr,2));
    
    for i = 1:length(hemi_sample_idx)
        surf_expr(sample_surf_idx{i},i,:) = ...
            repmat(sample_expr(hemi_sample_idx(i),:),length(sample_surf_idx{i}),1);
    end
    
    surf_expr = squeeze(nanmean(surf_expr,2));
    
    
    
    load(fullfile(brainmap_dir,'HCP','32kfsLR_cifti_header.mat'),stru_name);
    offset = eval([stru_name,'.offset']);
    cii_idx = offset(1) + 1:offset(1)+offset(2);
    surf_idx = eval([stru_name,'.index']) + 1;
    cii_data(cii_idx,:) = surf_expr(surf_idx,:);
end

cii.cdata = cii_data;
ciftisavereset(cii,fullfile(brainmap_dir,[out_prefix,'.32k_fs_LR.dscalar.nii']),wb_dir);



