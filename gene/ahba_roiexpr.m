function [roi_expr,roi_expr_sem] = ahba_roiexpr(expr,roi_idx,donor)
% [roi_expr,roi_expr_sem] = ahba_roiexpr(expr,roi_idx)
% roi_idx, nSample x nRoi, logical matrix

if nargin < 3, donor = []; end 

[n_sample, n_gene] = size(expr);
if size(roi_idx,1) ~= n_sample
    error('roi_idx is n_sample x n_roi logical index array, with the same row as expr');
end
n_roi = size(roi_idx,2); 


% donor 
if isempty(donor), donor = ones(n_sample,1); end 
donor_id = unique(donor); 
n_donor = length(donor_id);


% summarize the mean and sem for each roi from each donor
roi_expr = zeros(n_roi,n_gene,n_donor);
roi_expr_sem = zeros(n_roi,n_gene,n_donor);
for d = 1:n_donor
    for i = 1:n_roi
        I = roi_idx(:,i) & (donor == donor_id(d));
        roi_expr(i,:,d) = mean(expr(I,:),1);
        roi_expr_sem(i,:,d) = std(expr(I,:))/sqrt(nnz(I));
    end
end


%  d(any(isnan(d),2),:) = [];
% roi_expr = zscore(roi_expr,0,1); 
