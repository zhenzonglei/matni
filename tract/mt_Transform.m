function dwiTransform(dwiDir, sessid, runName)
% dwiTransform(dwiDir, sessid, runName)
% Transform dwi nifti into canonical orientation. They're not coming off of
% NIMS properly. This function is to turn the dimension fields
% into the values that match previous data that came off of NIMS before
% the software change.

for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('Run transform for (%s,%s)\n',sessid{s},runName{r});
        runDir = fullfile(dwiDir,sessid{s},runName{r});
        k = strfind(runName{r},'_')+1;
        fName = sprintf('%s.nii.gz',runName{r}(k:end));
        dwiFile = fullfile(runDir, 'raw',fName);
        
        % read header and check if it's right
        ni = niftiRead(dwiFile, []);
        if ni.qform_code == 1 && ni.sform_code == 1 && ...
                ni.freq_dim == 1 && ni.phase_dim == 2 ...
                && ni.slice_dim == 3
            
            
            fprintf('Phase/freq is right, skip (%s,%s)\n',sessid{s}, fName);
        else
            fprintf('Phase/freq is wrong, transform (%s,%s)\n',sessid{s},fName);
            ni = niftiRead(dwiFile);
            ni.qform_code = 1;
            ni.sform_code = 1;
            ni.freq_dim   = 1;
            ni.phase_dim  = 2;
            ni.slice_dim  = 3;
            niftiWrite(ni);
        end
        
        % disp([ni.qform_code,ni.sform_code,ni.freq_dim,ni.phase_dim,ni.slice_dim]);
    end
end
