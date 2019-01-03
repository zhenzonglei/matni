function oidx = matrixOutlier(M, loc)
% oidx = matrixOutlier(M, loc)
% calcuate outlier for each location in the matrix
% M is target NxNxM array
% loc is a 2D location array

[I,J] = find(loc);
N = length(I);
oidx = zeros(N,size(M,3));
for c = 1:N
    d = squeeze(M(I(c),J(c),:));
    oidx(c,:) = outlier(d,3,'IQR');
end

end


function  O = outlier(d,c,meth)
% meth, SD or IQR
% c, criterion
if strcmp(meth,'SD')
    
elseif strcmp(meth,'IQR')
    Q = prctile(d, [25; 75]);
    IQR = Q(2) - Q(1);
    O =  d < (Q(1)-c*IQR) | d >(Q(2) + c*IQR) ;
end

end
