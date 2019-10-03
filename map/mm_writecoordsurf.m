function mm_writecoordsurf(gii_fout,gii_fin,sample_coords, sample_data,...
    dist_thr,interp)
%  mm_writecoordsurf(gii_fout,gii_fin,sample_coords, sample_data,...
%     dist_thr,interp)
% gii_fout, filename for output gii file
% dist_thr, project dist threshold
% sample_data, N sample * M features
% interp, nn, nm, nw

if nargin < 6, interp  = 'nm';end
if nargin < 5, dist_thr = 5; end
if nargin < 4, sample_data = [];end

% load gii surface 
gii_surf = gifti(gii_fin);
sdim = size(gii_surf.vertices,1);
tdim = size(sample_data,1);

% project sammple data to surface
[surf_data,surf_idx] = mm_sample2surf(gii_surf,sample_coords, sample_data,...
    dist_thr,interp);


% write the surface data into gii shape format
data = zeros(sdim,tdim);
data(surf_idx,:) = surf_data; 
save(gifti(data),gii_fout,'Base64Binary');
