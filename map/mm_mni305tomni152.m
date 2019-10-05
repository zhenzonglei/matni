function  coords = mm_mni305tomni152(coords)
%  coords = mm_mni305tomni152(coords)
% Convert MNI305 coords to MNI152 coords


T = [0.9975 -0.0073 0.0176 -0.0429;
    0.0146 1.0009 -0.0024 1.5496;
    -0.0130 -0.0093  0.9971  1.1840;
    0       0        0        1];

coords = [coords,ones(size(coords,1),1)];
coords = inv(T)*coords';
coords = coords(1:3,:)';
