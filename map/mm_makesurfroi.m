function [sample_roi_surf_idx,sample_on_surf] = ...
    mm_makesurfroi(sample_ras_coords,vertex_coords, faces, radius)
% [sample_roi_surf_idx,sample_on_surf] = ...
%    mm_makesurfroi(sample_ras_coords,vertex_coords, faces, radius)
% Both vertex_coords and sample_ras_coords are ras coordinates 
% radius is a int scalar,indicate rings 
if nargin < 4, radius = 2; end

% sample_ras_coords = double(sample_ras_coords);

% get vertex id for each sample
dist = pdist2(sample_ras_coords, double(vertex_coords));
for s =  1:size(sample_ras_coords,1)
    sample_roi_surf_idx{s} = find(dist(s,:) < 3);
end

sample_on_surf = ~cellfun('isempty', sample_roi_surf_idx);
sample_roi_surf_idx = sample_roi_surf_idx(sample_on_surf);

% create surf roi for each sample
for i = 1:radius
    for s =  1:length(sample_roi_surf_idx)
        seed = sample_roi_surf_idx{s};
        
        roi = [];
        for j = 1:length(seed)
            idx = any(faces==seed(j),2);
            roi = [roi; faces(idx,:)];
        end
        
        sample_roi_surf_idx{s} = unique(roi);
    end
end
    
    


