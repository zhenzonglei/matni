function surf_expr = mm_sample2surf(gii_surf,sample_coords, sample_expr,dist_thr,interp)
% surf_expr = mm_sample2surf(gii_surf,sample_coords, sample_expr,dist_thr,interp)
% ineterp, nn, mean, linear
if nargin < 5, interp  = 'nm';end
if nargin < 4, dist_thr = 2; end


surf_coords = double(gii_surf.vertices);
%  surf_faces = gii.faces;


n_vtx = length(vertex_coords);
n_gene = size(sample_expr,2);


D = pdist2(sample_coords,surf_coords);
sI = D < dist_thr;
vI  = find(any(sI));
surf_expr = zeros(n_vtx,n_gene);

switch interp
    case 'nn'
        [Y,I] = min(D);
        surf_expr(Y < dist_thr,:) = sample_expr(I(Y < dist_thr),:);
        
    case 'nm'
        for v = 1:length(vI)
            expr = sample_expr(sI(:,vI(v)),:);
            surf_expr(vI(v),:) = mean(expr);
        end
        
    case 'linear'
        
        for v = 1:length(vI)
            expr = sample_expr(sI(:,vI(v)),:);
            w = D(,);
            surf_expr(vI(v),:) = mc_wmean(expr,w);
        end
        
        
    otherwise
        error('Wrong interp method');
end