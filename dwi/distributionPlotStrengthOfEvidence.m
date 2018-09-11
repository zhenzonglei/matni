function fh = distributionPlotStrengthOfEvidence(se)
%
% Make a plot of the Strengh-of-evidence result.
%
y_e        = se.s.unlesioned_e;
ywo_e      = se.s.lesioned_e;
dprime     = se.s.mean;
std_dprime = se.s.std;
xhis       = se.s.unlesioned.xbins;
woxhis     = se.s.lesioned.xbins;

histcolor{1} = [0 0 0];
histcolor{2} = [.95 .6 .5];
figName = sprintf('Strength_of_Evidence_test_without_VL_vs_with_VL');
fh = mrvNewGraphWin(figName);
patch([xhis,xhis],y_e(:),histcolor{1},'FaceColor',histcolor{1},'EdgeColor',histcolor{1});
hold on
patch([woxhis,woxhis],ywo_e(:),histcolor{2},'FaceColor',histcolor{2},'EdgeColor',histcolor{2}); 
set(gca,'tickdir','out', ...
        'box','off', ...
        'ticklen',[.025 .05], ...
        'ylim',[0 1], ... 
        'xlim',[0 0.2], ...
        'xtick',[0 0.1 0.2], ...
        'ytick',[0 .5 1], ...
        'fontsize',16)
ylabel('Probability','fontsize',16)
xlabel('rmse','fontsize',16')

title(sprintf('Strength of evidence:\n mean %2.3f - std %2.3f',dprime,std_dprime), ...
    'FontSize',16)
legend({'without VL','with VL'})
end
