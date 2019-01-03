function [matrix_ld_path,orig_ld_path] = fatSetMRtrixLDpath(mrtrixVersion)
% mrtrix_ld_path = fatSetMRtrixLDpath(mrtrixVersion)
% Set the library path for mrtrix libraries

if nargin < 1, mrtrixVersion = 3; end

if mrtrixVersion == 2
    funcName = 'csdeconv';
end
if mrtrixVersion == 3
    funcName = 'dwi2fod';
end


% Save origional environment path
orig_ld_path = getenv('LD_LIBRARY_PATH');
% Get mrtrix path
[status, pathstr] = system(['which ' funcName]);
if status~=0
    error('Please install mrtrix')
end
% This will be the path to the mrtrix libraries
matrix_ld_path = fullfile(pathstr(1:end-13),'lib');
% set the environment path
setenv('LD_LIBRARY_PATH',matrix_ld_path)