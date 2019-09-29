function mm_bigbrain_msp_preproc(which_data)
% mm_bigbrain_msp_preproc()
% preprocess bigbrain msp data, including
% remove anterior to posterior trend in slicing,rt
% global layer signal regression,gsrl 
% global column signal regression,gsrc 

if nargin < 1, which_data = 'old'; end

%% load bigbrain msp
if strcmp(which_data,'old')    
    data_name = 'bigbrain_20um_163842_OldSurf_LR';
else
    data_name = 'bigbrain_BB_Old_G_W_LR'; 
end

datadir = '/nfs/e5/stanford/ABA/brainmap/bigbrain';
msp = load(fullfile(datadir,[data_name, '_Msp.mat']));

msp = msp.msp;

%% remove anterior-posterior trend
hemi = {'L','R'};
surf_coords = load(fullfile(datadir,[data_name, '_coords.mat']));

for h = 1:length(hemi)
    % y for regress
    y = msp(:,:,h);

    % X for regress
    X = surf_coords.coords(:,:,2,h);
    
    % remove ap trend and get resid   
    idx = ~isnan(y(:));
    [~,~,resid] = regress(y(idx),X(idx));
    y(idx) = resid;  msp(:,:,h) = y;
end

msp_rt = msp;

% save trend removed msp
desp = 'Remove ap trend(RT)';
save(fullfile(datadir,[data_name, '_Msp_RT.mat']),'msp', 'desp');

%% global layer signal regression(GSRL)
% normal layer
msp_gsrl = mc_nanzscore(msp_rt,0,2);

for h = 1:length(hemi)
    % global mean of all layers
    X = nanmean(msp_gsrl(:,:,h),1)';
    
    % remove global mean of layer
    for i = 1:size(msp_gsrl,1)
        y = msp_gsrl(i,:,h)';
        [~,~,r] = regress(y,X);
        msp(i,:,h) = r;
    end
end
% save trend removed and global layer regressed msp
desp = 'Remove ap trend(RT) + global layer signal regression(GSRL)';
save(fullfile(datadir,[data_name, '_Msp_RT_GSRL.mat']),'msp', 'desp');


%% global column signal regression(GSRC)
% normalize column
msp_gsrc = mc_nanzscore(msp_rt,0,1);

for h = 1:length(hemi)    
    % global mean of all columns
    X = nanmean(msp_gsrc(:,:,h),2);
    
    nn = sum(isnan(msp_gsrc(:,:,h))) > 10;
    
    % remove global mean
    for i = 1:size(msp_gsrc,2)
        if nn(i)
            msp(:,i,h) = NaN;
        else
            y = msp_gsrc(:,i,h); 
            [~,~,r] = regress(y,X); 
            msp(:,i,h) = r;
        end
    end
end
% save trend removed and global layer regressed msp
desp = 'Remove ap trend(RT)+ global column signal regression(GSRC)';
save(fullfile(datadir,[data_name, '_Msp_RT_GSRC.mat']),'msp', 'desp');



