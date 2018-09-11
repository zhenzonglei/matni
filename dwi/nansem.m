function se = nansem(x,w,dim)
% calculate sem, ignoring
%
%   m = nansem(x,dim)
%
if nargin < 2 || isempty(w), w = 0; end


nans = isnan(x);
if nargin == 1 % let sum deal with figuring out which dimension to use
    % Count up non-NaNs.
    n = sum(~nans);
    n(n==0) = NaN; % prevent divideByZero warnings
    se = nanstd(x,w) ./ sqrt(n);
else
    % Count up non-NaNs.
    n = sum(~nans,dim);
    n(n==0) = NaN; % prevent divideByZero warnings
    se = nanstd(x,w,dim) ./ sqrt(n);
end

return
