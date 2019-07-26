function mm_bigbrain_msp_preproc()
% mm_bigbrain_msp_preproc()
% preprocess bigbrain msp data, including
% fill zeros profile with nan 
% remove anterior to posterior trend in slicing,rt
% global layer signal regression,gsrl 
% global column signal regression,gsrc 

%% load bigbrain msp
datadir = '/nfs/e5/stanford/ABA/brainmap/bigbrain';
msp = load(fullfile(datadir,'bigbrain_20um_163842_OldSurf_RL_Msp.mat'));
msp = msp.MspMatrix;

%% replace zeros profile with nan
idx = all(msp,1); msp(:,~idx) = NaN;


%% remove anterior-posterior trend
rh_surf_coords = load(fullfile(datadir,'bigbrain_L1_L4_W_R_SurfCoord.mat'));
lh_surf_coords = load(fullfile(datadir,'bigbrain_L1_L4_W_L_SurfCoord.mat'));
ap_coords = [rh_surf_coords.R_SurfCoord(:,:,2),lh_surf_coords.L_SurfCoord(:,:,2)];

% remove ap trend and get resid
y = msp(:,idx);X = ap_coords(:,idx);
[~,~,resid] = regress(y(:),X(:));resid = reshape(resid,100,[]);

% save trend removed msp
msp(:,idx) = resid; desp = 'Remove ap trend(RT)';
save(fullfile(datadir,'bigbrain_20um_163842_OldSurf_RL_Msp_RT.mat'),...
    'msp', 'desp');

%% global layer signal regression(GSRL)
% Here, we care about layer differences. We cannot normal with each layer 
% beacuse it will remove layer difference. So we normal within a column to 
% keep the layer difference
msp_gsrl = zscore(resid,0,1);

% global mean of all layers
X = mean(msp_gsrl)';

% remove global mean of layer
for i = 1:size(msp_gsrl,1)
    y = msp_gsrl(i,:)';
    [~,~,r] = regress(y,X);
    msp_gsrl(i,:) = r;
end

% save trend removed and global layer regressed msp
msp(:,idx) = msp_gsrl; desp = 'Remove ap trend(RT)+ global layer signal regression(GSRL)';
save(fullfile(datadir,'bigbrain_20um_163842_OldSurf_RL_Msp_RT_GSRL.mat'),...
    'msp', 'desp');


%% global column signal regression(GSRC)
% Here, we care about column differences. We cannot normal with each column 
% beacuse it will remove column difference. So we normal within a layer to 
% keep the column difference
msp_gsrc = zscore(resid,0,2);

% global mean of all columns
X = mean(msp_gsrc,2);

% remove global mean
for i = 1:size(msp_gsrc,2)
    y = msp_gsrc(:,i); 
    [~,~,r] = regress(y,X);
    msp_gsrc(:,i) = r;
end

% save trend removed and global layer regressed msp
msp(:,idx) = msp_gsrc; desp = 'Remove ap trend(RT)+ global column signal regression(GSRC)';
save(fullfile(datadir,'bigbrain_20um_163842_OldSurf_RL_Msp_RT_GSRC.mat'),...
    'msp', 'desp');



