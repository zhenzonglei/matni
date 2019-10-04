function mm_writegii(gii_surf,surf_data, surf_idx,fout)
% mm_writegii(fout,gii_surf,data, idx)
% fout, filename for output gii file
% surf_data, N sample * M features
% surf_idx, index of vertics


% assemle the data into gifti data 
n_vtx = size(gii_surf.vertices,1);
n_feat = size(surf_data,2);

data = zeros(n_vtx,n_feat);
data(surf_idx,:) = surf_data; 


% write the surface data into gii shape format
save(gifti(data),fout,'Base64Binary');
