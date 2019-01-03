function  plotPairCorr(data, name,rc)
% plotPairCorr(data, name,RC)
if nargin < 3, rc = [3,6]; end

row = rc(1); col = rc(2);
n_var = size(data,2);
f = 0;
for j = 1:n_var
    for k = j+1:n_var
        f = mod(f,row*col);
        if f==0
            figure('units','normalized','outerposition',[0 0 1 1],'name','PairCorr')
        end
        f = f+1;
        X = data(:,j);Y = data(:,k);
        subplot(row,col,f), scatter(X,Y);lsline;
        xlabel(name{j}); ylabel(name{k});
        
        
        [rho,p] = corr(X,Y);
        title(sprintf('(%.2f,%.2f)',rho,p));
        axis square
    end
end

