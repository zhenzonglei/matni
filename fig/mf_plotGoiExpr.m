function plotGoiExpr(roi_expr,goi_ind,goi_name)
% plotPAX6Expr(roi_expr, roi_name)
if nargin < 3, goi_name = {'PAX6','NECAB2','EMX2'}; end
if nargin < 2, goi_ind = [13219,12059,5688];end

% n_roi = size(roi_expr,1);
for g = 1:length(goi_ind)
    f = mod(g-1,18);
    if f==0
        figure('units','normalized','outerposition',[0 0 1 1],'name',goi_name{g})
    end
    
    subplot(6,3,f+1), bar(roi_expr(:,goi_ind(g))); title(goi_name{g});
    box off
end

