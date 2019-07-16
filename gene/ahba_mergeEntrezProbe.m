function ahba_mergeEntrezProbe(dataDir,sessid,raw_entrez_file)
% Extract the genes which are in entrez
% dataDir, Dir for session
% sessid, donor id
% raw_entrez_file, file name for entrez gene
% if nargin < 4, meth = 'avg'; end
if nargin < 3, raw_entrez_file ='raw_entrez.mat'; end

switch raw_entrez_file
    case 'raw_entrez.mat'
        fout = 'gene_entrez.mat';
    case 'raw_entrez_call.mat'
        fout = 'gene_entrez_call.mat';  
    otherwise
        error('Wrong entrez file');
end



for s = 1:length(sessid)
    donor = sessid{s};
    if s==1
        % only the genes with entrez id and correct symbol are kept.
        load(fullfile(dataDir,donor,'gene',raw_entrez_file),'probe');
        [gene_symbol,idx] = unique(probe.gene_symbol);
        
        nGene = length(gene_symbol);
        gene_idx = false(nGene,length(probe.gene_symbol));
        for g = 1:nGene
            gene_idx(g,:) = strcmp(probe.gene_symbol,gene_symbol{g});
        end
        
        % update probe info for unique genes
        probe.id  = probe.id(idx);
        probe.name = probe.name(idx);
        probe.gene_id = probe.gene_id(idx);
        probe.gene_symbol =  probe.gene_symbol(idx);
        probe.gene_name = probe.gene_name(idx);
        probe.entrez_id = probe.entrez_id(idx);
        probe.chromosome = probe.chromosome(idx);
    end
    
    load(fullfile(dataDir,donor,'gene',raw_entrez_file),'call','sample','expression');
    [nSample,nProbe] = size(expression.value);
    fprintf('Merge Entrez Probes for %s(sample,probe):(%d,%d)',donor,nSample,nProbe);
    
    call_value = zeros(nSample,nGene);
    expr_value = zeros(nSample,nGene);
    for g = 1:nGene
        I = gene_idx(g,:);
        call_value(:,g) = mean(call.value(:,I),2);
        expr_value(:,g) = mean(expression.value(:,I),2);
    end
    
    % call
    call.probe_id = call.probe_id(idx);
    call.value = call_value;
    
    % expression
    expression.probe_id = expression.probe_id(idx);
    expression.value = expr_value;
    
    % save gene entrez file
    outFile = fullfile(dataDir,sessid{s},'gene',fout);
    save(outFile,'donor','sample','call','expression', 'probe')
    fprintf('-> (%d,%d)\n',size(expression.value));    
end