function coords_voi = map_match_coords2voi(coords,roiFile,dist_thr)

if nargin < 3, dist_thr = 2; end

% load roi vol
ni = niftiRead(roiFile);
roiId = unique(ni.data(:));
roiId(roiId==0) = [];
n_roi = length(roiId);
n_samp = size(coords,1);

coords_voi = false(n_samp,n_roi);
for i = 1:n_roi
    % get mni coors for a roi
    [I,J,K] =  ind2sub(size(ni.data),find(ni.data == roiId(i)));
    roi_mni_coords = mrAnatXformCoords(ni.qto_xyz, [I,J,K]);
    
    % samples near the roi Is assigned to the roi
    D = pdist2(coords,roi_mni_coords);
    I = any(D < dist_thr,2);
    coords_voi(I,i) = true;
end


