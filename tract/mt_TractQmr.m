function  dwiTractQmr(dwiDir, sessid, runName, fgName, qmrDir)
% dwiTractQmri(dwiDir, sessid, runName, fgName)
% fgName: Name of fg file

for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('Compute tract Qmr for (%s,%s,%s)\n',sessid{s},runName{r},fgName);
        runDir = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin');
        afqDir = fullfile(runDir, 'fibers','afq');
        numNodes = 100; clip2rois = 0;
        % Load fg array
        fgFile = fullfile(afqDir, fgName);
        if exist(fgFile,'file')
            load(fgFile,'roifg');
            % Read the t1 file
            t1File = fullfile(qmrDir,sessid{s},'mrQ_aligned/OutPutFiles_1/BrainMaps','T1_map_lsq.nii.gz');
            t1 = niftiRead(t1File);
            % Check t1 header
            if ~all(t1.qto_xyz(:) == t1.sto_xyz(:))
                t1 = niftiCheckQto(t1);
            end
            % Compute a Tract t1
            T1 = AFQ_ComputeTractProperties(roifg, t1, numNodes, clip2rois, runDir);
            
            % Read the tv file
            tvFile = fullfile(qmrDir,sessid{s},'mrQ_aligned/OutPutFiles_1/BrainMaps','TV_map.nii.gz');
            tv = niftiRead(tvFile);
            % Check tv header
            if ~all(tv.qto_xyz(:) == tv.sto_xyz(:))
                tv = niftiCheckQto(tv);
            end
            % Compute a Tract tv
            TV = AFQ_ComputeTractProperties(roifg, tv, numNodes, clip2rois, runDir);
            
            % save tract Qmr
            tractFile = fullfile(afqDir, ['TractQmr','_', fgName]);
            save(tractFile,'T1','TV');
        end
    end
end
            