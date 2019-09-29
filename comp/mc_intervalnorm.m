function rx = mc_intervalnorm(x,interval,dim)
% rx = mc_intervalnorm(x,range,dim)

% [] is a special case for std and mean, just handle it out here.
if isequal(x,[]), rx = x; return; end

if nargin < 3
    % Figure out which dimension to work along.
    dim = find(size(x) ~= 1, 1);
    if isempty(dim), dim = 1; end
end


if nargin < 2, interval = [0 1]; end

% scale to [0 1]
min_x = min(x,[],dim);
max_x = max(x,[],dim);
rx = bsxfun(@minus, x, min_x);
rx = bsxfun(@rdivide, rx, max_x-min_x);

% rescale to the interval
rx = interval(1) + rx*(interval(2)-interval(1));
end