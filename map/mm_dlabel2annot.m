%% split the rsfs cifit group map into gifti map
function mm_dlabel2annot()

standard_atlas = '/nfs/e5/stanford/ABA/brainmap/surface/standard_mesh_atlases';
rsfs = fullfile(standard_atlas, 'resample_fsaverage');

brainmap = '/nfs/e5/stanford/ABA/brainmap';
cd(fullfile(brainmap, 'vcAtlas'));

in_stru = {'CORTEX_LEFT', 'CORTEX_RIGHT'};
out_stru = {'L','R'};


for h = 1:2
    % Using workbench, convert parcellation dabel.nii file label.gii file:
    separate = sprintf('wb_command -cifti-separate vcAtlas.32k_fs_LR.dlabel.nii COLUMN -label %s vcAtlas.32k_fs_LR.%s.label.gii',in_stru{h},out_stru{h})
    system(separate)
    
    %  Using workbench, convert label.gii file to fsaverage space:
    fsLR_sph = fullfile(rsfs, sprintf('%s.sphere.32k_fs_LR.surf.gii',out_stru{h}));
    fsLR2fs = fullfile(rsfs,sprintf('fs_%s/fs_%s-to-fs_LR_fsaverage.%s_LR.spherical_std.164k_fs_%s.surf.gii', out_stru{h}, out_stru{h},out_stru{h},out_stru{h}));
    resample = sprintf('wb_command -label-resample vcAtlas.32k_fs_LR.%s.label.gii %s %s BARYCENTRIC vcAtlas.%s.fsaverage164.label.gii',out_stru{h}, fsLR_sph, fsLR2fs,out_stru{h})
    system(resample)
    
    %  Using freesurfer, convert files from gii to annot:
    convert = sprintf('mris_convert --annot ./vcAtlas.%s.fsaverage164.label.gii %s ./vcAtlas.%s.fsaverage164.annot', out_stru{h}, fsLR2fs, out_stru{h})
    system(convert)
end




