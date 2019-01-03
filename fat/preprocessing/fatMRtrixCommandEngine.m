function fatMRtrixCommandEngine(dwiDir,sessid, runName, cmdStr,mrtrixVersion, bkgrnd, verbose)
   
% run cmdStr for for subjects and runs
% the engine will generate commands for each session and each run by
% replace sessid string(SESS) and run string(RUN) in the cmdStr
% function [status,results] = mrtrix_cmd(cmd_str, [bkgrnd=true], [verbose=true])
%
% Send a command to an mrtrix function and get back status and results
%
% INPUTS:
%   cmd_str - A string containing the mrtrix command to run
%   bkgrnd  - [true/false] Whether to execute the command in the background (only possible on unix)
%   verbose - Whether to display stdout to the command window (when it's done).
%
% OUTPUTS:
%   status  - Whether the operation succeeded (1) or not (0)
%   results - The results of the operation in stdout.
%
% Notes:
%  When bkgrnd is set to true, the command will be executed in another
%  terminal.

if nargin < 7, verbose = false; end
if nargin < 6, bkgrnd = false; end
if nargin < 5, mrtrixVersion = 3; end


% Need to bypass the matlab libraries at the top of the path, by screwing
% with it:
[~,orig_ld_path] = fatSetMRtrixLDpath(mrtrixVersion);

% run cmdstr
cmdEngine(dwiDir,sessid, runName, cmdStr,bkgrnd, verbose);

% Reset the ld_path:
setenv('LD_LIBRARY_PATH', orig_ld_path);