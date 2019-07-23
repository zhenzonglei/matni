function hmp = mm_readbigbrainhmp(norm_axis)
% hmp = mm_readbigbrainhmp(norm_axis)
% read bigbrain data,fill zeros profile with nan and split two hemisphre
% norm_axis, 'none','vertical' or 'tangent'

if nargin < 1, norm_axis = 'none'; end

% load bigbrain hmp
datadir = '/nfs/e5/stanford/ABA/brainmap/bigbrain';
hmp = load(fullfile(datadir,'bigbrain_20um_163842_OldSurf_RL_Msp.mat'));
hmp = hmp.MspMatrix;

% replace zeros profile with nan
idx = all(hmp,1);hmp(:,~idx) = NaN;

% normalize hmp
if strcmp(norm_axis,'vertical')
    % normal within a column
    hmp_resid = zscore(hmp(:,idx),0,1);
    
    % global mean of all columns
    X = mean(hmp_resid,2);
    
    % remove global mean
    for i = 1:size(hmp_resid,2)
        y = hmp_resid(:,i);
        b = regress(y,X);
        hmp_resid(:,i) = y - X*b;
    end
    
elseif strcmp(norm_axis,'tangent')
    % normal within a layer
    hmp_resid = zscore(hmp(:,idx),0,2);
    
    % global mean of all layer
    X = mean(hmp_resid)';
    
    % remove global mean
    for i = 1:size(hmp_resid,1)
        y = hmp_resid(i,:)';
        b = regress(y,X);
        hmp_resid(i,:) = y - X*b;
    end

elseif strcmp(norm_axis,'none')
    % do not normalize
    hmp_resid =  hmp(:,idx);
    
else
    error('norm_axis is a string: none, vertical, tangent');
    
end

% save back to hmp
hmp(:,idx) = hmp_resid;


% % split hmp into two hemisphere
% hmp = reshape(hmp,100,[],2);


