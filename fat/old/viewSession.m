
function viewSession(sesspar,sessid,task)

if nargin < 3, task = 'wmmaskcheck'; end


if strcmp(task,'wmmaskcheck')
  viewcmd = ['fslview -m ortho 96dir_run1/t1/T1_QMR_1mm ' ...
  '96dir_run1/t1/T1_wm_1mm -t 240 ' ...
      '96dir_run1/T1_ventQMR_1mm']
end



% sesspar = sesspar{1}
cwd = pwd;
for s = 1:length(sessid)
    
    cd(fullfile(sesspar, sessid{s}));
    fprintf('view %s\n', sessid{s});
    system('LD_LIBRARY_PATH=/usr/lib/fslview')
    unix(viewcmd);
end

cd(cwd);



