function ahba_cleanProbe(dataDir,sessid,rawFile,badProbe)
% ahba_cleanNonEntrezProbe(dataDir,sessid,rawFile,targ)
% Extract the probes which are in entrez
% dataDir, Dir for session
% sessid, donor Id
% rawFile, raw ABA data file
% badProbe: na, na+nonentrez, nonentrez+nocall

if nargin < 4, badProbe = 'na+nonentrez'; end
if nargin < 3, rawFile='raw.mat'; end

% only the genes with entrez id and correct symbol are kept.
gene = load(fullfile(dataDir,sessid{1},'gene',rawFile));
na  = strcmp(gene.probe.gene_symbol,'na');

switch badProbe
    case 'na'
        idx = ~na;
        fout = 'raw_all.mat';
        
    case 'na+nonentrez'
        idx = gene.probe.entrez_id~=0; idx(na) = false;
        fout = 'raw_entrez.mat';
        
    case 'na+nonentrez+noncall'
        idx = gene.probe.entrez_id~=0; idx(na) = false;
        
        call_idx = false(length(sessid),length(gene.probe.entrez_id)) ;
        for s = 1:length(sessid)
            load(fullfile(dataDir,sessid{s},'gene',rawFile),'call');
            call_idx(s,:) = any(call.value,1);
        end
        idx = all(call_idx,1) & idx; 
        
        fout = 'raw_entrez_call.mat';
        
    otherwise
        error('Wrong bad probe');
end

clear gene call;


for s = 1:length(sessid)
    donor = sessid{s};
    load(fullfile(dataDir,donor,'gene',rawFile));
    fprintf('Clean %s for %s(sample,probe):(%d,%d)->', ...
        badProbe, donor,size(expression.value));

    % call
    call.probe_id = call.probe_id(idx);
    call.value = call.value(:,idx);

    % expre
    expression.probe_id = expression.probe_id(idx);
    expression.value = expression.value(:,idx);
   
    % probe
    probe.id = probe.id(idx);
    probe.name = probe.name(idx);
    probe.gene_id = probe.gene_id(idx);
    probe.gene_symbol = probe.gene_symbol(idx);
    probe.gene_name = probe.gene_name(idx);
    probe.entrez_id = probe.entrez_id(idx);
    probe.chromosome = probe.chromosome(idx);
    
    % save raw entrez file
    outFile = fullfile(dataDir,sessid{s},'gene',fout);
    save(outFile,'donor','sample', 'call','expression', 'probe')
    fprintf('(%d,%d)\n', size(expression.value));
end