function hmp = mm_readbigbrainhmp()
% hmp = mm_readbigbrainhmp()
% read bigbrain data,fill zeros profile with nan and split two hemisphre

datadir = '/nfs/e5/stanford/ABA/brainmap/bigbrain';
hmp = load(fullfile(datadir,'BigBrain_20um_163842_OldSurf_RL_Msp.mat'));
hmp = hmp.MspMatrix;

% remove vertex which has zeros hmp 
idx = any(~hmp);
hmp(:,idx) = NaN;


% split hmp into two hemisphere
hmp = reshape(hmp,100,[],2);
