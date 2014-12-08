% function of coarse to fine scheme of lucas-kanade
function [u,v,warpI2]=coarse2fine_lk(im1,im2,nlevels, winsize, medfiltSize, nIterations)

if ~isfloat(im1)
    im1 = im2double(im1);
end
if ~isfloat(im2)
    im2 = im2double(im2);
end

% calculate lk for coarsest level of pyramid
coarsest1 = makePyramid( im1, nlevels);
coarsest2 = makePyramid( im2, nlevels);

u0 = zeros(size(coarsest1, 1), size(coarsest1, 2));
v0 = u0;
[u,v,warpI2]=lucaskanade(coarsest1,coarsest2,u0,v0,winsize,medfiltSize,nIterations);

for m = 1:nlevels-1
    
    pyramid1 = makePyramid( im1, nlevels-m);
    pyramid2 = makePyramid( im2, nlevels-m);
    
    %     expand flow field
    u = imresize(u,2);
    v = imresize(v,2);
    
%     double all motion vectors
    u = 2*u;
    v = 2*v;
    
%     scale median filter window for pyramid size (seems to remove some
%     artifacts)
%     scalingFactor = 2^(nlevels-m-1);
%     scaledMedFilterSize = round(medfiltSize/scalingFactor);
%     if (scaledMedFilterSize<1) 
%         scaledMedFilterSize = 1;
%     end
    [u,v,warpI2]=lucaskanade(pyramid1,pyramid2,u,v,winsize,medfiltSize,nIterations);
    
end


