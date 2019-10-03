function [sample_roi_idx,roi_id,roi_name] = mm_sample2surfatlas(coords,hemi,dist_thr)
%[sample_roi_idx,roi_id,roi_name] = mm_sample2surfatlas(coords,hemi,dist_thr)
if nargin < 3, dist_thr = 5; end
if nargin < 2 , hemi = 'L'; end;
brainmm_dir = '/nfs/e5/stanford/ABA/brainmap';
surf_dir = fullfile(brainmm_dir,'HCP','HCP_S1200_GroupAvg_v1');

% Load atlas label
roi_name = {'V1','V2','V3','hV4','VO1','VO2','LO1','LO2','TO1','TO2','V3b','V3a'};
n_roi = length(roi_name);

switch hemi
    case {'L','R'}
        [sample_roi_idx,roi_id] = sample2Benson(coords,surf_dir, brainmm_dir,hemi,dist_thr);
    case 'LR'
        
        [sample_roi_idx_L,roi_id_L] = sample2Benson(coords,surf_dir, brainmm_dir,'L',dist_thr);
        [sample_roi_idx_R,roi_id_R] = sample2Benson(coords, surf_dir,brainmm_dir,'R',dist_thr);
        sample_roi_idx = sample_roi_idx_L | sample_roi_idx_R;
        roi_id = roi_id_L;
    otherwise
        error('Wrong hemi');
end

% remove overlap samples
% sample_roi_idx(sum(sample_roi_idx,2) > 1,:) =  false;

% plot sample number 
figure('units','normalized','outerposition',[0 0 1 1],'name','Sample Number in ROI');
roi_sample_num = sum(sample_roi_idx);
bar(roi_sample_num);
ylabel('Sample number in ROI');
set(gca,'xtick',1:n_roi, 'xticklabel',roi_name,'xticklabelrotation',90);
box off

fprintf('%d samples on surface in total\n',sum(roi_sample_num));


function [sample_roi_idx,roi_id] = sample2Benson(coords,surf_dir, brainmm_dir,hemi,dist_thr)
% surf file
surf_file = fullfile(surf_dir, ...
    sprintf('S1200.%s.midthickness_MSMAll.32k_fs_LR.surf.gii',hemi));

% benson label file
if strcmp(hemi,'L'), xh = 'lh'; else, xh = 'rh'; end
label_file = fullfile(brainmm_dir,'benson_retinotopy','fs_LR',...
    sprintf('%s.benson17_varea_32k_fs_LR.func.gii',xh));

% Map samples to atlas
surf = gifti(surf_file); label = gifti(label_file);
[~,coords_roi,roi_id] = mm_coords2surf(coords,surf,dist_thr,label);

sample_roi_idx = coords_roi;
