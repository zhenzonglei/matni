function [sample_data,sample_idx] = mm_surf2sample(gii_surf,sample_coords,...
    gii_data,dist_thr,interp)
% [sample_data,sample_idx] = mm_surf2sample(gii_surf,sample_coords,...
%     gii_data,dist_thr,interp)
% gii_surf and sample_coords are asssumed in the same space, such as MNI152
% surface
% ineterp, nn(Nearest Neighbor), nm(Neighbor Mean), nw(Neighbor weighted)
% sample_data, the surf data projected on the sample. If no surf data are 
% provided,sample_data are number of projected vertex for each sample
% sample_idx, the index of the sample which has vetices projected on
if nargin < 5, interp  = 'nm';end
if nargin < 4, dist_thr = 5; end
if nargin < 3, gii_data = [];end


src_coords = double(gii_surf.vertices);
targ_coords = sample_coords;
if ~isempty(gii_data)
    src_data = gii_data.cdata;
end
[sample_data,sample_idx] = mm_neighborinterp(src_coords,targ_coords, ...
    src_data,dist_thr,interp);