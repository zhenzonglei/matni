function hmp = mm_readbigbrainhmp(norm_axis)
% hmp = mm_readbigbrainhmp(rm_gs)
% read bigbrain data,fill zeros profile with nan and split two hemisphre
if nargin < 1, norm_axis = 'vertical'; end

% load bigbrain hmp
datadir = '/nfs/e5/stanford/ABA/brainmap/bigbrain';
hmp = load(fullfile(datadir,'BigBrain_20um_163842_OldSurf_RL_Msp.mat'));
hmp = hmp.MspMatrix;

% replace zeros profile with nan
idx = all(hmp,1);
hmp(:,~idx) = NaN;

% normalize hmp
if strcmp(norm_axis,'vertial')
    norm_dim = 1;
elseif strcmp(norm_axis,'tangent')
    norm_dim = 2;
else
    error('Wrong norm axis: should be vertical or tangent');
end
hmp(:,idx) = zscore(hmp(:,idx),0,norm_dim);



% split hmp into two hemisphere
hmp = reshape(hmp,100,[],2);


