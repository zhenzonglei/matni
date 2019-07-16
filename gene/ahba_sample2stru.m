function [sample_stru_idx,stru_name, stru_id] = ...
    ahba_sample2stru(sample_stru_id,sample_stru_name,is_merge_hemi)
% [sample_stru_idx,stru_name, stru_id] = ...
%    ahba_sample2stru(sample_stru_id,sample_stru_name,is_merge_hemi)
    
    
if nargin < 3, is_merge_hemi = true; end


% get stru name 
[stru_name,iu] = unique(sample_stru_name);

% set stru id
stru_id = sample_stru_id(iu);

% Relabel samples from right hemisphere as left hemisphere
if is_merge_hemi
    rh_stru = contains(stru_name,'right');
    rh_stru_name = stru_name(rh_stru);
    rh_stru_id = stru_id(rh_stru);
    
    for i = 1:length(rh_stru_name)
        k = strcmp(stru_name,replace(rh_stru_name{i},'right','left'));
        if any(k)
            idx = sample_stru_id == rh_stru_id(i);
            sample_stru_id(idx) = stru_id(k);         
            sample_stru_name(idx) = replace(sample_stru_name(idx),'right','left');
        end
    end
end


% reset stru id and stru name
n_sample = length(sample_stru_id);
[stru_name,iu] = unique(sample_stru_name);
stru_id = sample_stru_id(iu);
n_stru = length(stru_id);
fprintf('There are %d structure\n',n_stru);

% make idx for each structure
sample_stru_idx = false(n_sample,n_stru);
for s = 1:n_stru
    sample_stru_idx(:,s) = sample_stru_id == stru_id(s);
end


