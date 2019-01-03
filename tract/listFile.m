function fileName = listFile(targDir)
% fileName = listFile(targdir)
% list all file name in a dir
% targdir, str
% fileName, str cell

D = dir(targDir); 
D = D(3:end);
fileName = extractfield(D, 'name');
