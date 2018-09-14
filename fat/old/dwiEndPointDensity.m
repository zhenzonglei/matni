function  dwiEndPointDensity(dwiDir, sessid, runName, fgName, foi, radius, normalize)
%   dwiEndPointDensity(dwiDir, sessid, runName, fgName, foi, radius,
%   normalize);
%   radius is in mm
if nargin < 7, normalize = true; end
if nargin < 6, radius = 5; end

for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('Endpoint Density for (%s, %s)\n',sessid{s}, runName{r});
        runDir = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin');
        afqDir = fullfile(runDir,'fibers','afq');
        epdDir = fullfile(afqDir,'epd');
        if ~exist(epdDir,'dir')
            mkdir(epdDir)
        end
       
        % read fg and calc endpoint density for each fibers
        % fg = dtiReadFibers(fullfile(afqDir,fgName));
        load(fullfile(afqDir,fgName),'fg');
        
        % don't try to process empty fiber groups
        I = true(length(foi),1);
        for i=1:length(foi)
            if length(fg(foi(i)).fibers)<1
                I(i) = false;
            end
        end
        fg = fg(foi(I));
        nFg = length(fg);
        
        % use ref image info to convert the acpa coords to img coords
        refImg = niftiRead(fullfile(runDir,'bin','b0.nii.gz'),[]);
        radius = round(radius/nthroot(prod(refImg.pixdim),3));
        
        % Get coordinates for sphere
        sc = dtiBuildSphereCoords([0,0,0], radius);
        nSc = size(sc,1);
        
        imSize = refImg.dim;
        fdImg = zeros(imSize);
        for i=1:nFg
            nfibers = length(fg(i).fibers);
            % fiber terminates
            ft = zeros(nfibers*2, 3);
            for j=1:nfibers
                ft((j-1)*2+1,:) = fg(i).fibers{j}(:,1);
                ft((j-1)*2+2,:) = fg(i).fibers{j}(:,end);
            end
            
            % convert acpc coords to img coords
            ft  = round(mrAnatXformCoords(refImg.qto_ijk, ft));
            nFt = size(ft,1);
            
            % expand each endpoint as a sphere
            fc = zeros(nFt*nSc, 3);
            for j=1:nFt
                I = (j-1)*nSc;
                T = ft(j,:);
                fc(I+1:I+nSc,:) = [T(1)+sc(:,1),T(2)+sc(:,2), T(3)+sc(:,3)];
            end
            
            badCoords = any(fc<1,2)|(fc(:,1)>imSize(1)|fc(:,2)>imSize(2)|fc(:,3)>imSize(3));
            fc(badCoords,:) = [];
            fInd{i} = sub2ind(imSize, fc(:,1), fc(:,2), fc(:,3));
        end
        
        % Get hist for each endpoint(voxel)
        for i=1:nFg
            [count,val] = hist(fInd{i}, 1:prod(imSize));
            fdImg(val) = fdImg(val)+count;
        end
        
        if normalize
            fdImg(val) = fdImg(val)/max(fdImg(:));
        end
        
        fdName = strrep(fg(1).name,' ','_');
        for i = 2:nFg
            fdName = [fdName,'_',strrep(fg(i).name,' ','_')];            
        end
        
        fdFile = fullfile(epdDir,[fdName,'_epd_r5.nii.gz']);
        dtiWriteNiftiWrapper(fdImg,refImg.qto_xyz,fdFile);
    end
end