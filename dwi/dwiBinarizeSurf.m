function dwiBinarizeSurf(dwiDir, sessid, runName, surfName, mthr, ndilate, nerode)
%  dwiBinarizeSurf(dwiDir, sessid, runName, surfName, mthr)
% mthr, thr for the minimal value
% surfName should be specified according to the runDir, cell array
if nargin < 7, nerode = 1; end
if nargin < 6, ndilate = 3; end
if nargin < 5, mthr = 0.05; end

cwd = pwd;
for s = 1:length(sessid)
    for r = 1:length(runName)
        fprintf('Binarize surface for (%s, %s)\n',sessid{s}, runName{r});
        runDir = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin');
        
        for i = 1:length(surfName)
            [fPath,surfNameWoExt] = fileparts(surfName{i});
            surfDir = fullfile(runDir,fPath);
            cd(surfDir);
         
            if exist(surfName{i}, 'file')
                % binarize surface
                surfbin  = sprintf('mri_binarize --i %s.mgz --min %0.2f --dilate %d --erode %d --o %s_bin.mgz',...
                    surfNameWoExt,mthr,ndilate,nerode,surfNameWoExt);
                system(surfbin);
            end
        end
    end
end
cd(cwd);

