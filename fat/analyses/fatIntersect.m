function [IA,IB] = fgIntersect(fgA, fgB, bidir)
% intersect fgA and fgB
% Note that fgA and fgB should be from the same connectome
% IA and IB is the index vector for fgA and fgB
if nargin < 3, bidir = true; end

% fgA = fullFg;
% fgB = targFg;
lenA = fgGet(fgA,'nodes per fiber')*3;
lenB = fgGet(fgB,'nodes per fiber')*3;
lenAB = intersect(lenA,lenB);
maxLen = max(lenAB);

% Keep A fibers with possible length
IA = find(ismember(lenA, lenAB));
fgA.fibers = fgA.fibers(IA);

% Keep B fibers with possible length
IB = find(ismember(lenB, lenAB));
fgB.fibers = fgB.fibers(IB);

% convert fgA to mat
lenA = lenA(IA);
nA = length(IA);
A = zeros(nA,maxLen);
for i = 1:nA
    A(i,1:lenA(i)) = reshape(fgA.fibers{i},1,[]);
end

% convert fgB to mat
lenB = lenB(IB);
nB = length(IB);
B = zeros(nB,maxLen);
for i = 1:nB
    B(i,1:lenB(i)) = reshape(fgB.fibers{i},1,[]);
end

% Match in the raw direction
[~,ia,ib]  = intersect(A, B,'rows');

% reverse the fiber and re-match them
if bidir
    if nA < nB
        for i = 1:nA

            A(i,1:lenA(i)) = reshape(fliplr(fgA.fibers{i}),1,[]);
        end
    else
        for i = 1:nB
            B(i,1:lenB(i)) = reshape(fliplr(fgB.fibers{i}),1,[]);
        end
    end
    
    % match in the reverse direction
    [~,r_ia,r_ib]  = intersect(A, B,'rows');
    ia = vertcat(ia,r_ia);
    ib = vertcat(ib,r_ib);
end

IA = IA(ia);
IB = IB(ib);

