function [sample_data,sample_idx]  = mm_vol2sample(sample_coords,...
    nii_vol,vol_space)
% meas = map_readvolscalar(sample_coords,vol_file,radius,coords_mode)
% both coords and vol are in the same space, i.e., MNI space or native.

if nargin < 5, interp  = 'nm';end
if nargin < 4, dist_thr = 5; end
if nargin < 3, sample_data = [];end



if strcmp(vol_space,'MNI305')
    T = [0.9975 -0.0073 0.0176 -0.0429;
        0.0146 1.0009 -0.0024 1.5496;
        -0.0130 -0.0093  0.9971  1.1840;
        0       0        0        1];
    
    sample_coords = [sample_coords,ones(size(sample_coords,1),1)];
    sample_coords = inv(T)*sample_coords';
    sample_coords = sample_coords(1:3,:)';  
end



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
if isempty(gii_data)
    sample_data = sum(NB,2);

else 
    % project sample data to surface
    data = gii_data.cdata;
    sdim = length(sample_idx,1);
    tdim = size(data,2);
    sample_data = zeros(sdim,tdim);
    switch interp
        case 'nn' % Nearest Neighbor
            [Y,I] = min(D,2);
            sample_data = data(I(Y < dist_thr),:);
            
        case 'nm' % Neighbor Mean
            for v = 1:sdim
                meas = data(NB(sample_idx(v),:),:);
                sample_data(v,:) = mean(meas);
            end
            
        case 'nw' % Neighbor weighted
            for v = 1:sdim
                meas = data(NB(sample_idx(v),:),:);
                w = W(sample_idx(v),NB(sample_idx(v),:));
                sample_data(v,:) = w*meas/sum(w);
            end
            
        otherwise
            error('Wrong interp method');
    end
end