function dwiRunEngine(dwiDir,sessid, runName, stepName, force)
% dwiRunEngine(dwiDir, sessid, stepName)
% This function run dwi process for the step specified by stepName
% stepName: The name for the target step:'dwiPrepare','dwiPreprocess',
% 'dwiRunET', 'dwiRunLife' and 'dwiRunAll'. str

if nargin < 5, force = false; end

switch stepName
    case 'dwiPrepare'
        dwiPrepare(dwiDir, sessid);
        
    case 'dwiTransform'
        dwiTransform(dwiDir, sessid, runName);
        
    case 'dwiPreprocess'
        dwiPreprocess(dwiDir, sessid, runName, force);
        
    case 'dwiPlotMotion'
        dwiPlotMotion(dwiDir, sessid, runName, force);
        
        
    case 'dwiMakeWMmask'
        dwiMakeWMmask(dwiDir, sessid, 'wm', force)
        
    case 'dwiRunET'
        dwiRunET(dwiDir, sessid, runName, force);
        
    case 'dwiRunLife'
        dwiRunLife(dwiDir, sessid, runName, force);
        
    case 'dwiRunAFQ'
        dwiRunAFQ(dwiDir, sessid, runName, force);
        
    case 'dwiRunAll'
        dwiPrepare(dwiDir, sessid);
        dwiTransform(dwiDir, sessid, runName);
        dwiPreprocesss(dwiDir, sessid, runName, force);
        dwiMakeWMmask(dwiDir, sessid, 'wm', force)
        dwiRunET(dwiDir, sessid, runName, force);
        dwiRunLife(dwiDir, sessid, runName, force);
        
    otherwise
        error('Unknown step.')
end