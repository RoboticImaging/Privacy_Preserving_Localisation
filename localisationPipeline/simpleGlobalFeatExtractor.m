function [feat,metric] = simpleGlobalFeatExtractor(img)
    % compute max and min of each column
    feat = [max(double(img))', min(double(img))'];
    metric = max(double(img))'-min(double(img))';
end