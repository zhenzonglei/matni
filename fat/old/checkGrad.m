function [bval, bvec] = checkGrad(dwiDir,sessid,meth)
% checkGrad(dwiDir,sessid)

if nargin < 3, meth = 'run'; end

fprintf('Check if the grad is consistent across differnt runs\n');
fprintf('Subjects who show differnt grads include: \n');

switch meth
    case 'run'
        R = 2;
        D = 104;
        for s = 1:length(sessid)
            subjDir = fullfile(dwiDir, sessid{s});
            bval = zeros(D,R);
            bvec = zeros(3,D,R);
            for r = 1:R
                bval(:,r) = dlmread(fullfile(subjDir,...
                    sprintf('96dir_run%d/raw/run%d.bval', r,r)));
                
                bvec(:,:,r) = dlmread(fullfile(subjDir,...
                    sprintf('96dir_run%d/raw/run%d.bvec', r,r)));
                
            end
            
            % compare bval
            match_bval = diff(bval,1,2);
            if any(match_bval(:))
                fprintf('%s: bval not match\n', sessid{s});
            else
                fprintf('%s: bval match\n', sessid{s});
            end
            %                  disp(match_bval)
            
            % compare bvec
            match_bvec = diff(bvec,1,3);
            if any(match_bvec(:))
                fprintf('%s\n', sessid{s});
            end
        end
        
        
    case 'concat'
        for s = 1:length(sessid)
            subjDir = fullfile(dwiDir, sessid{s},'96dir_concat','raw');
            bval = dlmread(fullfile(subjDir, 'concat.bval'));
            match_bval = (bval(1:104) == bval(105:end));
            if all(match_bval)
                fprintf('%s:bval is match\n', sessid{s})
            else
                fprintf('%s:bval not match\n', sessid{s})
            end
            
            bvec = dlmread(fullfile(subjDir, 'concat.bvec'));
            match_bvec = (bvec(:, 1:104) == bvec(:,105:end));
            if ~ all(match_bvec(:)) 
                fprintf('%s\n', sessid{s})
            end
            
        end
        
    otherwise
        disp('Wrong method');
end

