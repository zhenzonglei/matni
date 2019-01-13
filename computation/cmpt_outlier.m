function I = cmpt_outlier(X,dim,c,meth)
% I = cmpt_outlier(X,dim,c,meth)
if nargin < 4, meth = 'std'; end
if nargin < 3, c = 3; end
if nargin < 2, dim = 1;end

switch meth
    case 'std'
        sd = nanstd(X,0,dim);
        m  = nanmean(X,dim); 
        highr = m + c*sd; 
        lowr = m -c*sd; 
        R = ones(1,ndims(X));
        R(dim) = size(X,dim);
        I = (X > repmat(highr,R)) | (X < repmat(lowr,R));
        X(I) = NaN;
    case 'iqr'
        IQR = iqr(X,dim);
        highr= prctile(X,75,dim)+c*IQR;
        lowr = prctile(X,25,dim)-c*IQR;
        R = ones(1,ndims(X));
        R(dim) = size(X,dim);
        I = (X > repmat(highr,R)) | (X < repmat(lowr,R));
        X(I) = NaN;
    otherwise
        error('Wrong method');
end