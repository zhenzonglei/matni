function ahba_regionfind()
clear; close all
projDir = '/nfs/e5/stanford/ABA';
addpath(fullfile(projDir,'analysis','code'));
dataDir = fullfile(projDir,'data');


%% Prepare data
geneFile = 'pooled_norm_5donor_gene_entrez.mat';
load(fullfile(projDir,'data',geneFile))
[n_sample,n_gene] = size(expr);
soi = unique(stru_name); n_soi = length(soi);
soi_idx = false(n_sample, length(soi));

for i = 1:length(soi)
    soi_idx(strcmp(stru_name,soi{i}),i) = true;
    fprintf('%d-%s:%d\n',stru_id(I(i)),soi{i},nnz(soi_idx(:,i)));
end

soi_id = stru_id(I);


% fid = fopen(fullfile(dataDir,'aba_stru.xls'),'w+');
% for i = 1:length(soi)
% fprintf(fid,'%d\t%s\n',soi_id(i),soi{i});
% end
% fclose(fid);

cortex = stru_id >= 4012 &  stru_id <= 4248;
insular = stru_id >= 4270 &  stru_id <= 4274;
pole = stru_id >= 4890 & stru_id <= 4911;

stru_roi_idx = cortex | insular | pole;
stru_roi_name = stru_name(stru_roi_idx);
