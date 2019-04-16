function p = ahba_anova(expr,sys_sample,sys_name)
% p = ahba_anova(expr,sys_sample,sys_name)
% anova for each gene across brain system
% expr, n_sample x n_genes
% sys_sample, n_sample x n_sys


if size(expr,1) ~= size(sys_sample,1)
    error('expr and sys_sample not match.')
end

n_sys = size(sys_sample,2);
n_sys_sample = sum(sys_sample);

I = 1; group = {};
offset = zeros(n_sys,2); % begin and end of a section of data
for s = 1:n_sys
    J  = I+n_sys_sample(s)-1;
    group(I:J) = sys_name(s);
    offset(s,:) = [I,J];
    I = J+1;
end

% run anova for each gene
n_gene = size(expr,2);
data = nan(sum(n_sys_sample),1);
p = nan(n_gene,1);
for g = 1:n_gene
    for s = 1:n_sys
        data(offset(s,1):offset(s,2)) = expr(sys_sample(:,s),g);
    end
    p(g) = anova1(data,group,'off');
end

p = -log10(p);