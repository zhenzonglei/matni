function [sample_data,sample_idx] = mm_surf2sample(sample_coords,...
    gii_surf, gii_data, surf_space)
% surf_space, 'MNI305','MNI152','Native'
% sample_data, sample_data for each sample 
% sample_idx, index for the samples which has surface data

if nargin < 4, surf_space  = 'MNI152';end
if nargin < 3, gii_data = []; end 

if strcmp(surf_space,'MNI305')
    T = [0.9975 -0.0073 0.0176 -0.0429;
        0.0146 1.0009 -0.0024 1.5496;
        -0.0130 -0.0093  0.9971  1.1840;
        0       0        0        1];
    
    sample_coords = [sample_coords,ones(size(sample_coords,1),1)];
    sample_coords = inv(T)*sample_coords';
    sample_coords = sample_coords(1:3,:)';  
end

% Euclidean dist between sample coords and surf coords
surf_coords = double(gii_surf.vertices);
D = pdist2(sample_coords,surf_coords);
NB = D < dist_thr; 
W = exp(-D/std(D(NB))); % similarity weighted
sample_idx = find(any(NB,2));

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