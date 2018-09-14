function  D = dice(M)
% calculate dice coef between each pair of columns from M
% M should be binary
M = M > 0; 
nc = size(M,2);
D = zeros(nc);
for i = 1:nc
    for j = (i+1):nc
        Mi = M(:,i);
        Mj = M(:,j);
        D(i,j) = sum(Mi&Mj)/(sum(Mi)+sum(Mj));        
    end
end
D = 2*D;
D(isnan(D)) = 0;