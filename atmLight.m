function A = atmLight(I, DepthMap)

[height, width, ~] = size(I);
imsize = width * height;
JDark = DepthMap;
numpx = floor(imsize/1000);
JDarkVec = reshape(JDark,imsize,1);
ImVec = reshape(I,imsize,3);
[~, indices] = sort(JDarkVec);
indices = indices(imsize-numpx+1:end);

Id = zeros(size(I));
for i = 1:3
    Id(:,:,i) = DepthMap;
end
A = mean(ImVec(indices(:), :));