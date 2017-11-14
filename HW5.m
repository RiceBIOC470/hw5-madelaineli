%HW5
%GB comments:
1a 70 question asks to output a file in the repository of the mask image. No image provided.
1b 100 the image produced in your script is not technically correct. You have a mask framing the image that is being treated equally to the cellular masks in the image. 
1c 70 same issues as 1a. 
1d 100 same issue has 1b
2yeast: 100
2worm: 100
2bacteria: 100
2phase: 100 
Overall: 93

% Note. You can use the code readIlastikFile.m provided in the repository to read the output from
% ilastik into MATLAB.

%% Problem 1. Starting with Ilastik

% Part 1. Use Ilastik to perform a segmentation of the image stemcells.tif
% in this folder. Be conservative about what you call background - i.e.
% don't mark something as background unless you are sure it is background.
% Output your mask into your repository. What is the main problem with your segmentation?  

% Some cells that are supposed to be separated are connected. More
% separation is needed. 
% Also, the cells are marked black, while the background is marked white. 

% Part 2. Read you segmentation mask from Part 1 into MATLAB and use
% whatever methods you can to try to improve it. 
im_seg = h5read('segmentation.h5', '/exported_data');
im_seg = squeeze(im_seg(1,:,:));
im_seg = imcomplement(im_seg);
im_seg = imerode(im_seg,strel('disk',4));
im_seg = imdilate(im_seg,strel('disk',4));
figure(1)
imshow(im_seg,[])
title('mild segregation on Ilastik');
% Part 3. Redo part 1 but now be more aggresive in defining the background.
% Try your best to use ilastik to separate cells that are touching. Output
% the resulting mask into the repository. What is the problem now?

%the resulting mask has more spikes on the cells, whose surfaces are no
%longer as smooth as the segmentation mask of the first try. Some of the
%cells on the second mask have holes in center.

% Part 4. Read your mask from Part 3 into MATLAB and try to improve
% it as best you can.
im_seg = h5read('better_segmentation.h5', '/exported_data');
im_seg = squeeze(im_seg(1,:,:));
im_seg = imfill(im_seg,'holes');
im_seg = imerode(im_seg,strel('disk',4));
im_seg = imdilate(im_seg,strel('disk',4));
figure(2)
imshow(im_seg,[])
title('aggresive segregation on Ilastik');
%% Problem 2. Segmentation problems.

% The folder segmentationData has 4 very different images. Use
% whatever tools you like to try to segement the objects the best you can. Put your code and
% output masks in the repository. If you use Ilastik as an intermediate
% step put the output from ilastik in your repository as well as an .h5
% file. Put code here that will allow for viewing of each image together
% with your final segmentation. 

% BACTERIA
mask = h5read('bacteria.h5', '/exported_data');
mask = squeeze(mask(1,:,:));
figure(3)
imshow(mask,[]);
title('binary mask for bacteria.tif');
mask = mask==2;
CC = bwconncomp(mask);
stats = regionprops(mask,'Area');
area = [stats.Area];
mean = sum(area)/length(area);
fusedCandidates = area > (mean + std(area));
sublist = CC.PixelIdxList(fusedCandidates);
sublist = cat(1,sublist{:});
fusedMask = false(size(mask));
fusedMask(sublist) = 1;

D = bwdist(~fusedMask);
D = -D;
D(~fusedMask) = -Inf;
L = watershed(D);
rgb = label2rgb(L,'jet',[.5,.5,.5]);
newNuclearMask = L>1|(mask - fusedMask);
figure(4)
imshow(newNuclearMask)
title('watershed mask for bacteria.tif');

% WORM
mask = h5read('worms.h5', '/exported_data');
mask = squeeze(mask(1,:,:));
figure(5)
imshow(mask,[]);
title('binary mask for worms.tif');
mask = mask==2;
CC = bwconncomp(mask);
stats = regionprops(mask,'Area');
area = [stats.Area];
mean = sum(area)/length(area);
fusedCandidates = area > (mean + std(area));
sublist = CC.PixelIdxList(fusedCandidates);
sublist = cat(1,sublist{:});
fusedMask = false(size(mask));
fusedMask(sublist) = 1;

D = bwdist(~fusedMask);
D = -D;
D(~fusedMask) = -Inf;
L = watershed(D);
rgb = label2rgb(L,'jet',[.5,.5,.5]);
newNuclearMask = L>1|(mask - fusedMask);
figure(6)
imshow(newNuclearMask)
title('watershed mask for worms.tif');

% YEAST
mask = h5read('yeast.h5', '/exported_data');
mask = squeeze(mask(1,:,:));
figure(7)
imshow(mask,[]);
title('binary mask for yeast.tif');
mask = mask==2;
CC = bwconncomp(mask);
stats = regionprops(mask,'Area');
area = [stats.Area];
mean = sum(area)/length(area);
fusedCandidates = area > (mean + std(area));
sublist = CC.PixelIdxList(fusedCandidates);
sublist = cat(1,sublist{:});
fusedMask = false(size(mask));
fusedMask(sublist) = 1;

D = bwdist(~fusedMask);
D = -D;
D(~fusedMask) = -Inf;
L = watershed(D);
rgb = label2rgb(L,'jet',[.5,.5,.5]);
newNuclearMask = L>1|(mask - fusedMask);
figure(8)
imshow(newNuclearMask)
title('watershed mask for yeast.tif');

% CELL PHASE CONTRAST
mask = h5read('PhaseContrast.h5', '/exported_data');
mask = squeeze(mask(1,:,:));
figure(9)
imshow(mask,[]);
title('binary mask for cellphasecontrast.tif');
mask = mask==2;
CC = bwconncomp(mask);
stats = regionprops(mask,'Area');
area = [stats.Area];
mean = sum(area)/length(area);
fusedCandidates = area > (mean + std(area));
sublist = CC.PixelIdxList(fusedCandidates);
sublist = cat(1,sublist{:});
fusedMask = false(size(mask));
fusedMask(sublist) = 1;

D = bwdist(~fusedMask);
D = -D;
D(~fusedMask) = -Inf;
L = watershed(D);
rgb = label2rgb(L,'jet',[.5,.5,.5]);
newNuclearMask = L>1|(mask - fusedMask);
figure(10)
imshow(newNuclearMask)
title('watershed mask for cellphasecontrast.tif');
