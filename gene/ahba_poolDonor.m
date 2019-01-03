function [expr,mni_coords,crs_coords,donor,symbol,stru_name,stru_id,stru_acronym] = ...
    poolDonor(dataDir,donorID,rawFile,norm)
%  [expr,coords,donor,symbol,stru_name,stru_id,stru_acronym] = ...
%   poolDonor(dataDir,donorID,rawFile,norm)

if nargin < 4, norm = true; end
if nargin < 3, rawFile = 'gene_entrez.mat'; end

expr = []; mni_coords = []; crs_coords = []; donor = [];
stru_name =[]; stru_id = []; stru_acronym = [];

for d = 1:length(donorID)
    fprintf('Merge %s:%s\n',rawFile,donorID{d});
    
    if d==1
        load(fullfile(dataDir,donorID{d},'gene',rawFile),'probe');
        symbol = probe.gene_symbol;
    end
    

    load(fullfile(dataDir,donorID{d},'gene',rawFile),'expression','sample');
       
    if norm
        expr = [expr; zscore(expression.value)];
    else
        expr = [expr; expression.value];
    end
    
    mni_coords = [mni_coords; sample.mni_xyz];
    crs_coords = [crs_coords; sample.nat_ijk];
    donor = [donor;d*ones(size(sample.mni_xyz,1),1)];
    stru_id = [stru_id; sample.stru_id];
    stru_name = [stru_name; sample.stru_name];
    stru_acronym = [stru_acronym; sample.stru_acronym];
end