function [DepthMap, GradMap] = GetDepth(I, win)
[height, width, ~] = size(I);
imsize = height*width;

GradMap = getGrad(I, win);
RoughDepthMap = 1-GradMap;

DepVec = reshape(RoughDepthMap,imsize,1);
ImVec = reshape(I,imsize,3);

A = [DepVec.^0 DepVec.^1];
w = zeros(2, 3);
tc= ['r', 'g', 'b'];
hFig = figure;
set(hFig, 'Position', [100 100 600 200])
for ind = 1:3
    w(:, ind) = A\ImVec(:,ind);
    c = zeros(1, 3);
    c(ind) = 1;
    subplot(1,3,ind), scatter(DepVec, ImVec(:, ind), 1, 'filled', 'MarkerFaceColor', c)
    hold on;
    plot(unique(sort(DepVec)), w(1, ind)+w(2, ind)*unique(sort(DepVec)), 'k-', 'LineWidth', 2);
    axis([0 1 0 1])
    hold off;
    
    title(tc(ind));
    if ind == 1
        ylabel('Intensity');
    elseif ind == 2
        xlabel('Depth');
    end
end 
ws =  tanh(4*abs(w(2,:)));
s = double(w(2,:) <= 0);

min_r_im = ws(1)*ordfilt2(abs(s(1)-I(:,:,1)),1,ones(win,win),zeros(win,win),'symmetric')+(1-ws(1));
min_g_im = ws(2)*ordfilt2(abs(s(2)-I(:,:,2)),1,ones(win,win),zeros(win,win),'symmetric')+(1-ws(2));
min_b_im = ws(3)*ordfilt2(abs(s(3)-I(:,:,3)),1,ones(win,win),zeros(win,win),'symmetric')+(1-ws(3));

rgb_im = cat(3,min_r_im, min_g_im,min_b_im);
DepthMap = min(rgb_im, [], 3);