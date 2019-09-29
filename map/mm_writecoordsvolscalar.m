function mm_writecoordsvolscalar(coords, sdata, ref_vol,out_vol,...
    radius,interp_mode)
% saveSample2Surface(sample_coords, sample_expr,save_file, n_ring, surf_space)
% sample_coords,surf_geometry_file, surf_meas_file are in the same space
% n_ring is the order of the rings
% surf_space, 'MNI305','MNI152','Native'
% interp_mode, dense or sparse

if nargin < 6, interp_mode = 'sparse'; end
if nargin < 5, radius = 3; end

% load ref and get its coords
ref = niftiRead(ref_vol);
mask = ref.data ~= 0;
n_vox = nnz(mask);
vox_ind = find(mask);
[ic,ir,is] = ind2sub(size(mask),vox_ind);
ref_coords = mrAnatXformCoords(ref.qto_xyz, [ic,ir,is]);

% calculate dist between ref and coords
dist = pdist2(ref_coords,coords);
neighbor = dist <= radius;
has_neighbor = any(neighbor,2);
svol= nan(n_vox, size(sdata,2));
for i = 1:n_vox
    if has_neighbor(i)        
        svol(i,:) = nanmean(sdata(neighbor(i,:)', :),1);
    end
end


% interplote for the ref coords which have no neighbors
if strcmp(interp_mode,'dense')
    [~,nearest_neighbor] = min(dist,[],2);
    nearest_neighbor_sdata =  sdata(nearest_neighbor,:);
    svol(~has_neighbor,:) = nearest_neighbor_sdata(~has_neighbor,:);
end

% change img data
D = zeros(prod(ref.dim(1:3)),size(sdata,2));
D(vox_ind,:) = svol;
D = reshape(D,[ref.dim(1:3),size(sdata,2)]);

ref.data = D;
ref.cal_min = min(svol(:));
ref.cal_max = max(svol(:));
ref.dim = size(sdata);

% write the nifti file
ref.fname = out_vol;
niftiWrite(ref);




