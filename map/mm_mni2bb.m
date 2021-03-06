function bb_coords = mm_mni2bigbrain(mni_coords)
% bb_coords = mm_mni2bigbrain(mni_coords)
% Transform mni coords to bigbrain native coords using the bigbrain_to_icbm200i_lin.m
% from ftp://bigbrain.loris.ca/BigBrainRelease.2015/3D_Volumes/MNI-ICBM152_Space


bb2mni = [
    1.11953556537628 0.000689052627421916 0.243142768740654 0.26196813583374
    -0.00482605583965778 1.23097217082977 -0.125631436705589 -21.42431640625
    -0.0819356441497803 0.0534097105264664 1.43528985977173 1.33586645126343
    0                   0                  0                1];



mni_coords = [mni_coords,ones(size(mni_coords,1),1)];
bb_coords = inv(bb2mni)*mni_coords';
bb_coords = bb_coords(1:3,:)';

