%% git mv for matni

matni = '/nfs/e5/stanford/codebase/matni';
subdir = fullfile(matni,'map');

cwd = pwd;
cd(subdir)
m = dir('*.m');

% for i = 1:length(m)
%     
%     old_name = m(i).name;
%     
%     idx = strfind(old_name,'_');
%     if ~isempty(idx)
%         idx = idx(1);
%         new_name = ['mm',old_name(idx:end)];
%         cmd = sprintf('git mv %s %s',old_name,new_name);
%      system(cmd); 
%     end
% end
% cd(cwd);



for i = 1:length(m)
    
    old_name = m(i).name;
    
    idx = strfind(old_name,'_');
    if length(idx) == 2
        idx = idx(2);
        new_name = old_name; 
        new_name(idx) = []; 
        cmd = sprintf('git mv %s %s',old_name,new_name);
      system(cmd); 
    end
end
cd(cwd);

%% git mv for mrfree
workdir = '/nfs/e5/stanford/codebase/matni/map';
cwd = pwd; cd(workdir)
f = dir(fullfile(workdir,'*bigbrain*'));
for i = 1:length(f)
    old_name = f(i).name;
    new_name =  strrep(old_name,'bigbrain','bb');
    cmd = sprintf('git mv %s %s',old_name,new_name)
      system(cmd);
end
cd(cwd);

