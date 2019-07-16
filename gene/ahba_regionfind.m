% function ahba_regionfind()



clear
close all
addpath(genpath('/nfs/e5/stanford/codebase/matni'));
aba_dir= '/nfs/e5/stanford/ABA';
data_dir = fullfile(aba_dir,'adultbrain');
brainmap_dir = fullfile(aba_dir,'brainmap');
gene_dir = fullfile(data_dir,'gene');
data_source = 'pooled_norm_gene_entrez.mat';


%% Load full gene data: expr, symbol, donor, mni_coords. crs_coords
if ~exist('expr','var')
    gene_file = fullfile(gene_dir,data_source);
    load(gene_file);
end



% stru_id = stru_id(cc);
% stru_name = stru_name(cc);
[unique_stru_id,I] = unique(stru_id);
unique_stru_name = stru_name(I);

first_level_stru = unique_stru_name;
for s = 1:length(unique_stru_name)
    stru = unique_stru_name{s};
    idx = strfind(stru,',');
    if ~isempty(idx)
        idx = idx(1)-1;
        first_level_stru{s} = stru(1:idx);
    end
end

unique_first_level_stru = unique(first_level_stru);

ahba_stru = [];
for s = 1:length(unique_first_level_stru)
    idx = strcmp(unique_first_level_stru{s},first_level_stru);
    ahba_stru(s).name = unique_first_level_stru{s};
    ahba_stru(s).sub_name = unique_stru_name(idx);
    ahba_stru(s).sub_id = unique_stru_id(idx);
end

for s = 1:length(ahba_stru)
    fprintf('%d,%s\n',s, ahba_stru(s).name);
    for ss = 1:length(ahba_stru(s).sub_name)
        fprintf('----%d:%s\n',ahba_stru(s).sub_id(ss), ahba_stru(s).sub_name{ss}); 
    end
end


%% useful index
% cb samples from stru id
cb = stru_id >=4700 & stru_id < 4776;

% most cc: 4000-4250, cc pole:4800-5000; insular: 4270-4280 
cc = (stru_id >= 4000 & stru_id < 4250) | ... 
    (stru_id >= 4800 & stru_id < 5000) | (stru_id >= 4270 & stru_id < 4280) ; 


hippocampus  = stru_id >=4250  & stru_id < 4270;

olfactory_cortex =  stru_id >=4069  & stru_id <= 4070;

motor =  (stru_id >=4072  & stru_id <= 4077)...
    | (stru_id >=4127  & stru_id <= 4131)...
    | (stru_id >=4012  & stru_id <= 4020);

somatosensory  = (stru_id >=4072  & stru_id <= 4077)...
    | (stru_id >=4127  & stru_id <= 4131)...
    | (stru_id >=4087  & stru_id <= 4095);

auditory_cortex =  stru_id >=4166  & stru_id <= 4179;

occipital_cortex = (stru_id >=4186  & stru_id <= 4218) ...
    | (stru_id >=4909  & stru_id <= 4911);

temporal_cortex =  (stru_id >=4135  & stru_id <= 4164) ...
    | (stru_id >=4903  & stru_id <= 4908);

visual_cortex = occipital_cortex | temporal_cortex;

frontal_cortex = (stru_id >=4022  & stru_id <= 4061) ...
    | (stru_id >=4079  & stru_id <= 4080) ...
    | (stru_id >=4890  & stru_id <= 4902);


parietal_cortex = (stru_id >=4098  & stru_id <= 4124);


limbic_lobe = (stru_id >=4063  & stru_id <= 4067)...
    |(stru_id >=4223  & stru_id <= 4248) ;

insular_cortex = (stru_id >=4270  & stru_id <= 4274);

roi = insular_cortex;
unique(stru_name(roi))
nnz(roi)

area = {'cb','cc','hippocampus','motor','somatosensory','auditory_cortex',...
    'olfactory_cortex','occipital_cortex','temporal_cortex','visual_cortex',...
    'frontal_cortex','parietal_cortex', 'limbic_lobe','insular_cortex'};
for a = 1:length(area)
    roi = eval(area{a});
    fprintf('%s:%d,\n',area{a},nnz(roi))
end


