function [sesspar,sessid] = utils_readsessfile(sessparFile,sessidFile)
% [sesspar,sessid] = utils_readsessfile(sessparFile,sessidFile)
% read the parent dir and session id from corresponding files
% sessparFile: sesspar file which lists parent dir for sessions, str
% fsessidFile: sessid  file, which lists session id,  str
% sesspar: parent dir, cell
% sessid: sessid,cell

fid  = fopen(sessparFile);
sesspar = textscan(fid,'%s');
sesspar = sesspar{1};
fclose(fid);

fid  = fopen(sessidFile);
sessid = textscan(fid,'%s');
sessid = sessid{1};
fclose(fid);

