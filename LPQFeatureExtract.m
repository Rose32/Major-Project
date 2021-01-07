% This Script Extracts LPQFeatures of original image and noise image saves them as
% a csv file and a .mat file for each camera model.
% 
%
%
%
%       Dependencies: Should have run NoiseImageExtract for all noises.
%                     deNoisingFilter.m
%                     Threshold.m
%                     WaveNoise.m
%

OS = 'linux';

if (strcmp(OS, 'linux'))
    Separator = '/';
elseif (strcmp(OS, 'windows'))
    Separator = '\';
else
    Separator = '/';
end



RootDir = strcat(pwd(),Separator);      %The outermost directory of concern
ImageDir = strcat('Final-Models',Separator);
NoiseDir = strcat('Noise-Images',Separator);
LPQFeatureMATDir = strcat('LPQFeatures',Separator);
LPQFeatureTXTDir = strcat('LPQFeatures-text',Separator);
    

Models = dir('ImageIndex');       
Models = Models(3:numel(Models));        %The Models in the database
NumOfModels = numel(Models);             %Total number of models


for i = 2 %1:NumOfModels % hijo Oneplus ko database update vayenaxa.
    
    
    if i == 3 || i == 6 || i == 5
        continue        %skip Alina dd ko, SM-950F and iPhone 4 for now
    end
    
    load(strcat(RootDir,'ImageIndex',Separator,Models(i).name))
    %Loading the image indexes.
    %The loaded Workspace variable has Name 'SaveTable'.
    ImageData = table2struct(SaveTable);
    NumOfImages = numel(ImageData);         %Number Of images
    
    %NumOfImages = 4    %To test this script.
    
    Features = zeros( NumOfImages, 1024 );  %Placeholder for image features
    CurrentModel = Models(i).name(1:numel(Models(i).name) - 4);     
    % -4 is to remove the trailing '.mat' from the names.
    
    for j = 1:NumOfImages
        tic
        
        
        ImageName = ImageData(j).name;
        ImageClass = ImageData(j).model;
        ImagePath = ImageData(j).path;
        Image = imread(char(strcat(ImageDir, ImagePath, ImageName) ) );
        Noise = imread(char(strcat(NoiseDir, ImagePath, ImageName) ) );
    
        Features(j,:) = [extract_lpq(Image) extract_lpq(Noise) ];
      
        fprintf('Model:%s %d . Image:%d / %d \r', CurrentModel, i, j, NumOfImages)
        toc
    end
    
    save( char(strcat(LPQFeatureMATDir,CurrentModel,'.mat')), 'Features');
    dlmwrite(char(strcat(LPQFeatureTXTDir,CurrentModel,'.txt')),Features );
    
end
