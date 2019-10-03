function [surf_data,surf_idx] = mm_sample2surf(gii_surf,sample_coords, sample_data,...
    dist_thr,interp)
% [surf_data,surf_idx] = mm_sample2surf(gii_surf,sample_coords, sample_data,...
% dist_thr,interp)
% gii_surf and sample_coords are asssumed in the same space, such as MNI152
% surface
% ineterp, nn(Nearest Neighbor), nm(Neighbor Mean), nw(Neighbor weighted)
% surf_data, the sample data projected on the surface. zeros are assigned to 
% the veretx which has no samples projected on. 
% if no sample data are provided, surf_data are number of projected samples 
% in each vertics 

if nargin < 5, interp  = 'nm';end
if nargin < 4, dist_thr = 5; end
if nargin < 3, sample_data = [];end

% Euclidean dist between sample coords and surf coords
surf_coords = double(gii_surf.vertices);
D = pdist2(sample_coords,surf_coords);
NB = D < dist_thr; 
W = exp(-D/std(D(NB))); % similarity weighted

% Index of vertice which has samples projected on 
surf_idx = find(any(NB));
n_vtx = length(surf_idx);


% if no sample data are provided, only count the sample number for 
% each surf vertics
if isempty(sample_data)
    surf_data = sum(NB);
    
else 
    % project sample data to surface
    n_gene = size(sample_data,2);
    surf_data = zeros(n_vtx,n_gene);
    switch interp
        case 'nn' % Nearest Neighbor
            [Y,I] = min(D);
            surf_data = sample_data(I(Y < dist_thr),:);
            
        case 'nm' % Neighbor Mean
            for v = 1:n_vtx
                expr = sample_data(NB(:,surf_idx(v)),:);
                surf_data(v,:) = mean(expr);
            end
            
        case 'nw' % Neighbor weighted
            for v = 1:n_vtx
                expr = sample_data(NB(:,surf_idx(v)),:);
                w = W(NB(:,surf_idx(v)),surf_idx(v));
                surf_data(v,:) = w'*expr/sum(w);
            end
            
        otherwise
            error('Wrong interp method');
    end
end