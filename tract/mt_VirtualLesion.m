function se = dwiVirtualLesion(dwiDir, sessid, runName, feName, fgName, foi)
% Do virtual lesion analysis
% As it will take a long time to load fe, I'll calculate se for multiple targFg
% after loading fe,

for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('Run virtual lesion for (%s, %s)\n',sessid{s},runName{r});
        fiberDir = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin','fibers');
        
        % Load fe
        feFile = fullfile(fiberDir,feName);
        load(feFile);
        [~,fename] = fileparts(fe.name);
        % Get non-zero fiber index
        ind_nzw = feGet(fe,'ind nzw');
        
        % Get fg from fe
        fullFg  = feGet(fe,'fg acpc');
        fullFg.fibers= fullFg.fibers(ind_nzw);
        
        % Load targFg
        targFgFile = fullfile(fiberDir, 'afq', fgName);
        targFg = load(targFgFile);
        targFg = targFg.fg;
        targFg = targFg(foi);
        
        for g = 1:length(targFg)
            % Find indices of tract-fascicles in the encoded connectome (Phi tensor).
            ind_full = fgIntersect(fullFg,targFg(g));
            
            % Compute the root-mean-squared error of the model with and without tract
            % in the white-matter voxels comprised by the tract.
            [rmse_wVL, rmse_woVL]= feComputeVirtualLesion_norm(fe,ind_nzw(ind_full));
            
            % Compute the statistical strenght of evidence for the tract.
            se = feComputeEvidence_norm(rmse_woVL,rmse_wVL);
            
            fh = distributionPlotStrengthOfEvidence(se);

            [~,fgname] = fileparts(targFg(g).name);
            seFile = fullfile(fiberDir, 'afq',['se_',fename,'_',fgname,'.mat']);
            save(seFile,'se')
        end
    end
end