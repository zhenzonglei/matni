function [surf_data,surf_idx] = mm_surf2sample(sample_coords,...
    gii_surf, gii_data, surf_space)

% surf_space, 'MNI305','MNI152','Native'

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
surf_idx = D < dist_thr; 
W = exp(-D/std(D(surf_idx))); % similarity weighted

% if no sample data are provided, only count the sample number for 
% each surf vertics
if isempty(gii_data)
    surf_data = sum(surf_idx,2);

else 
    % project sample data to surface
    data = gii_data.cdata;
    sdim = size(sample_coords,1);
    tdim = size(data,2);
    surf_data = zeros(sdim,tdim);
    switch interp
        case 'nn' % Nearest Neighbor
            [Y,I] = min(D,2);
            surf_data = data(I(Y < dist_thr),:);
            
        case 'nm' % Neighbor Mean
            for v = 1:sdim
                expr = data(NB(:,surf_idx(v)),:);
                surf_data(v,:) = mean(expr);
            end
            
        case 'nw' % Neighbor weighted
            for v = 1:sdim
                expr = data(NB(:,surf_idx(v)),:);
                w = W(NB(:,surf_idx(v)),surf_idx(v));
                surf_data(v,:) = w'*expr/sum(w);
            end
            
        otherwise
            error('Wrong interp method');
    end
end