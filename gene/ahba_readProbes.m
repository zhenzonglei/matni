function probe = ahba_readProbes(probeFile)
% probe = readProbes(probeFile) 
% probeFile = 'Probes.csv';

fmt = '%d %q %d %q %q %d %s';
fid = fopen(probeFile);
C = textscan(fid, fmt, 'Headerlines',1,'Delimiter',',');
fclose(fid);

probe.id = C{1}';
probe.name = C{2}';
probe.gene_id = C{3}';
probe.gene_symbol= C{4}';
probe.gene_name = C{5}';
probe.entrez_id = C{6}';
probe.chromosome = C{7}';


clear C