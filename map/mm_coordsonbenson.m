function [sample_on_surf,label_id,label_name] = mm_coordsonbenson(sample_coords, dist_thr)
% [sample_on_surf,label_id,label_name] = mm_coordsonbenson(sample_coords, dist_thr)
% sample_on_surf, N samples x M label logical index matrix

if nargin < 2, dist_thr = 5; end



% Left hemi
[sample_on_lh,label_id,label_name] = ...
    mm_coordsonsurfatlas(sample_coords,'benson','lh',dist_thr);

% Right hemi
sample_on_rh = mm_coordsonsurfatlas(sample_coords,'benson','lh',dist_thr);


sample_on_surf = sample_on_lh | sample_on_rh;



% plot sample number
figure('units','normalized','outerposition',[0 0 1 1],'name','Sample number in benson roi');
label_sample_num = sum(sample_on_surf);
bar(label_sample_num);
ylabel('Sample number in roi');
set(gca,'xtick',1:length(label_name), 'xticklabel',label_name,'xticklabelrotation',90);
box off
fprintf('%d samples on surface in total\n',sum(label_sample_num));
