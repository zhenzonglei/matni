function hb = plotErrorBar(Y,E)
%  hb = plotErrorBar(Y,E)
% Plot the columns of the M-by-N matrix Y as M groups of N vertical bars
% with error

[numgroups, numbars] = size(Y);
hb = bar(Y, 'linewidth', 1);
hold on
if numbars ==1
    set(hb,'BarWidth',0.8);
    
    if ~isempty(E)
        errorbar(Y,E,'.')
    end
else
    set(hb,'BarWidth',1);
    
    if ~isempty(E)
        groupwidth = min(0.8, numbars/(numbars+1.5));
        for j = 1:numbars
            x = (1:numgroups)-groupwidth/2 +(2*j-1)*groupwidth/(2*numbars);
            errorbar(x, Y(:,j), E(:,j),'.', 'Color','k');
        end
    end
end