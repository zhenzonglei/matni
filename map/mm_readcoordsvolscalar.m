function meas = mm_readcoordsvolscalar(sample_coords,vol_file,radius,coords_mode)
% meas = map_readvolscalar(sample_coords,vol_file,radius,coords_mode)
% both coords and vol are in the same space, i.e., MNI space or native.
if nargin < 4, coords_mode = 'RAS';end
if nargin < 3, radius = 3;end

% read volume
nii = niftiRead(vol_file);
n_meas =  size(nii.data,4);
vol = reshape(nii.data,[],n_meas);

n_sample = size(sample_coords,1);
if strcmp(coords_mode,'RAS')
    % transform samples' mni coords to img coords
    sample_crs_coords = round(mrAnatXformCoords(nii.qto_ijk, sample_coords));
    
elseif strcmp(coords_mode,'CRS')
    sample_crs_coords = sample_coords;
    
else 
    error('Wrong coords mode');
    
end

% create sphere roi for each sample
sample_roi_crs_coords  = map_make_volroi(sample_crs_coords,nii.dim(1:3),radius);


% get meas for each sample
meas = zeros(n_sample,n_meas);
for s = 1:n_sample
    sphere_coords = sample_roi_crs_coords{s,1};
    idx = sub2ind(nii.dim(1:3), sphere_coords(:,1), sphere_coords(:,2), sphere_coords(:,3));
    meas(s,:) = mean(vol(idx,:));
end
