function msp = mm_readbigbrainmsp(which_data,stage)
%  msp = mm_readbigbrainmsp(data_name)
% read bigbrain data with different preprocessed methods
% data_name, 'raw','rt','gsrl', 'gsrc'
if nargin < 2, stage  = 'raw'; end
if nargin < 1, which_data = 'old';end

if strcmp(which_data,'old')    
    data_name = 'bigbrain_20um_163842_OldSurf_LR';
else
    data_name = 'bigbrain_BB_Old_G_W_LR'; 
end

% load bigbrain msp
datadir = '/nfs/e5/stanford/ABA/brainmap/bigbrain';

switch stage 
    case 'raw' % raw msp from xindi wang
        msp = load(fullfile(datadir,[data_name, '_Msp.mat']));
        desp= 'raw';msp = msp.msp;
             
    case 'rt' % msp removed ap trends
        msp = load(fullfile(datadir,[data_name, '_Msp_RT.mat']));
        desp = msp.desp;  msp = msp.msp;
        
    case 'gsrl' % msp removed ap trend and global layer signal
        msp = load(fullfile(datadir,[data_name, '_Msp_RT_GSRL.mat']));
        desp = msp.desp; msp = msp.msp;
        
    case 'gsrc' % msp removed ap trend and global column signal
        msp = load(fullfile(datadir,[data_name, '_Msp_RT_GSRC.mat']));
        desp = msp.desp;  msp = msp.msp;
        
    otherwise
        error('Wrong data name');
end

% show desp
disp(desp);

% split msp into two hemispheres
% msp = reshape(msp,100,[],2);


