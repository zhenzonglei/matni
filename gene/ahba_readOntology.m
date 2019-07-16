function [probe_id,probe_name,gene_id,gene_symbol,gene_name,entrez_id,chromosome] = ...
    ahba_readOntology(ontologFile)
% [probe_id,probe_name,gene_id,gene_symbol,gene_name,entrez_id,chromosome] = ...
% ahba_readProbes(probeFile) 
if nargin < 1; ontologFile = 'Ontology.csv'; end

fmt = '%d %q %d %q %q %d %s';
fid = fopen(ontologFile);
C = textscan(fid, fmt, 'Headerlines',1,'Delimiter',',');
fclose(fid);

probe_id = C{1};
probe_name = C{2};
gene_id = C{3};
gene_symbol= C{4};
gene_name = C{5};
entrez_id = C{6};
chromosome = C{7};



