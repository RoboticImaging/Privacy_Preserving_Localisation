clear
clc



files = dir('../data/min_cloudy1/png/');

j = 1;

for id = 1:length(files)
    % Get the file name 
    [~, f,ext] = fileparts(files(id).name);
    if all(ext == '.png')
        rename = strcat(num2str(j),ext) ; 
        movefile([files(id).folder, '\', files(id).name], [files(id).folder, '\', rename]);
        j = j+1;
    end
end