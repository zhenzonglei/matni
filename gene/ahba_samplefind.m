function ahba_samplefind(stru_name, roi)



roi = {'I','II','III','IV','V','VI','VII','VIII','IX','XX'};

idx = contains(stru_name,roi);
nnz(idx)

unique(stru_name(idx))


cc  = mni_coords(idx,:);

figure
scatter3(cc(:,1),cc(:,2),cc(:,3))
hold on
scatter3(mni_coords(~idx,1),mni_coords(~idx,2),mni_coords(~idx,3))





idx = find(contains(stru_name,roi,'IgnoreCase',true), 1);

