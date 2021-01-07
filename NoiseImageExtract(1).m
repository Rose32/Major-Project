%This Script Extracts noise image from the Images present and saves them as
%JPEG photo
%       This script takes so long to compelete. so long.
%       Wait till you see CFAfeatureExtract.m
%
%
%
%       Dependencies: deNoisingFilter.m
%                     Threshold.m
%                     WaveNoise.m
%

Separator = '/';
RootDir = strcat(pwd(),Separator);      %The outermost directory of concern

Models = dir('ImageIndex');       
Models = Models(3:numel(Models));        %The Models in the database
NumOfModels = numel(Models);             %Total number of models


for i = 1:NumOfModels
    
    load(strcat(RootDir,'ImageIndex',Separator,Models(i).name))
    %The loaded Workspace variable has Name 'SaveTable'.
    ImageData = table2struct(SaveTable);
    NumOfImages = numel(ImageData);         %Number Of images
    
    parfor j = 1:NumOfImages
        tic
        ImageName = ImageData(j).name;
        ImageClass = ImageData(j).model;
        ImagePath = ImageData(j).path;
        Image = imread(char(strcat('Final-Models/', ImagePath, ImageName) ) );
        Noise = deNoisingFilter(Image);        
        imwrite( Noise, char(strcat('Noise-Images',ImagePath,ImageName)) );
        fprintf('Model:%s %d . Image:%s. %d / %d \r',Models(i).name,i, ImageName, j, NumOfImages)
        toc
    end
    
end
