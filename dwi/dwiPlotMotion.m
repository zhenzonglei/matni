function [motMean, motStd] = dwiPlotMotion(dwiDir, sessid, runName, force)
% [motMean, motStd] = dwiPlotMotion(dwiDir, sessid, runName, force)
% summarize the motion parameter and plot it for each subject each run.


if nargin < 4, force = false; end

nSub = length(sessid);
nRun = length(runName);
motMean = zeros(nSub,nRun,3); % 3 = [trans, rot, total]
motStd = zeros(nSub,nRun,3);

for s = 1:nSub
    for r = 1:nRun
        fprintf('Summarize head motion for %s-%s\n',...
            sessid{s},runName{r});
        
        k = strfind(runName{r},'_')+1;
        ecXformFile = fullfile(dwiDir,sessid{s},runName{r}, ...
            sprintf('%s_aligned_trilin_ecXform.mat',runName{r}(k:end)));
        
        if exist(ecXformFile,'file')
            ec = load(ecXformFile);
        else
            continue
        end
        
        % Load the stored trasformation file.
        t = vertcat(ec.xform(:).ecParams);
        trans = sqrt(sum(t(:,1:3).^2, 2)); % sumarize translation motion
        rot = sqrt(sum(t(:,4:6).^2,2))*50/2; % sumarize rotation motion
        total = sqrt(rot.^2 + trans.^2);   % Total Motion
        mot = [trans,rot,total];
        motMean(s,r,:) = mean(mot);
        motStd(s,r,:) = std(mot);
        
        % Save out a PNG figure
        [p,f,~] = fileparts(ecXformFile);
        figurename = fullfile(p,[f,'_summary.png']);
        
        if ~exist(figurename,'file') || force
            tf = figure; hold;
            title(sprintf('%s:%s',sessid{s},runName{r}(k:end)), ...
                'FontSize', 10, 'Fontweight', 'bold', 'Color', [0 0 0]);
            xlabel('Motion parameters', 'FontSize', 10, 'Color', [0 0 0]);
            ylabel('Head motion(voxels)', 'FontSize',10, 'Color', [0 0 0]);
            X = 0:0.5:3.5; Y = ones(1,length(X))*2;
            plot(X, Y, '--r', 'LineWidth', 2);
            
            boxplot(mot)
            Labels = {'Trans', 'Rot', 'Total'};
            set(gca, 'XTick', 1:3, 'XTickLabel', Labels);
            axis square
            
            
            fig = gcf;
            fig.PaperUnits = 'inches';
            fig.PaperPosition = [0 0 6 4];
            
            print('-dpng','-r200',figurename);
            
            close(tf)
        end
    end
end


             
