function dwiSurfGroupAvgSym(dwiDir, sessid, runName, surfName)
% dwiSurfGroupAvg(dwiDir, sessid, runName, surfName)
% concate individual surf file and do avarage
% surfName = epdVol{1}
% the surfName should be assigned according based on the run dir, cell
% array
cwd = pwd;
grpDir  = '/home/zhenzl/analysis/data/epd';
cd(grpDir)

for r = 1:length(runName)
    for i = 1:length(surfName)
        [~,surfNameWoExt] = fileparts(surfName{i});
        [~,surfNameWoExt] = fileparts(surfNameWoExt);
        % Make suf file list
        fileList = [surfNameWoExt,'_',runName{r},'.txt'];
        fid = fopen(fileList,'w');
        for s = 1:length(sessid)
            runDir = fullfile(dwiDir,sessid{s},runName{r},'dti96trilin');
            surfFile = fullfile(runDir,surfName{i});
            if exist(surfFile, 'file')
                fprintf(fid, '%s\n',surfFile);
            end
        end
        fclose(fid);
        
        % concate surf
        fileName = [surfNameWoExt,'_', runName{r}];
        % concat = sprintf('mri_concat --f %s --o %s_concat.mgz', fileList, fileName);
        % system(concat);
        
        % average surf
        % avg = sprintf('mri_concat --i %s_concat.mgz --o %s_concat_mean.mgz --mean', fileName, fileName);
        % system(avg);
        
        
        
        surf2surf = sprintf('mri_surf2surf --srcsubject fsaverage --sval %s_concat_mean.mgz --trgsubject fsaverage_sym --tval %s_concat_mean_sym.mgz  --hemi %s ',...
            fileName, fileName);
        system(surf2surf);
        
        
    end
end
cd(cwd);