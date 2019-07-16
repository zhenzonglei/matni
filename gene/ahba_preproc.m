% preprocess ahba data from all donors
clear; close all

addpath(genpath('/nfs/e5/stanford/codebase/matni'));
aba_dir= '/nfs/e5/stanford/ABA';
data_dir = fullfile(aba_dir,'adultbrain');
gene_dir = fullfile(data_dir,'gene');

donors_id = {'H0351.1009', 'H0351.1012', 'H0351.1015', ...
    'H0351.1016','H0351.2001','H0351.2002'};
n_donor = length(donors_id);

for d = 1:n_donor
    % pack all csv from each donor into a mat file
    ahba_packGeneData2Mat(data_dir, donors_id(d))
    
    % clean na and non-entrez probe
    ahba_cleanProbe(data_dir, donors_id(d))
    
    
    % merge(averge) probes from a gene
    ahba_mergeEntrezProbe(data_dir, donors_id(d))
end

% pool data from all donor into a mat 
geneFile = 'gene_entrez.mat';
[expr,mni_coords,crs_coords,donor,symbol,stru_name,stru_id,stru_acronym] = ...
    ahba_poolDonor(data_dir,donors_id(1:6),geneFile);

if norm
    save(fullfile(projDir,'data',['pooled_norm_',geneFile]));
else
    save(fullfile(projDir,'data',['pooled_',geneFile]));
end