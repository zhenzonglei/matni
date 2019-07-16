function ahba_packGeneData2Mat(dataDir, sessid)
%  ahba_packGeneData2Mat(dataDir,sessid)

for s = 1:length(sessid)
    donor = sessid{s};
    fprintf('Pack gene data for %s\n', donor);
    
    annotFile = fullfile(dataDir,donor,'gene','SampleAnnot.csv');
    sample = ahba_readSampleAnnot(annotFile);
    
    callFile = fullfile(dataDir,sessid{s},'gene','PACall.csv');
    call = ahba_readPACall(callFile);
    
    expressionFile = fullfile(dataDir, sessid{s},'gene','MicroarrayExpression.csv');
    expression = ahba_readGeneExpression(expressionFile);
    
    
    
    probeFile = fullfile(dataDir, sessid{s},'gene','Probes.csv');
    probe = ahba_readProbes(probeFile);
    
    outFile = fullfile(dataDir,sessid{s},'gene','raw.mat');
    save(outFile,'donor','sample', 'call','expression', 'probe')
    
    fprintf('Pack gene done for %s(sample,probe):(%d,%d)\n', donor,size(expression.value));
end