function fh = distributionPlotEarthMoversDistance(se)
%
% Make a plot fo the Earth Mover's distance result.
%
nolesion = se.nolesion;
lesion  = se.lesion;
em   = se.em;

histcolor{1} = [0 0 0];
histcolor{2} = [.95 .6 .5];
figName = sprintf('EMD_without_VL_vs_with_VL');
fh = mrvNewGraphWin(figName);
plot(nolesion.xhist,nolesion.hist,'r-','color',histcolor{1},'linewidth',4);
hold on
plot(lesion.xhist,lesion.hist,'r-','color',histcolor{2},'linewidth',4); 
set(gca,'tickdir','out', ...
        'box','off', ...
        'ticklen',[.025 .05], ...
        'ylim',[0 .12], ... 
        'xlim',[0 0.2], ...
        'xtick',[0 0.1 0.2], ...
        'ytick',[0 .5 1], ...
        'fontsize',16)
ylabel('Proportion white-matter volume','fontsize',16)
xlabel('RMSE','fontsize',16')
title(sprintf('Earth Movers Distance: %2.3f',em.mean),'FontSize',16)
legend({'without VL','with VL'})
end
