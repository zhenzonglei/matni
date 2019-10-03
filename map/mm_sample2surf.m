function [surf_expr,surf_idx] = mm_sample2surf(surf_coords,sample_coords, sample_expr,...
    dist_thr,interp)
% [surf_expr,surf_idx] = mm_sample2surf(surf_coords,sample_coords, sample_expr,...
% dist_thr,interp)
% surf_coords and sample_coords are asssumed in the same space, such as MNI152
% surface
% ineterp, nn(Nearest Neighbor), nm(Neighbor Mean), nw(Neighbor weighted)
% surf_expr, the sample expr projected on the surface. zeros are assigned to 
% the veretx which has no samples projected on. 

if nargin < 5, interp  = 'nm';end
if nargin < 4, dist_thr = 5; end

% Euclidean dist between sample coords and surf coords
D = pdist2(sample_coords,surf_coords);
NB = D < dist_thr; 
W = exp(-D/std(D(NB))); % similarity weighted

% Index of vertice which has samples projected on 
surf_idx = find(any(NB));
n_vtx = length(surf_idx);


% project sample to surface
n_gene = size(sample_expr,2);
surf_expr = zeros(n_vtx,n_gene);
switch interp
    case 'nn' % Nearest Neighbor
        [Y,I] = min(D);
        surf_expr = sample_expr(I(Y < dist_thr),:);
        
    case 'nm' % Neighbor Mean
        for v = 1:n_vtx
            expr = sample_expr(NB(:,surf_idx(v)),:);
            surf_expr(v,:) = mean(expr);
        end
        
    case 'nw' % Neighbor weighted
        for v = 1:n_vtx
            expr = sample_expr(NB(:,surf_idx(v)),:);
            w = W(NB(:,surf_idx(v)),surf_idx(v));
            surf_expr(v,:) = w'*expr/sum(w);
        end
        
    otherwise
        error('Wrong interp method');
end