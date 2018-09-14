function bigImg = fatAddSmallImg2BigImg(bigImg,smallImg,rln)
% rln is 3x1 vector, [row,col,num]

row = rln(1);
col = rln(2);
num = rln(3);

% fprintf('(%d,%d,%d)\n', size(bigImg,1),size(smallImg,1),row);

if size(bigImg,1)/size(smallImg,1) ~= row || size(bigImg,2)/size(smallImg,2) ~= col
   error('The size of samll image is not correct')    
end

% calculate the corrsponding row and col for the small image in subimg unit
ir = ceil(num/col);
ic = mod(num,col);
if ~ic, ic = col; end

[h,w,~] = size(smallImg);

% calcaulte the index for the small image
irs = (ir-1)*h+1;
ics = (ic-1)*w+1;

bigImg(irs:(irs+h-1), ics:(ics+w-1),:) = smallImg;

