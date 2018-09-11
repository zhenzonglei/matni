function X = removeOutlier(X,dim,c,meth)
% I = removeOutlier(M, dim, c, meth)
if nargin < 4, meth = 'std'; end
if nargin < 3, c = 3; end

switch meth
    case 'std'
        sd = nanstd(X,0,dim);
        m  = nanmean(X,dim); 
        highr = m + c*sd; 
        lowr = m -c*sd; 
        R = ones(1,ndims(X));
        R(dim) = size(X,dim);
        mask = (X > repmat(highr,R)) | (X < repmat(lowr,R));
        X(mask) = NaN;
    case 'iqr'
        IQR = iqr(X,dim);
        highr= prctile(X,75,dim)+c*IQR;
        lowr = prctile(X,25,dim)-c*IQR;
        R = ones(1,ndims(X));
        R(dim) = size(X,dim);
        mask = (X > repmat(highr,R)) | (X < repmat(lowr,R));
        X(mask) = NaN;
    otherwise
        error('Wrong method');
end

