function [coords_roi,roi_id,roi_name] = mm_sample2volatlas(coords,atlas_name,...
    dist_thr,is_rm_overlap)
%[coords_roi,roi_id,roi_name] = mapSample2VolAtlas(coords,atlas_name)

if nargin < 4, is_rm_overlap = false; end
if nargin < 3, dist_thr = 2; end
if nargin < 2, atlas_name = 'cyto'; end

data_dir = '/nfs/e5/stanford/ABA/brainmap';

switch atlas_name
    case 'wang'
        atlas = fullfile(data_dir,'wang_retinotopy','vol','MNI152_MPM_1mm.nii.gz');
        label = fullfile(data_dir,'wang_retinotopy','vol','wang_atlas_label.txt');
        
    case 'cyto'
        atlas = fullfile(data_dir,'cytoAtlas','MNI152_cytoMPM_thr25_2mm.nii.gz');
        label = fullfile(data_dir,'cytoAtlas','cytoLabelShort.txt');
        % label = fullfile(data_dir,'cytoAtlas','cytoLabel.txt');
        
            
    case 'fconn'
        atlas = fullfile(data_dir,'buckner',...
            'Buckner2011_7Networks_MNI152_FreeSurferConformed1mm_TightMask.nii.gz');
        label = fullfile(data_dir,'buckner','Buckner2011_7Networks_label.txt');
        
        
    case 'fconn17'
        atlas = fullfile(data_dir,'buckner',...
            'Buckner2011_17Networks_MNI152_FreeSurferConformed1mm_TightMask.nii.gz');
        label = fullfile(data_dir,'buckner','Buckner2011_17Networks_label.txt');
        
        
        
        
        
    case 'yeo'
        atlas = fullfile(data_dir,'yeoAtlas',...
            'Yeo2011_7Networks_MNI152_FreeSurferConformed1mm.nii.gz');
        label = fullfile(data_dir,'yeoAtlas','Yeo2011_7Networks_label.txt');
        
        
    case 'mdtb'
        atlas = fullfile(data_dir,'mdtb','mdtb_mni.nii');
        label = fullfile(data_dir,'mdtb','mdtb_label.txt');
        
        
    otherwise
        error('Wrong volume atlas');
end

% Map samples to atlas
[~,coords_roi,roi_id] = mm_matchcoords2vol(coords,atlas,dist_thr);


% Load atlas label
fid = fopen(label);
label = textscan(fid,'%d %s');
roi_id = label{1};roi_name = label{2};
fclose(fid);
n_roi = length(roi_id);


% % remove overlap samples
if is_rm_overlap
    coords_roi(sum(coords_roi,2) > 1,:) =  false;
end


figure('units','normalized','outerposition',[0 0 1 1],'name','Sample Number in ROI');
coords_roi_num = sum(coords_roi);
bar(coords_roi_num);
ylabel('Sample number in ROI');
set(gca,'xtick',1:n_roi, 'xticklabel',roi_name,'xticklabelrotation',90);
box off
axis square