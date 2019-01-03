function [roi_expr,roi_expr_sem] = calcRoiExpr(expr,roi_idx)
% [roi_expr,roi_expr_sem] = calcRoiExpr(expr,roi_idx)
% roi_idx, nSample x nRoi, logical matrix
if size(expr,1) ~= size(roi_idx,1)
    error('roi_idx is logical index array, with the same row as expr');
end

n_roi = size(roi_idx,2); n_gene = size(expr,2);
roi_expr = zeros(n_roi,n_gene);
roi_expr_sem = zeros(n_roi,n_gene);
for i = 1:n_roi
    I = roi_idx(:,i);
    roi_expr(i,:) = mean(expr(I,:));
    roi_expr_sem(i,:) = std(expr(I,:))/sqrt(nnz(I));
end


