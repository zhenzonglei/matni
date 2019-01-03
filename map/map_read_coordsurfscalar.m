function [meas,sample_on_surf] = map_read_coordsurfscalar(sample_coords,...
    surf_geometry_file, surf_meas_file, surf_space,n_ring)
% [meas,sample_on_surf] = map_readsurfscalar(sample_coords,...
%     surf_geometry_file, surf_meas_file, surf_space,n_ring)
% sample_coords,surf_geometry_file, surf_meas_file are in the same space 
% n_ring is the order of the rings
% surf_space, 'MNI305','MNI152','Native'

if nargin < 5, n_ring = 3; end
if nargin < 4, surf_space  = 'MNI152';end

switch surf_space
    case 'MNI305'
        T = [0.9975 -0.0073 0.0176 -0.0429;
             0.0146 1.0009 -0.0024 1.5496;
            -0.0130 -0.0093  0.9971  1.1840;
             0       0        0        1];
       
         sample_coords = [sample_coords,ones(size(sample_coords,1),1)];
         sample_coords = inv(T)*sample_coords';
         sample_ras_coords = sample_coords(1:3,:)';
        
    case {'MNI152','Native'}
        sample_ras_coords = sample_coords;
        
    otherwise
        error('Wrong surf space');
end

% read geometry
[~,~,geo_ext] = fileparts(surf_geometry_file);
if strcmp(geo_ext,'.gii')
    gii = gifti(surf_geometry_file);
    vertex_coords = gii.vertices;
    faces = gii.faces;
else
    [vertex_coords, faces] = read_surf(surf_geometry_file);
end

% create surface roi for each sample
[sample_roi_surf_idx,sample_on_surf] = ...
    map_surfrRoiCoords(sample_ras_coords, vertex_coords, faces, n_ring);


% read meas
[~,~,meas_ext] = fileparts(surf_meas_file);
if strcmp(meas_ext,'.gii')
    gii = gifti(surf_meas_file);
    surf_meas = gii.cdata;
else
    surf_meas = read_curv(surf_meas_file);
end


% get meas for each sample
n_sample = length(sample_roi_surf_idx);

meas = zeros(n_sample,1);
for s = 1:n_sample
    idx = sample_roi_surf_idx{s};
    meas(s,:) = mean(surf_meas(idx,:));
end
