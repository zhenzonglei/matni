function fgC = fgUnion(fgA, fgB)
% Union fgA and fgB
% Note that fgA and fgB should be from the same connectome
% IA and IB is the index vector for fgA and fgB


[~,IB] = fgIntersect(fgA, fgB);

fgB.fibers(IB) = [];

% % Create fg structure
% fgC = fgCreate;

% Set name for connectome file to save
fgA.name = [fgA.name,'_', fgB.name];
% Set fibres
fgA.fibers = cat(1,fgA.fibers,fgB.fibers);

fgC = fgA;
