function [coords_roi,roi_id,roi_name] = map_sample2volatlas(coords,atlas_name,...
    dist_thr,is_rm_overlap)
%[coords_roi,roi_id,roi_name] = mapSample2VolAtlas(coords,atlas_name)

if nargin < 4, is_rm_overlap = false; end
if nargin < 3, dist_thr = 2; end
if nargin < 2, atlas_name = 'cyto'; end

data_dir = '/nfs/e5/stanford/ABA/brainmap';

switch atlas_name
    case 'wang'
        atlas = fullfile(data_dir,'wang_retinotopy','MNI152_MPM_1mm.nii.gz');
        label = fullfile(data_dir,'wang_retinotopy','wang_atlas_label.txt');
        
    case 'cyto'
        atlas = fullfile(data_dir,'cytoAtlas','MNI152_cytoMPM_thr25_2mm.nii.gz');
        label = fullfile(data_dir,'cytoAtlas','cytoLabelShort.txt');
        % label = fullfile(data_dir,'cytoAtlas','cytoLabel.txt');
        
    case 'buckner'
        
        atlas = fullfile(data_dir,'bucknerAtlas',...
            'Buckner2011_17Networks_MNI152_FreeSurferConformed1mm_TightMask.nii.gz');
        label = fullfile(data_dir,'bucknerAtlas','Buckner2011_17Networks_label.txt');
        
    otherwise
        error('Wrong volume atlas');
end


% Load atlas label
fid = fopen(label);
label = textscan(fid,'%d %s');
roi_id = label{1};roi_name = label{2};
fclose(fid);
n_roi = length(roi_id);

% Map samples to atlas
[~,coords_roi,roi_id] = map_match_coords2vol(coords,atlas,dist_thr);


% remove overlap samples
if is_rm_overlap
    coords_roi(sum(coords_roi,2) > 1,:) =  false;
end


figure('units','normalized','outerposition',[0 0 1 1],'name','Sample Number in ROI');
coords_roi_num = sum(coords_roi);
bar(coords_roi_num);
ylabel('Sample number in ROI');
set(gca,'xtick',1:n_roi, 'xticklabel',roi_name,'xticklabelrotation',90);
box off