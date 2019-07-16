function [soi_sample_idx,soi_stru_id,soi_stru_name] = ...
    ahba_sampleInstru(stru_id,stru_name,soi_name)
% [soi_sample_idx,soi_stru_id,soi_stru_name] = ...
%     ahba_sampleInstru(stru_id,stru_name,soi_name)
% Get samples located within a structure of interest
% stru_id, a n_sample x 1 vector,
% stru_name, a n_sample x 1 array
% soi_name, structure of interest: 'cb','cc','motor','somatosensory''auditory_cortex''occipital_cortex'
% 'temporal_cortex','visual_cortex','frontal_cortex','parietal_cortex','limbic_lobe'
% 'insular_cortex'

switch soi_name
    case 'cb'
        soi_sample_idx = stru_id >=4700 & stru_id < 4776;
        
    case 'cc'
        soi_sample_idx = (stru_id >= 4000 & stru_id < 4250)...
            | (stru_id >= 4800 & stru_id < 5000)...
            | (stru_id >= 4270 & stru_id < 4280) ;
        
    case 'hippocampus'
        soi_sample_idx  = stru_id >=4250 & stru_id < 4270;
        
    case 'occipital_cortex'
        soi_sample_idx = (stru_id >=4186 & stru_id <= 4218) ...
            | (stru_id >=4909 & stru_id <= 4911);
        
    case 'temporal_cortex'
        soi_sample_idx =  (stru_id >=4135 & stru_id <= 4164) ...
            | (stru_id >=4903 & stru_id <= 4908);
        
    case 'frontal_cortex'
        soi_sample_idx = (stru_id >=4022 & stru_id <= 4061) ... % supra frontal and orbital
            | (stru_id >=4079 & stru_id <= 4080) ... % frontal operculum
            | (stru_id >=4890 & stru_id <= 4902)...  % frontal pole 
            | (stru_id >=4072 & stru_id <= 4077)...  % anterior paracentral lobe
            | (stru_id >=4012 & stru_id <= 4020);    % precentral gyrus
        
    case 'parietal_cortex'
        soi_sample_idx = (stru_id >=4098 & stru_id <= 4124)... % angular gyrus and supramarginal
            |  (stru_id >=4127 & stru_id <= 4131)... % posterior paracentral lobe
            | (stru_id >=4087 & stru_id <= 4095); % postcentral gyrus
        
    case 'limbic_lobe'
        soi_sample_idx = (stru_id >=4063 & stru_id <= 4067)... % cingulate gyrus
            |(stru_id >=4223 & stru_id <= 4248) ; % parahippocampal and subcallosal cingualte gyrus
        
    case 'insular_cortex'
        soi_sample_idx = (stru_id >=4270 & stru_id <= 4274);
        
        
    case 'olfactory_cortex'
        soi_sample_idx  = stru_id >=4069 & stru_id <= 4070;
        
        
    case 'visual_cortex'
        soi_sample_idx =(stru_id >=4186 & stru_id <= 4218) ...
            | (stru_id >=4909 & stru_id <= 4911)...
            | (stru_id >=4135 & stru_id <= 4164) ...
            | (stru_id >=4903 & stru_id <= 4908);
        
    case 'motor'
        soi_sample_idx =  (stru_id >=4072 & stru_id <= 4077)... % anterior paracentral lobe
            | (stru_id >=4012 & stru_id <= 4020); % precentral gyrus
        
    case  'somatosensory'
        soi_sample_idx = (stru_id >=4127 & stru_id <= 4131)... % posterior paracentral lobe
            | (stru_id >=4087 & stru_id <= 4095); % postcentral gyrus
     
    case 'sensorimotor' 
        soi_sample_idx =  (stru_id >=4072 & stru_id <= 4077)... % anterior paracentral lobe
            | (stru_id >=4012 & stru_id <= 4020)... % precentral gyrus
            | (stru_id >=4127 & stru_id <= 4131)... % posterior paracentral lobe
            | (stru_id >=4087 & stru_id <= 4095); % postcentral gyrus
     
    case 'auditory_cortex'
        soi_sample_idx =  stru_id >=4166 & stru_id <= 4179;
        
    otherwise
        error('error structure name');
end


% get stru name and id for the soi
soi_stru_name  = unique(stru_name(soi_sample_idx));
n_stru = length(soi_stru_name);
soi_stru_id = zeros(n_stru,1);
for c = 1:n_stru
    k = find(strcmp(stru_name, soi_stru_name{c}),1);
    soi_stru_id(c) = stru_id(k);
end