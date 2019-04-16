function [symbol,targ_index,src_index] = ahba_genefind(targ,src,mode)
% find the index of src genes in targ gene list
% targ, targ gene cell array
%  src, source, src gene array
if nargin < 3, mode = 'match'; end

nS = length(src);
targ_index = zeros(nS,1);src_index = false(nS,1);
switch mode
    case 'match'
        for s = 1:nS
            idx = find(strcmp(targ,src{s}), 1);
            if isempty(idx)
                continue
            else
                targ_index(s) = idx;
                src_index(s) = true;
            end
        end
        
    case 'contain'
        for s = 1:nS
            idx = find(contains(targ,src{s},'IgnoreCase',true), 1);
            if isempty(idx)
                continue
            else
                targ_index(s) = idx;
                src_index(s) = true;
            end
        end
        
    otherwise
        error('Wrong mode');
end


I = logical(targ_index);
targ_index = targ_index(I);
symbol = src(I);


