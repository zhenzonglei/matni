function  behVal = dwiBehScore(dwiDir, sessid, taskName)
% selVal = dwiRoiSelectivity(dwiDir, sessid, taskName)
% sessid, a 1xN cell array
% taskName, a 1xN cell array
behDir = fullfile(dwiDir, 'Behavioral/All_Subs_Year1');
nSubj = length(sessid);
nTask = length(taskName);

behVal = NaN(nSubj,nTask);
for s = 1:nSubj
    fprintf('Extract behavior data for %s\n',sessid{s});
    behFile =  fullfile(behDir, sessid{s},'behave.mat');
    if exist(behFile, 'file')
        BEH = load(behFile);
        for t = 1:nTask
            beh =  BEH.behave.(taskName{t});
            if isfield(beh, 'pc') && ~isempty(beh.pc)
                behVal(s,t) = beh.pc;
            elseif isfield(beh,'score') && ~isempty(beh.score)
                behVal(s,t) = beh.score;
            end
        end
    end
end
