D = 'E:\project\cbir and img\asl';
S = dir(fullfile(D,'*.png'));
names = {'file_name'};
names{end+1} = 'Weighted_Centroid';
names{end+1} = 'ThinnessRatio';
names{end+1} = 'AspectRatio';
info_table = cell2table(cell(0, 4), 'VariableNames', names);
for k = 1:numel(S)
    F = fullfile(D,S(k).name);
    I = imread(F);
    [W, stats] = handsign(F);
    cent = stats.Centroid;
    thi_ratio = stats.ThinnessRatio;
    aspect_ratio = stats.AspectRatio;
    new_row = {S(k).name};
    new_row{end+1} = W;
    new_row{end+1} = thi_ratio;
    new_row{end+1} = aspect_ratio;
    info_table = [info_table; new_row];
    info_table(1,:).Weighted_Centroid;
end
X = 'C:\Users\shakt\Pictures\Camera Roll\test.jpg'
query_image = imread('E:\project\cbir and img\asl\Z.png');
[W_q, stats_q] = handsign(X);
th=stats_q.ThinnessRatio;
as=stats.AspectRatio;
[m,n] = size(info_table(:,1))
names1 = {'file_name'};
names1{end+1} = 'distance';
dist_table = cell2table(cell(0, 2), 'VariableNames', names1);
for y = 1:m
    W_i = info_table(y,:).Weighted_Centroid;
    %euclidean1  = pdist2(W_q,W_i);
    euclidean2  = norm(th - info_table(y,:).ThinnessRatio);
    euclidean3  = norm(as - info_table(y,:).AspectRatio);
    euclidean = euclidean2+euclidean3;%euclidean1+
    new_row = info_table(y,:).file_name;
    new_row{end+1} = euclidean;
    dist_table = [dist_table; new_row];
    
end
dist_table = sortrows(dist_table, 'distance');
