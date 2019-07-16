function ahba_concateDonorData(dataDir, sessid, geneFile, norm) 
% ahba_concateDonorData(dataDir, sessid, geneFile, norm)  
% pool data from all donors 

if nargin < 4, norm = true; end
if nargin < 3, geneFile = 'gene_entrez.mat'; end


[expr,mni_coords,crs_coords,donor,symbol,stru_name,stru_id,stru_acronym] = ...
    ahba_poolDonor(dataDir,sessid,geneFile,norm);

if norm
    save(fullfile(dataDir,'data',['pooled_norm_',geneFile]));
else
    save(fullfile(dataDir,'data',['pooled_',geneFile]));
end
