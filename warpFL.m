% function to warp I2 to I1 according to u,v
function warpI2=warpFL(I2,u,v)
[height,width,n]=size(I2);
[xx,yy]=meshgrid(1:width,1:height);
warpI2 = zeros([height,width,n]);
for i = 1:n
    warpI2(:,:,i)=interp2(xx,yy,I2(:,:,i),xx+u,yy+v,'bicubic');
end

% remove the undefined pixels
warpI2(isnan(warpI2))=0;