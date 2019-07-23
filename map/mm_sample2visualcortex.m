function idx = mm_sample2visualcortex(stru_name)
% idx = mm_sample2visualcortex(stru_name)
% map samples to visual cortex 



areas = { 'angular gyrus', 'cuneus', 'fusiform','lingual','precuneus','occipital', 'temporal'};
n_sample = length(stru_name);
area_idx = false(n_sample, length(areas));
for i = 1:length(areas)
   area_idx(:,i) = contains(stru_name,areas{i});
   fprintf('%s: %d\n',areas{i},sum(area_idx(:,i)));
end
idx = any(area_idx,2);

fprintf('%d samples in visual cortex in total.\n',sum(idx));


