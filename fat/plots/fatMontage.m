function bigImg = fatMontage(fatDir, sessid, runName, imgName)

nC = 4; % col for individual image
rows = [301,1490];
cols = [511 1970];
h = rows(2)-rows(1)+1; % height of individual image
w = cols(2)-cols(1)+1; % width of individual image

[~,fname] = fileparts(imgName);
hemi = fname(1:2);
if strcmp(hemi,'lh')
    txt_hoffset = 100;
    txt_woffset = 280;
elseif strcmp(hemi,'rh')
    txt_hoffset = 250;
    txt_woffset = 350;
end

close all
for r = 1:length(runName)
    % calculate the rows of sub image
    idx = false(1,length(sessid));
    for s = 1:length(sessid)
        runDir = fullfile(fatDir,sessid{s},runName{r},'dti96trilin');
        imgDir = fullfile(runDir, 'fibers','afq','image');
        
        if exist(fullfile(imgDir,imgName),'file')
            idx(s) = true;
        end
    end
    nR = ceil(sum(idx)/nC); % num of rows for individual image
    
    bigImg = zeros(nR*h,nC*w,3, 'uint8') + 255;
    cnt = 1;
    for s = find(idx)
        runDir = fullfile(fatDir,sessid{s},runName{r},'dti96trilin');
        imgDir = fullfile(runDir, 'fibers','afq','image');
        
        if exist(fullfile(imgDir,imgName),'file')
            fprintf('Read (%s,%s)\n',sessid{s},imgName);
            Y = imread(fullfile(imgDir,imgName),'PixelRegion',{rows, cols});
            bigImg = fatAddSmallImg2BigImg(bigImg,Y,[nR,nC,cnt]);
            cnt = cnt+1;
        end
    end
    
    %% add text on image
    figure('units','normalized','outerposition',[0 0 1 1]);
    txtImg = zeros(size(bigImg),'uint8');
    imshow(txtImg);
    axis image
    axis off
    
    % write text on the txtImg
    sessid = sessid(idx);
    for i = 1:length(sessid)
        ir = ceil(i/nC);
        ic = mod(i,nC);
        if ~ic, ic = nC; end
        
        % calcaulte the index for the small image
        irs = (ir-1)*h + txt_hoffset;
        ics = (ic-1)*w + txt_woffset;
        text(ics,irs,sessid{i}(end-1:end),'color',[1 1 0],'Fontsize',10)
    end
    
    % export txtImg
%     txtImg = export_fig('-native');
    [nX,nY,~] = size(bigImg);

    % combine the image with text image
    img = bigImg + txtImg(1:nX,1:nY,:);
    imshow(img)

    
    % write image
    if ~isempty(img)
    imwrite(img,fullfile(fatDir,sprintf('montage_%s',imgName)),'Resolution', 300);
    end
end
