function mm_overlaycoordsvol(sample_coords,vol_ref_file,vol_out_file,radius,coords_mode)
% writeCoord2Volume(coords,vol_ref_file,vol_out_file,radius,coords_mode)
% radius is in voxel unit

if nargin < 5, coords_mode = 'RAS';end
if nargin < 4, radius = 2;end
coords = sample_coords;

ref = niftiRead(vol_ref_file);
if strcmp(coords_mode,'RAS')
    % transform samples' RAS coords to CRS coords
    coords = round(mrAnatXformCoords(ref.qto_ijk, coords));
end

% make sphere roi around each coords
coords = mm_makevolroi(coords,ref.dim(1:3),radius);

% make probability map
pm = zeros(ref.dim(1:3));
for i = 1:length(coords)
    sphere_coords = coords{i};
    vol = zeros(ref.dim);
    vol(sub2ind(ref.dim, sphere_coords(:,1), sphere_coords(:,2), sphere_coords(:,3))) = 1;
    % add up
    pm = pm + vol;
end


% change img data
ref.data = pm;
ref.cal_min = min(pm(:));
ref.cal_max = max(pm(:));

% write the nifti file
ref.fname = vol_out_file;
niftiWrite(ref);
