function [targ_data,targ_idx] = mm_neighborinterp(src_coords,targ_coords, src_data,...
    dist_thr,meth)
% [targ_data,targ_idx] = mm_neighborinterp(targ_coords,src_coords, src_data,...
% dist_thr,meth)
% targ_coords and src_coords are asssumed in the same space, such as MNI152
% surface
% ineterp, nn(Nearest Neighbor), nm(Neighbor Mean), nw(Neighbor weighted)
% targ_data, the sample targ_data projected on the surface. zeros are assigned to 
% the veretx which has no samples projected on. 
% if no sample targ_data are provided, targ_data are number of projected samples 
% in each vertics 

if nargin < 5, meth  = 'nm';end
if nargin < 4, dist_thr = 5; end
if nargin < 3, src_data = [];end

% Euclidean dist between src coords and targ coords
D = pdist2(src_coords,targ_coords);
NB = D < dist_thr; 
W = exp(-D/std(D(NB))); % similarity weighted

% Index of vertice which has samples projected on 
targ_idx = find(any(NB));
n_targ = length(targ_idx);


% if no sample targ_data are provided, only count the sample number for 
% each surf vertics
if isempty(src_data)
    targ_data = sum(NB(:,targ_idx));
    
else 
    % project sample targ_data to surface
    targ_data = zeros(n_targ, size(src_data,2));
    switch meth
        case 'nn' % Nearest Neighbor
            [~,I] = min(D);
            targ_data = src_data(I(targ_idx),:);
            
        case 'nm' % Neighbor Mean
            for t = 1:n_targ
                d = src_data(NB(:,targ_idx(t)),:);
                targ_data(t,:) = mean(d);
            end
            
        case 'nw' % Neighbor weighted
            for t = 1:n_targ
                d = src_data(NB(:,targ_idx(t)),:);
                w = W(NB(:,targ_idx(t)),targ_idx(t));
                targ_data(t,:) = w'*d/sum(w);
            end
            
        otherwise
            error('Wrong meth method');
    end
end