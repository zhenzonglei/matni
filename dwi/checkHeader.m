function header = checkHeader(sesspar,sessid,runName)
% checkHeader(sesspar,sessid,runName)
% check and list subjects who have wrong header info

R = length(runName);    
fprintf('Check and list subjects who have wrong header info in dwi\n');
for s = 1:length(sessid)
    subjDir = fullfile(sesspar, sessid{s});
    

    % read header
    header = zeros(5,R);
    for r = 1:R
        k = strfind(runName{r},'_')+1;
        fName = sprintf('%s.nii.gz',runName{r}(k:end));
        
        ni = niftiRead(fullfile(subjDir,...
            sprintf('%s/raw/%s', runName{r},fName)),[]);
        header(1,r) = ni.qform_code;
        header(2,r) = ni.sform_code;
        header(3,r) = ni.freq_dim;
        header(4,r) = ni.phase_dim;
        header(5,r) = ni.slice_dim;
    end
    
    % compare header
    match = diff(header,1,2);
    if any(match(:))
        fprintf('%s\n', sessid{s});
    end
end



