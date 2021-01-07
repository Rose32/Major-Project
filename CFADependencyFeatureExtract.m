% This Script Extracts CFADependetcyFeature of  noise image and saves it as
% a csv file and a .mat file for each camera model.
% 
%       Dependencies: Should have run NoiseImageExtract for all noises.
%                     get_CFA_Dependeancy_Feature.m
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
CFAFeatureMATDir = strcat('CFAFeatures',Separator);
CFAFeatureTXTDir = strcat('CFAFeatures-text',Separator);
    

Models = dir('ImageIndex');       
Models = Models(3:numel(Models));        %The Models in the database
NumOfModels = numel(Models);             %Total number of models


for i = 2 % for OnePlus A3003 %:NumOfModels %:-1:4 %for backward processing on second matlab
    tic
    load(strcat(RootDir,'ImageIndex',Separator,Models(i).name))
    %The loaded Workspace variable has Name 'SaveTable'.
    ImageData = table2struct(SaveTable);
    NumOfImages = numel(ImageData);         %Number Of images
  
    Features = zeros( NumOfImages, 96 );  %Placeholder for image features
    CurrentModel = Models(i).name(1:numel(Models(i).name) - 4);     
    % -4 is to remove the trailing '.mat' from the names.
    
    parfor j = 1:NumOfImages
        tic
        ImageName = ImageData(j).name;
        ImageClass = ImageData(j).model;
        ImagePath = ImageData(j).path;
        %Extract image details which is same as the noise details.
        
        Noise = double(imread(char(strcat(NoiseDir, ImagePath, ImageName) ) ));
        %Read Noise image, that has been previously calculated
        
        Features(j,:) = get_CFA_Dependeancy_Feature(Noise);
        %calculate features. // need to parallelize
        %get_CFA_Dependeancy_Features
        
        fprintf('Model:%s %d . Image:%d / %d \r', CurrentModel, i, j, NumOfImages)
        toc
    end
    
    save( char(strcat(CFAFeatureMATDir,CurrentModel,'.mat')), 'Features');
    dlmwrite(char(strcat(CFAFeatureTXTDir,CurrentModel,'.txt')),Features );
    
end
