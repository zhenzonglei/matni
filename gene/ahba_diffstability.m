function ds = ahba_diffstability(roi_expr, isabs)
% ds = ahba_diffstability(roi_expr)
% roi_expr, n_roi x n_gene x n_donor

if nargin < 2, isabs = true; end

% reorder the expr to n_roi x n_donor x n_gene array
roi_expr = permute(roi_expr, [1,3,2]);
[~,n_donor,n_gene] = size(roi_expr);

ds = zeros(n_gene,1);
I = triu(true(n_donor),1);

for g = 1:n_gene
    rho =  corr(roi_expr(:,:,g),'rows','pairwise');
    ds(g) = mean(rho(I));
end

if isabs, ds = abs(ds); end
