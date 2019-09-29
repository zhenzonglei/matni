function sx = mc_sigmodnorm(x,dim)
% sx = cmpt_sigmodnorm(x,dim)
% scaled robust sigmoid (SRS) normalization

% [] is a special case for std and mean, just handle it out here.
if isequal(x,[]), sx = x; return; end

if nargin < 2
    % Figure out which dimension to work along.
    dim = find(size(x) ~= 1, 1);
    if isempty(dim), dim = 1; end
end

% Compute X's median and sd, and standardize it
mu = median(x,dim);
sigma = std(x,1,dim);
sigma0 = sigma;
sigma0(sigma0==0) = 1;


% sigmoid  transform 
sx = bsxfun(@minus,x, mu);
sx = bsxfun(@rdivide, sx, sigma0);
sx = 1 + exp(-sx);
sx = bsxfun(@rdivide, 1, sx);

% rescale to unit interval
min_sx = min(sx,[],dim);
max_sx = max(sx,[],dim);

sx = bsxfun(@minus, sx, min_sx);
sx = bsxfun(@rdivide, sx, max_sx-min_sx);

end

