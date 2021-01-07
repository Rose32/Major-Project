% This Script Extracts LBPFeatures of original image and noise image saves them as
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
LBPFeatureMATDir = strcat('LBPFeatures',Separator);
LBPFeatureTXTDir = strcat('LBPFeatures-text',Separator);
    

Models = dir('ImageIndex');       
Models = Models(3:numel(Models));        %The Models in the database
NumOfModels = numel(Models);             %Total number of models


for i = [3] % for iPhone 4 and Note 8 %for backward processing on second matlab
    tic
    load(strcat(RootDir,'ImageIndex',Separator,Models(i).name))
    %The loaded Workspace variable has Name 'SaveTable'.
    ImageData = table2struct(SaveTable);
    NumOfImages = numel(ImageData);         %Number Of images
  
    Features = zeros( NumOfImages, 236 );  %Placeholder for image features
    CurrentModel = Models(i).name(1:numel(Models(i).name) - 4);     
    % -4 is to remove the trailing '.mat' from the names.
    
    parfor j = 1:NumOfImages
        tic
        ImageName = ImageData(j).name;
        ImageClass = ImageData(j).model;
        ImagePath = ImageData(j).path;
        Image = imread(char(strcat(ImageDir, ImagePath, ImageName) ) );
        Noise = imread(char(strcat(NoiseDir, ImagePath, ImageName) ) );

        Features(j,:) = [ extract_lbp(Image) extract_lbp(Noise) ];
        
        
        fprintf('Model:%s %d . Image:%d / %d \r', CurrentModel, i, j, NumOfImages)
        toc
    end
    
    save( char(strcat(LBPFeatureMATDir,CurrentModel,'.mat')), 'Features');
    dlmwrite(char(strcat(LBPFeatureTXTDir,CurrentModel,'.txt')),Features );
    
end
