function [roi_sample,roi_id,roi_name] = map_sample2volatlas(coords,atlas_name,dist_thr,is_rm_overlap)
%[roi_sample,roi_id,roi_name] = mapSample2VolAtlas(coords,atlas_name)

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
     
    otherwise
        error('Wrong volume atlas');
end


% Load atlas label
fid = fopen(label);
label = textscan(fid,'%d %s');
roi_id = label{1}; roi_name = label{2};
fclose(fid);
n_roi = length(roi_id);

% Map samples to atlas
roi_sample = map_match_coords2voi(coords,atlas,dist_thr);

% remove overlap samples
if is_rm_overlap
    roi_sample(sum(roi_sample,2) > 1,:) =  false;
end


figure('units','normalized','outerposition',[0 0 1 1],'name','Sample Number in ROI');
roi_sample_num = sum(roi_sample);
bar(roi_sample_num);
ylabel('Sample number in ROI');
set(gca,'xtick',1:n_roi, 'xticklabel',roi_name,'xticklabelrotation',90);
box off