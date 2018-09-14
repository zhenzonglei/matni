function maskSize = dwiMaskSize(dwiDir, sessid, maskName)
% dwiMakeWMmask(dwiDir, sessid, maskName)
if nargin < 3, maskName = 'wm_mask_resliced.nii.gz'; end

anatDir = '/sni-storage/kalanit/biac2/kgs/projects/Longitudinal/Anatomy/';
nSubj = length(sessid);
maskSize = zeros(nSubj,1);
for s = 1:length(sessid)
    fprintf('Calc WM Mask Size for %s\n',sessid{s});
    t1Dir = fullfile(anatDir, sessid{s}, 'T1');
    fMask = fullfile(t1Dir, maskName);
    
    % read WM mask
    ni = readFileNifti(fMask);    
    wm = ni.data==1;
    maskSize(s) = sum(wm(:));
end


