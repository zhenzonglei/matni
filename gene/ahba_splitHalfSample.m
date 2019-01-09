function [h1_idx, h2_idx] = ahba_splitHalfSample(sample_idx,donor,meth)
% split samples into two halves
% meth, 'random', 'randomwithindonor','4-2donor'
if nargin < 3, meth = '4-2donor'; end
if nargin < 2, donor = []; end

[n_sample,n_roi] = size(sample_idx);
h1_idx = false(n_sample,n_roi);
h2_idx = h1_idx;

switch meth
    case 'random'
        % split the data without taking the donor id into account
        for i = 1:n_roi
            roi_idx = sample_idx(:,i);
            roi_half_idx = splitHalfLogicalIndex(roi_idx);
            h1_idx(:,i) = roi_half_idx(:,1);
            h2_idx(:,i) = roi_half_idx(:,2);
        end
        
    case 'randomwithindonor'
        % split the data taking the donor id into account
        id = unique(donor);
        for d = 1:nnz(id)
            donor_idx = donor == id(d);
            for i = 1:n_roi
                roi_idx = sample_idx(:,i) & donor_idx;
                roi_half_idx = splitHalfLogicalIndex(roi_idx);
                h1_idx(:,i) = h1_idx(:,i) | roi_half_idx(:,1);
                h2_idx(:,i) = h2_idx(:,i) | roi_half_idx(:,2);
            end
        end
        
    case '4-2donor'
        % split the 4 donors with only LH samples in a half and
        % othere 2 donors with both LH and RH samples in another half
        h1 = donor >= 1 & donor <= 4;
        h2 = donor >= 5 & donor <= 6;
        for i = 1:n_roi
            roi_idx = sample_idx(:,i);
            h1_idx(:,i) = roi_idx & h1;
            h2_idx(:,i) = roi_idx & h2;
        end
end
end





function h_idx = splitHalfLogicalIndex(logical_idx)

h_idx = false(size(logical_idx,1),2);


idx = find(logical_idx);
N = numel(idx); % sample size
I = randperm(N);
h = idx(I(1:floor(N/2)));

h_idx(h,1) = true;
h_idx(:,2) = logical_idx - h_idx(:,1);

end

