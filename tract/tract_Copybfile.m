function dwiCopybfile(dwiDir,sessid)
% dwiCopybfile(dwiDir,sessid), copy bfile from cwd to each subject dir

bDir = '~/analysis/bfile';
run = {'run1','run2','concat'};

fprintf('Copy b file for subejcts\n');
for s = 1:length(sessid)
    subjDir = fullfile(dwiDir, sessid{s});
    
    for r = 1:length(run)
        % copy bval files
        src_bval = fullfile(bDir, sprintf('%s.bval',run{r}));
        targ_bval = fullfile(subjDir, ...
            sprintf('96dir_%s/raw/%s.bval',run{r},run{r}));
        
        bval_match = dlmread(src_bval)==dlmread(targ_bval);
        if ~all(bval_match(:))
            fprintf('%s-%s:bval\n',sessid{s}, run{r});
            tmp_targ_bval = fullfile(subjDir, ...
                sprintf('96dir_%s/raw/%s_tmp.bval',run{r},run{r}));
            copyfile(src_bval, tmp_targ_bval);
            movefile(tmp_targ_bval, targ_bval);
        end
        
        
        % copy bvec files
        src_bvec = fullfile(bDir, sprintf('%s.bvec',run{r}));
        targ_bvec = fullfile(subjDir, ...
            sprintf('96dir_%s/raw/%s.bvec',run{r},run{r}));
        bvec_match = dlmread(src_bvec)==dlmread(targ_bvec);
        if ~all(bvec_match(:))
            fprintf('%s-%s:bvec\n',sessid{s}, run{r})
            
            
            tmp_targ_bvec = fullfile(subjDir, ...
                sprintf('96dir_%s/raw/%s_tmp.bvec',run{r},run{r}));
            copyfile(src_bvec,tmp_targ_bvec)
            movefile(tmp_targ_bvec, targ_bvec);
        end
        
    end
    
end