%%%% to find the smilar fiber, just measure the Euler distance of their
%%%% coordinates is not enough.
%%%% we need to compare their shape, its not a easy job

%%% script to run the pipeline %%%%
clear
clc
% specifiy analysis dir
analysisDir = '~/analysis';
cd(analysisDir)


% Specifiy the steps which will to be run
% 'dwiPreprocess',
% 'dwiMakeWMmask'
% 'dwiRunET',
% 'dwiRunLife';
stepName = {'dwiRunLife'};

% Specifiy the sesspar and sessid files
sessparFile = './doc/sessfile/sesspar';
sessidFile = './doc/sessfile/adultsessid';
runName = {'96dir_run1'}; % '96dir_run2'} % '96dir_concat'};

% read parent dir and subject id info
[sesspar, sessid] = readSess(sessparFile,sessidFile);
sessid = {'JG24'};
s=1
r=1
% fgNames = {
% 'run1_aligned_trilin_csd_lmax8_run1_aligned_trilin_brainmask_run1_aligned_trilin_wm_prob-curv0.25-cutoff0.1-200000.pdb',
% 'run1_aligned_trilin_csd_lmax8_run1_aligned_trilin_brainmask_run1_aligned_trilin_wm_prob-curv0.5-cutoff0.1-200000.pdb',
% 'run1_aligned_trilin_csd_lmax8_run1_aligned_trilin_brainmask_run1_aligned_trilin_wm_prob-curv1.01-cutoff0.1-200000.pdb',
% 'run1_aligned_trilin_csd_lmax8_run1_aligned_trilin_brainmask_run1_aligned_trilin_wm_prob-curv2.01-cutoff0.1-200000.pdb',
% 'run1_aligned_trilin_csd_lmax8_run1_aligned_trilin_brainmask_run1_aligned_trilin_wm_prob-curv4.01-cutoff0.1-200000.pdb',
% };
% fgName = 'run1_aligned_trilin_csd_lmax8_run1_aligned_trilin_brainmask_run1_aligned_trilin_wm_prob-curv1.01-cutoff0.1-200000.pdb';

dwiDir = sesspar{1};
fgName = 'ETconnectome_candidate.mat';

fgFile = fullfile(dwiDir,sessid{s},runName{r},...
    'dti96trilin','fibers',fgName);

fg = fgRead(fgFile);

% could use image space or acpc space
i = strfind(runName{r},'_')+1;
dwiFile = fullfile(dwiDir,sessid{s},runName{r},...
                sprintf('%s_aligned_trilin.nii.gz',runName{r}(i:end)));
            
dwiNi = niftiRead(dwiFile,[]);
fg = dtiXformFiberCoords(fg,dwiNi.qto_ijk,'img');

nfiber = fgGet(fg,'nfibers');


% fc = zeros(nfiber,2*3);
% for f =1:nfiber
%     fc(f,1:3) = fg.fibers{f}(:,1);
%     fc(f,4:6) = fg.fibers{f}(:,end);
% end

fiberLen = fgGet(fg,'nodesperfiber');

uniqueLen = unique(fiberLen);

fiberKeep = false(nfiber,1);
for i = 1:length(uniqueLen)
    % index for fiber with unique length 
    iUL = find(fiberLen == uniqueLen(i));
    
    fgSameLen = fg.fibers(iUL);

    % collpase 3d coords(x,y,z) from one fiber into a column matrix
    % (3xnodes)*nfiber
    fgSameLen = reshape(horzcat(fgSameLen{:}),prod(size(fgSameLen{1})),[]);
    
    
    % index for unique fibers which have the same length
    [~,iUF,ic]= unique(fgSameLen','rows');
    
    iUF = iUL(iUF);
    fiberKeep(iUF) = true;
end

sum(fiberKeep)












