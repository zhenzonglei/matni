function [ds, goi, goni] = ahba_diffstability(roi_expr, top)
% roi_expr, n_roi x n_gene x n_donor
if nargin < 2, top = 5; end 

% rearrange the expr to n_roi x n_donor x n_gene array
roi_expr = permute(roi_expr, [1,3,2]);
[~,n_donor,n_gene] = size(roi_expr);

ds = zeros(1,n_gene);
I = triu(true(n_donor),1);

for g = 1:n_gene
    rho =  corr(roi_expr(:,:,g),'rows','pairwise');
    ds(g) = mean(rho(I));
end

gpct = prctile(ds,[top, 100-top]);
goi = ds > gpct(2);
goni = ds < gpct(1);



figure, histogram(ds);