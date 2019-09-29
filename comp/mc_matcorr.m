function  [rho,p] = mc_matcorr(X,Y,index,meth)
%  [rho,p] = matcorr(X,Y,index,type) 
% calculate the correlaiton between two matrix
% X and Y are 2D matrices with the same size
% index, the location index to the interest of elements 
% meth, 'Pearson','Spearman'
if nargin < 4, meth = 'Pearson'; end
if nargin < 3
    index = triu(true(size(X)),1);
end

[rho,p] = corr(X(index),Y(index),'type',meth);