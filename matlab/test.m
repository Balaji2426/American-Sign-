clc;
img = imread('C:\Users\shakt\Pictures\cbir_database\hand.jfif');
subplot(2,2,1);
imshow(img);
%Read the image, and capture the dimensions
height = size(img,1);
width = size(img,2);
%Initialize the output images
out = img;
bin = zeros(height,width);0
%Convert the image from RGB to YCbCr
img_ycbcr = rgb2ycbcr(img);
Cb = img_ycbcr(:,:,2);
Cr = img_ycbcr(:,:,3);
%Detect Skin
[r,c,v] = find(Cb>=77 & Cb<=127 & Cr>=133 & Cr<=173);
numind = size(r,1);
%Mark Skin Pixels
for i=1:numind
    out(r(i),c(i),:) = [0 0 255];
    bin(r(i),c(i)) = 1;
end
gaus = imgaussfilt(bin,2);
bimg=im2bw(gaus,graythresh(gaus));

% binaryImage=~binaryImage;
subplot(2,2,2);
imshow(bimg);

% Displaying the boundaries of the shapes
[B, L] = bwboundaries(bimg);
figure;
imshow(bimg);
hold on;
for k=1:length(B)
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2);
end
% Using bwlabel to extract the objects, pseudocolor them and also associate
% a numerical value to them
[L, N] = bwlabel(bimg);
RGB = label2rgb(L, 'hsv', [.5 .5 .5], 'shuffle');
figure;
imshow(RGB);
hold on;
for k=1:length(B)
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2);
    text(boundary(1,2)-11, boundary(1,1)+11, num2str(k), 'Color', 'y', ...
        'FontSize', 14, 'FontWeight', 'bold');
end
% Extracting the region properties for img
stats = regionprops(L, 'all');
temp = zeros(1, N)
for k=1:N
    % Compute thinness ratio
    temp(k) = 4*pi*stats(k,1).Area / (stats(k,1).Perimeter)^2;
    stats(k,1).ThinnessRatio = temp(k);

    % Compute aspect ratio
    temp(k) = (stats(k, 1).BoundingBox(3)) / (stats(k,1).BoundingBox(4))
    stats(k,1).AspectRatio = temp(k);
end

    % For the image
    areas = zeros(1,N);
for k=1:N
    areas(k) = stats(k).Area;
end
TR = zeros(1,N);
for k=1:N
    TR(k) = stats(k).ThinnessRatio; 
end
%figure();
hold on;
cmap = colormap(lines(16));
for k=1:N
    scatter(areas(k), TR(k), [], cmap(k,:), 'filled'), ylabel('Thinness Ratio'), xlabel('Area');
    hold on; 
end
x = stats;