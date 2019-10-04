function [surf_data,surf_idx] = mm_sample2surf(sample_coords,gii_surf,...
    sample_data,dist_thr,interp)
% [surf_data,surf_idx] = mm_sample2surf(sample_coords,gii_surf,...
%     sample_data,dist_thr,interp)
% gii_surf and sample_coords are asssumed in the same space, such as MNI152
% surface
% ineterp, nn(Nearest Neighbor), nm(Neighbor Mean), nw(Neighbor weighted)
% surf_data, the sample data projected on the surface. If no sample data are 
% provided,surf_data are number of projected samples in each vertics
% surf_idx, the index of the vertics which has samples projected on

if nargin < 5, interp  = 'nm';end
if nargin < 4, dist_thr = 5; end
if nargin < 3, sample_data = [];end

src_coords = sample_coords;
targ_coords = double(gii_surf.vertices);
src_data = sample_data;
[surf_data,surf_idx] = mm_neighborinterp(src_coords,targ_coords, ...
    src_data,dist_thr,interp);