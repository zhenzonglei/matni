function concateSession(sesspar,sessid,filePath)
% cmd = concateSession(sesspar,sessid,filePath)
% merge individual subject data to 4D using fslmerge
% filePath is relative to subject dir

cwd = pwd;

[~, name, ext] = fileparts(filePath);
cmd = sprintf('fslmerge -t %s ',[name ext]);

cd(sesspar)
for s = 1:length(sessid)
    subjFile = fullfile(sessid{s},filePath);
    cmd = [cmd sprintf('%s ',subjFile)];
end

fprintf('%s\n',cmd)
system(cmd);
if exist([name ext],'file')
    movefile([name ext], cwd)
end
cd(cwd);




