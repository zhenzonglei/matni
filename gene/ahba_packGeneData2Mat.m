function packGeneData2Mat(dataDir, sessid)
%  packGeneData2Mat(dataDir,sessid)

for s = 1:length(sessid)
    donor = sessid{s};
    fprintf('Pack gene data for %s\n', donor);
    
    annotFile = fullfile(dataDir,donor,'gene','SampleAnnot.csv');
    sample = readSampleAnnot(annotFile);
    
    callFile = fullfile(dataDir,sessid{s},'gene','PACall.csv');
    call = readPACall(callFile);
    
    expressionFile = fullfile(dataDir, sessid{s},'gene','MicroarrayExpression.csv');
    expression = readGeneExpression(expressionFile);
    
    
    
    probeFile = fullfile(dataDir, sessid{s},'gene','Probes.csv');
    probe = readProbes(probeFile);
    
    outFile = fullfile(dataDir,sessid{s},'gene','raw.mat');
    save(outFile,'donor','sample', 'call','expression', 'probe')
    
    fprintf('Pack gene done for %s(sample,probe):(%d,%d)\n', donor,size(expression.value));
end