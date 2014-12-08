% function for lucas-kanade algorithm
function [u,v,warpI2]=lucaskanade(I1,I2,u0,v0,winsize,medfiltSize,nIterations)

% form gaussian filter
gfilter=fspecial('gaussian',winsize*2+1,winsize/2);

% INSERT YOUR CODE HERE
warpI2 = warpFL(I2, u0, v0);
u = u0;
v = v0;
    
for count=1:nIterations
    
    gray = rgb2gray(warpI2);

    % compute derivatives
    [I2x, I2y] = gradient(gray);
    It = gray-rgb2gray(I1);
    
    Ixx = I2x.*I2x;
    Ixy = I2x.*I2y;
    Iyy = I2y.*I2y;
    Ixt = I2x.*It;
    Iyt = I2y.*It;
    
    % solve the large linear system
    Ixx=imfilter(Ixx,gfilter,'same',0)+0.001;
    Ixy=imfilter(Ixy,gfilter,'same',0);
    Iyy=imfilter(Iyy,gfilter,'same',0)+0.001;
    Ixt=imfilter(Ixt,gfilter,'same',0);
    Iyt=imfilter(Iyt,gfilter,'same',0);

    % update the flow field and warp image
    for i=1:size(I2, 1)
        for j=1:size(I2, 2)
            M = -inv([Ixx(i, j) Ixy(i, j); Ixy(i, j) Iyy(i, j)])*[Ixt(i, j); Iyt(i, j)];
            u(i,j) = u(i,j)+M(1);
            v(i,j) = v(i,j)+M(2);
        end
    end
    
    % median filtering is needed
    if medfiltSize > 0
        u = medfilt2(u,[medfiltSize, medfiltSize]);
        v = medfilt2(v,[medfiltSize,medfiltSize]);
    end
    
    warpI2 = warpFL(I2, u, v);

end
