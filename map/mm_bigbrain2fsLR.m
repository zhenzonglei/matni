%  mm_bigbrain2fsLR_xfm( )
%  script to map msp from bigbrain native surface to fsLR surface

clear; close all

brainmap = '/nfs/e5/stanford/ABA/brainmap';
fsLR_hemi = {'L','R'}; bigbrain_hemi = {'left','right'};
bb_msp = mm_readbigbrainhmp('none'); bb_msp = reshape(bb_msp,100,[],2);
fsLR_msp = nan(100,32492,2);

for h = 1:2
    % read bigbrain surface
    bb_surf = gifti(fullfile(brainmap,'bigbrain',...
        sprintf('bigbrain_gray_%s_327680.surf.gii',bigbrain_hemi{h})));
    bb_vertex = mm_bigbrain2mni(bb_surf.vertices);
    bb_faces = bb_surf.faces;
    
    % read fsLR surface
    fs_surf = gifti(fullfile(brainmap,'HCP/HCP_S1200_GroupAvg_v1', ...
        sprintf('S1200.%s.midthickness_MSMAll.32k_fs_LR.surf.gii',fsLR_hemi{h})));
  
    
    % map fsLR vertex to bb vertex
    [roi_surf_idx,on_surf] = ...
        mm_makesurfroi(fs_surf.vertices, bb_vertex, bb_faces,2);
    
    % calculate msp on fsLR
    v = find(on_surf);
    for i = 1:length(v)
        fsLR_msp(:,v(i),h) = nanmean(bb_msp(:,roi_surf_idx{i},h),2);
    end 
end

% save msp on fsLR
save(fullfile(brainmap,'bigbrain','bigbrain_fsLR_msp.mat'), 'fsLR_msp','fsLR_hemi');
