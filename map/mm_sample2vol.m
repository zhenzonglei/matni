function [vol_data,vol_idx] = mm_sample2vol(sample_coords,nii_vol,sample_data, ...
 dist_thr,interp)
% [vol_data,vol_idx] = mm_sample2vol(sample_coords,nii_vol,sample_coords, ...
% dist_thr,interp)
% nii_vol and sample_coords are asssumed in the same space, such as MNI152
% surface
% nii_vol, nifti object
% ineterp, nn(Nearest Neighbor), nm(Neighbor Mean), nw(Neighbor weighted)
% vol_data, the sample data projected on the volume. zeros are assigned to 
% the vox which has no samples projected on. If no sample data are provided, 
% vol_data are number of projected samples in each voxel 
% radius is in mm

if nargin < 5, interp  = 'nm';end
if nargin < 4, dist_thr = 5; end
if nargin < 3, sample_data = [];end

mask = nii_vol.data ~= 0;
[ic,ir,is] = ind2sub(size(mask),find(mask));
vol_coords = mrAnatXformCoords(nii_vol.qto_xyz, [ic,ir,is]);

% Euclidean dist between sample coords and vol coords

% calculate dist between nii_vol and coords
D = pdist2(sample_coords, vol_coords);
NB = D < dist_thr; 
W = exp(-D/std(D(NB))); % similarity weighted

% Index of vertice which has samples projected on 
vol_idx = find(any(NB));
n_vox = length(vol_idx);


% if no sample data are provided, only count the sample number for 
% each surf vertics
if isempty(sample_data)
    vol_data = sum(NB);
    
else 
    % project sample data to surface
    n_gene = size(sample_data,2);
    vol_data = zeros(n_vox,n_gene);
    switch interp
        case 'nn' % Nearest Neighbor
            [Y,I] = min(D);
            vol_data = sample_data(I(Y < dist_thr),:);
            
        case 'nm' % Neighbor Mean
            for v = 1:n_vox
                expr = sample_data(NB(:,vol_idx(v)),:);
                vol_data(v,:) = mean(expr);
            end
            
        case 'nw' % Neighbor weighted
            for v = 1:n_vox
                expr = sample_data(NB(:,vol_idx(v)),:);
                w = W(NB(:,vol_idx(v)),vol_idx(v));
                vol_data(v,:) = w'*expr/sum(w);
            end
            
        otherwise
            error('Wrong interp method');
    end
end















