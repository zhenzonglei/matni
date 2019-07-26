function msp = mm_readbigbrainmsp(data_name)
%  msp = mm_readbigbrainmsp(data_name)
% read bigbrain data with different preprocessed methods
% data_name, 'raw','rt','gsrl', 'gsrc'
if nargin < 1, data_name  = 'rt'; end

% load bigbrain msp
datadir = '/nfs/e5/stanford/ABA/brainmap/bigbrain';

switch data_name
    case 'raw' % raw msp from xindi wang
        msp = load(fullfile(datadir,'bigbrain_20um_163842_OldSurf_RL_Msp.mat'));
        msp = msp.MspMatrix;
        
    case 'rt' % msp removed ap trends
        msp = load(fullfile(datadir,'bigbrain_20um_163842_OldSurf_RL_Msp_RT.mat'));
        msp = msp.msp;
        
    case 'gsrl' % msp removed ap trend and global layer signal
        msp = load(fullfile(datadir,'bigbrain_20um_163842_OldSurf_RL_Msp_RT_GSRL.mat'));
        msp = msp.msp;
        
    case 'gsrc' % msp removed ap trend and global column signal
        msp = load(fullfile(datadir,'bigbrain_20um_163842_OldSurf_RL_Msp_RT_GSRC.mat'));
        msp = msp.msp;
        
    otherwise
        error('Wrong data name');
end


% split msp into two hemispheres
msp = reshape(msp,100,[],2);


