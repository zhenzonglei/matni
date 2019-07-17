function graph_orthview(coords, value, name)
% graph_orthview(coords, value, name)
% plot 3d coords in orth view with value

nc = size(coords,1);
nv = size(value,2);
if size(value,1) ~= nc
    error('Number of value is not match the coords');
end

x = coords(:,1); y = coords(:,2); z = coords(:,3);
sz = 50;

for i = 1:nv
    figure('units','normalized','outerposition',[0 0 1 1],'name',name{i});
    c = value(:,i);
    colormap('jet')
    
   
    % coronal view
    subplot(2,2,1)
    scatter(x,z,sz,c,'filled')
    xlabel('X'); ylabel('Z');
    axis square
    title(name{i})
    colorbar
    
    % sagittal view
    subplot(2,2,2)
    scatter(y,z,sz,c,'filled')
    xlabel('Y'); ylabel('Z');
    axis square
    title(name{i})
    colorbar
    
    % axial view
    subplot(2,2,3)
    scatter(x,y,sz,c,'filled')
    xlabel('X'); ylabel('Y');
    axis square
    title(name{i})
    colorbar
end





