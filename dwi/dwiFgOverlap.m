function D = dwiFgOverlap(dwiDir, sessid,runName, fgName, foi)
% D = dwiFgOverlap(dwiDir, sessid,runName, fgName, foi)
% Calculate the overlap rate between different fg
% fgName is a fg array file

nFg = length(foi);
D = nan(nFg,nFg,length(runName),length(sessid));
for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('Calculate fiber overlap for (%s, %s, %s)\n',...
            sessid{s}, runName{r}, fgName);
        runDir = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin');
        load( fullfile(runDir,'fibers','afq',fgName));
        fg = fg(foi);
        D(:,:,r,s) = fgOverlap(fg);
        
        clear fg
    end
end


function  ovpMat = fgOverlap(fg)
% fg is a structure arry of fg
fg = fg2mat(fg);
nFg = length(fg);
ovpMat = nan(nFg);
for i = 1:nFg
    A = fg(i).fibers;
    for j = (i+1):nFg
        B = fg(j).fibers;
        C  = intersect(A, B,'rows');
        ovpMat(i,j) = size(C,1)/(size(A,1) + size(B,1));
    end
end
ovpMat = ovpMat*2;


function fg = fg2mat(fg)
% fg is a structure array of fg
nFg = length(fg);
% find max length
maxLen = zeros(1,nFg);
for i = 1:nFg
   maxLen(i) = max(fgGet(fg(i),'nodes per fiber'));
end
maxLen = max(maxLen)*3;

% reshape each fiber to be the vector equal to the longest fiber
for i = 1:length(fg)
    nLen = fgGet(fg(i),'nodes per fiber');
    nFibers = length(nLen);
    fibers = zeros(nFibers, maxLen);
     for j = 1:nFibers
         fibers(j,1:nLen(j)*3) = reshape(fg(i).fibers{j},1,[]);
     end
     
     fg(i).fibers = fibers;
end

