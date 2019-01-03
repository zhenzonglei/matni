%  select gene by inter donor reliability
clear
close all
projDir = '/nfs/e5/stanford/ABA';
addpath(fullfile(projDir,'analysis','code'));
dataDir = fullfile(projDir, 'data');


%% Prepare data
% Load gene data
geneFile = 'pooled_gene_entrez.mat';
G = load(fullfile(dataDir,geneFile));
expr = G.expr;coords = G.coords;donor = G.donor;symbol= G.symbol;
[n_sample,n_gene] = size(expr);

% Map samples to atlas roi
[sample_roi_idx,roi_expr,roi_id,roi_name] = mapSample2CytoAtlas(expr,coords);
n_roi = length(roi_id);

% Map samples to atlas system
[sample_sys_idx,sys_name,roi_in_sys] = mapSample2Sys(sample_roi_idx,roi_name);
n_sys = length(sys_name);


%% select genes using whole brain roi-expr pattern
n_donor = 6;
donor_roi_expr = nan(n_roi,n_donor,n_gene);
for d = 1:n_donor
    for i = 1:n_roi
        idx = sample_roi_idx(:,i) & (donor==d);
        donor_roi_expr(i,d,:) = mean(expr(idx,:));
    end
end

brainR = zeros(n_gene,1); 
I = triu(true(n_donor),1);
for g = 1:n_gene
    rho =  corr(donor_roi_expr(:,:,g),'rows','pairwise');
    brainR(g) = mean(rho(I));
end

figure, histogram(brainR);


goi = {'PAX3','PAX6','NECAB2','EMX2'};
[goi_ind,goi_name] = geneFind(symbol,goi);
rk = tiedrank(abs(brainR))/n_gene*100;
for g = 1:length(goi)
    fprintf('%s:%.2f\n',goi{g},rk(goi_ind(g)));
end



close all
tail = prctile(abs(brainR),[0.5,99.5]);
lI = brainR < tail(1);hI = brainR >=tail(2);

sys_roi_id = 81:93;
n_sys_roi = length(sys_roi_id);
sys_roi_name = roi_name(sys_roi_id);

figure('units','normalized','outerposition',[0 0 1 1],...
    'name','roi clustering with high reliability gene across brain');

meth = 'weighted'; metric = 'correlation';

subplot(3,2,1:2)
dendrogram(linkage(roi_expr(sys_roi_id, lI),meth, metric),0,'Labels',sys_roi_name);
title(sprintf('%s-%s-%s','low R',meth,metric));

subplot(3,2,3:4)
dendrogram(linkage(roi_expr(sys_roi_id, hI),meth, metric),0,'Labels',sys_roi_name);
title(sprintf('%s-%s-%s','high R',meth,metric));

subplot(3,2,5)
imagesc(corr(roi_expr(sys_roi_id, lI)')-eye(n_sys_roi))
axis square
set(gca,'ytick',1:n_sys_roi,'yticklabel',sys_roi_name)
colorbar


subplot(3,2,6)
imagesc(corr(roi_expr(sys_roi_id, hI)')-eye(n_sys_roi))
axis square
set(gca,'ytick',1:n_sys_roi,'yticklabel',sys_roi_name)
colorbar


%% plot inter-reliability for gene of interest
for  g = 1:length(goi)
    figure('units','normalized','outerposition',[0 0 1 1],...
        'name',[goi_name{g},'-''IDR']);
    f = 0;
    for i = 1:6
        for j = i+1:6
            f = f+1;
            subplot(3,6,f)
            X = donor_roi_expr(:,i,goi_ind(g));
            Y = donor_roi_expr(:,j,goi_ind(g));
            scatter(X,Y)
            lsline
        end
    end
end
