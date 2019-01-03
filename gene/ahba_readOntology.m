function [probe_id,probe_name,gene_id,gene_symbol,gene_name,entrez_id,chromosome] = readOntology(ontologFile)
% [probe_id,probe_name,gene_id,gene_symbol,gene_name,entrez_id,chromosome] = readProbes(probeFile) 

ontologFile = 'Ontology.csv';

fmt = '%d %q %d %q %q %d %s';
fid = fopen(probeFile);
C = textscan(fid, fmt, 'Headerlines',1,'Delimiter',',');
fclose(fid);

probe_id = C{1};
probe_name = C{2};
gene_id = C{3};
gene_symbol= C{4};
gene_name = C{5};
entrez_id = C{6};
chromosome = C{7};



