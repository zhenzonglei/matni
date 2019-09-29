function mt_SegmentConnectome(dwiDir, sessid, runName, fgName, computeRoi,rmOutlier)
% mt_SegmentConnectome(dwiDir, sessid, runName, fgName)
% fgName: full name of fg including path and postfix
% foi, a vector to indicate fiber of interest
% This function will run AFQ on a % given list of subjects and runs.
if nargin < 6, rmOutlier = false; end
if nargin < 5, computeRoi = true; end
if nargin < 4, fgName = 'lmax_curv1_post_life_et_it500.mat'; end

if computeRoi
    useRoiBasedApproach = true;
else
    useRoiBasedApproach = [2,0];
end
 
anatDir = '/sni-storage/kalanit/biac2/kgs/projects/Longitudinal/Anatomy/';
[~,fgNameWoExt] = fileparts(fgName);
for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('\nConnectome segment for (%s, %s, %s)\n',sessid{s},runName{r},fgNameWoExt);
        
        runDir = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin');
        afqDir = fullfile(runDir, 'fibers','afq');
        if ~exist(afqDir, 'dir')
            mkdir(afqDir);
        end
        
        %% Load and plot whole brain fiber
        % Load ensemble connectome
        wholeBrainfgFile = fullfile(dwiDir,sessid{s},runName{r},...
            'dti96trilin','fibers',fgName);
        
        wholebrainFG = fgRead(wholeBrainfgFile);
        %% classified the fibers
        % Load the subject's dt6 file (generated from dtiInit).
        dt = dtiLoadDt6(fullfile(runDir,'dt6.mat'));
        
        % Segment the whole-brain fiber group into 20 fiber tracts
        fg_classified = AFQ_SegmentFiberGroups(dt, wholebrainFG,...
            'MNI_JHU_tracts_prob.nii.gz',useRoiBasedApproach);
        clear wholebrainFG

        fg_classified = fg2Array(fg_classified);
        
        
        %% Identify VOF and pAF
        fsROIdir = fullfile(anatDir,sessid{s},'T1','fsROI');
        [L_VOF, R_VOF, L_pAF, R_pAF, L_pAF_vot, R_pAF_vot] = AFQ_FindVOF(wholeBrainfgFile,...
            fg_classified(19),fg_classified(20),fsROIdir,afqDir,[], [],dt);
        
        fg_classified(21) = L_VOF;
        fg_classified(22) = R_VOF;
        
        % pAF
        fields = {'type','fiberNames','fiberIndex', 'coordspace'};
        L_pAF = rmfield(L_pAF,fields); fg_classified(23) = L_pAF;
        R_pAF = rmfield(R_pAF,fields); fg_classified(24) = R_pAF;
        
        % pAF_vot
        fg_classified(25) = L_pAF_vot;
        fg_classified(26) = R_pAF_vot;
        
        % merge pAF and pAFvot
        fg_classified(27) = fgUnion(L_pAF,L_pAF_vot);
        fg_classified(28) = fgUnion(R_pAF,R_pAF_vot);
        
        % save file
        fgFile = fullfile(afqDir, [fgNameWoExt, '_classified.mat']);
        S.fg = fg_classified;
        save(fgFile,'-struct','S');
        clear S;
        
        
        %% Identify and remove abherrant fibers.
        if rmOutlier
            maxDist = 4; maxLen = 4; numNodes = 30; M = 'mean'; maxIter = 1; count = true;
            for ii = 1:length(fg_classified)
                fg_clean(ii) = AFQ_removeFiberOutliers(fg_classified(ii),...
                    maxDist,maxLen,numNodes,M,count,maxIter);
            end
            clear fg_classified
            
            % save file
            pName = sprintf('_classified_clean_D%dL%dN%dI%d.mat',...
                maxDist,maxLen,numNodes,maxIter);
            fgFile = fullfile(afqDir, [fgNameWoExt, pName]);
            S.fg =  fg_clean;
            save(fgFile,'-struct','S')
        end
    end
end

