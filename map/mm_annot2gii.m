function mm_annot2gii(annot,hemi,surf)
% mm_annot2gii(annot)
% convert freesurfer annot file to gii file
% hemi, lh or rh
% surface, fsaverage or native surface

if nargin < 3, surf = 'fsaverage'; end

switch surf
    case 'fsaverage'
        surf_dir = '/nfs/e5/stanford/ABA/brainmap/surface/fsaverage/surf';
    otherwise
        error('Wrong surf');
end



curr_dir = pwd;
[map_dir,map_name,~] = fileparts(annot);cd(map_dir);

% run cmd
hsurf = fullfile(surf_dir,sprintf('%s.white',hemi));
gii = fullfile(map_dir,sprintf('%s.func.gii',map_name));
cmd = sprintf('mris_convert --annot %s %s %s',annot,hsurf,gii);
system(cmd);

% back to work dir
cd(curr_dir);