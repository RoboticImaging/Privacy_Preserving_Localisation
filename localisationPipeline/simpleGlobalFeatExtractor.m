function [feat,metric] = simpleGlobalFeatExtractor(img)
    feat = [max(double(img))', min(double(img))'];
    metric = max(double(img))'-min(double(img))';
end