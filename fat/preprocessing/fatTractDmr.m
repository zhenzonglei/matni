function fatTractDmr(fatDir, sessid, runName, fgName)
% fatTractProperties(fatDir, sessid, runName, fgName)
% fgName: Name of fg file


        fprintf('Compute tract properties for (%s,%s,%s)\n',sessid,runName,fgName);
        runDir = fullfile(fatDir,sessid,runName,'dti96trilin');
        afqDir = fullfile(runDir, 'fibers','afq');
        
        % Load fg array
        fgFile = fullfile(afqDir, fgName);
        if exist(fgFile,'file')
            load(fgFile,'roifg');
            % Load dt6 file
            dt = dtiLoadDt6(fullfile(runDir,'dt6.mat'));
            
            %%  Compute tract properties (FA, MD, RD, AD, etc.)
            numNodes = 100; clip2rois = 0;
            [fa,md,rd,ad,cl,volume,profile] = AFQ_ComputeTractProperties(roifg, dt, numNodes, clip2rois);
            tractFile = fullfile(afqDir, ['TractDmr','_', fgName]);
            save(tractFile,'fa','md','rd','ad','cl','volume','profile');
        end
            
end
