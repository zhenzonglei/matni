function mm_dscalar2dlabel(dscalar,flabel)
% mm_dscalar2dlabel(dscalar, dlabel)
% convert a dscalar cifti to a label cifti file
% dscalar, dscalar cifti file
% flabel, text file of label names
% a dlabel cifti file will save to the dir which dscalar exist.


% Using -cifti-label-import to convert dscalar.nii to dlabel.nii
dlabel = strrep(dscalar,'dscalar','dlabel'); 
cmd = sprintf('wb_command -cifti-label-import %s %s %s',dscalar, flabel,dlabel);
system(cmd);



%% IMPORT A GIFTI LABEL FILE FROM A METRIC FILE(func.nii or dscalar.nii)
%    wb_command -metric-label-import

% The GIFTI format is an established data file format intended for use with
% surface-based data.  It has subtypes for geometry (.surf.gii), continuous
% data (.func.gii, .shape.gii), and integer label data (.label.gii).  The
% files that contain data, rather than geometry, consist mainly of a 2D array,
% with one dimension having length equal to the number of vertices in the
% surface.  Label files (.label.gii) also contain a list of integer values
% that are used in the file, plus a name and a color for each one.  In
% workbench, the files for continuous data are called 'metric files', and
% .func.gii is usually the preferred extension, but there is no difference in
% file format between .func.gii and .shape.gii.  Geometry files are simply
% called 'surface files', and must contain only the coordinate and triangle
% arrays.  Notably, other software may put data arrays (the equivalent of a
% metric file) into the same file as the geometry information.  Workbench does
% not support this kind of combined format, and you must use other tools to
% separate the data array from the geometry.

