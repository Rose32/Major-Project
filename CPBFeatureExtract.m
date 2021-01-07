% This Script Extracts CPFeatures of original image and noise image saves them as
% a csv file and a .mat file for each camera model.
% 
%
%
%
%       Dependencies: Should have run NoiseImageExtract for all noises.
%                     JPEG-Toolbox
%                     
%                     
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
CPBFeatureMATDir = strcat('CPBFeatures',Separator);
CPBFeatureTXTDir = strcat('CPBFeatures-text',Separator);
    

Models = dir('ImageIndex');       
Models = Models(3:numel(Models));        %The Models in the database
NumOfModels = numel(Models);             %Total number of models


for i =  [ 3] % for iPhone 4 and Note 8 %1:NumOfModels
    tic
    load(strcat(RootDir,'ImageIndex',Separator,Models(i).name))
    %The loaded Workspace variable has Name 'SaveTable'.
    ImageData = table2struct(SaveTable);
    NumOfImages = numel(ImageData);         %Number Of images
    
    %NumOfImages = 4    %To test this script.
    
    Features = zeros( NumOfImages, 144 );  %Placeholder for image features
    CurrentModel = Models(i).name(1:numel(Models(i).name) - 4);     
    % -4 is to remove the trailing '.mat' from the names.
    
    parfor j = 1:NumOfImages
        tic
        ImageName = ImageData(j).name;
        ImageClass = ImageData(j).model;
        ImagePath = ImageData(j).path;
        
        FullNoisePath = char(strcat(NoiseDir, ImagePath, ImageName) );  %mind the order of NoisePath and Image path
        FullImagePath = char(strcat(ImageDir,ImagePath, ImageName) );
        
        Features(j,:) = [get_CP_features(FullImagePath) get_CP_features(FullNoisePath)]
      
        fprintf('Model:%s %d . Image:%d / %d \r', CurrentModel, i, j, NumOfImages)
        toc
    end
    
    save( char(strcat(CPBFeatureMATDir,CurrentModel,'.mat')), 'Features');
    dlmwrite(char(strcat(CPBFeatureTXTDir,CurrentModel,'.txt')),Features );
    
end