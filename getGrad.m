function [Grad] = getGrad(I, win)
r0 = 0;
r1 = 1;
Strch = @(x) (x-min(x(:))).*((r1-r0)/(max(x(:))-min(x(:)))) + r0;
I = im2double(I);
imYUV = rgb2ycbcr(I);
[Gmag, ~] = imgradient(imYUV(:,:,1), 'sobel');

radius = win;
se = strel('square', radius);

imG = imdilate(Gmag, se);
Grad = Strch(imfill(imG, 8, 'holes'));
