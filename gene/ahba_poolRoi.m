function pr_roi =  poolRoi(roi,group,group_name)
% pool roi according to the group
% roi,  nRoixnDonor structure array
% pr_roi, nGroupxnDonor structure array
% group, index from 1 to N continous

nDonor = size(roi,2);
nGroup = max(group);

pr_roi(nGroup,nDonor).label =[];
pr_roi(nGroup,nDonor).expr = [];
pr_roi(nGroup,nDonor).mni = [];
pr_roi(nGroup,nDonor).call = [];

for d = 1:nDonor
    for g = 1:nGroup
        pr_roi(g,d).label= group_name{g};
        
        G = find(group == g);
        for i = 1:length(G)
            pr_roi(g,d).expr = [pr_roi(g,d).expr; roi(G(i),d).expr];
            pr_roi(g,d).mni = [pr_roi(g,d).mni; roi(G(i),d).mni];
            pr_roi(g,d).call = [pr_roi(g,d).call; roi(G(i),d).call];
            
        end
    end
end