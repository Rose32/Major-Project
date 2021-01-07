% This script is written to test if the order of the index of the image in
% all feature is same for all images, despite reruns of the script
% 'Filename.m'. 
%
% It better be. Else I am going to be
% in trouble.
%
% Preliminary analysis shows good results. But because of OS dependency of
% 'dir()' function, I should not run 'Filename.m' in other OSes.
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
CFAFeatureMATDir = strcat('CFAFeatures',Separator);
    

Models = dir('ImageIndex');       
Models = Models(3:numel(Models));        %The Models in the database
NumOfModels = numel(Models);             %Total number of models

Wrong = zeros(NumOfModels,10);

for i = 1:NumOfModels
    tic
    load(strcat(RootDir,'ImageIndex',Separator,Models(i).name))
    %The loaded Workspace variable has Name 'SaveTable'.
    ImageData = table2struct(SaveTable);
    NumOfImages = numel(ImageData);         %Number Of images
    
    %NumOfImages = 4
    
    CurrentModel = Models(i).name;
    load(strcat(CFAFeatureMATDir,CurrentModel));
    %Loaded In variable Features
    tic
    
    for k = 1:10
        j = randi(825);

        tic
        
        ImageName = ImageData(j).name;
        ImageClass = ImageData(j).model;
        ImagePath = ImageData(j).path;
        Image = imread(char(strcat(ImageDir, ImagePath, ImageName) ) );
        Noise = imread(char(strcat(NoiseDir, ImagePath, ImageName) ) );
        
%         
%         HSVNoise = rgb2hsv(Noise);
%         HSVImage = rgb2hsv(Image);
%     
%         HSpace = HSVImage(: , :, 1);
%         VSpace = HSVImage(: , :, 3);
%         HSpaceNoise = HSVNoise( : , : , 1);
%         VSpaceNoise = HSVNoise( : , : , 3);
%     
%         HFeature = extractLBPFeatures(HSpace);
%         VFeature = extractLBPFeatures(VSpace);
%         HFeatureNoise = extractLBPFeatures(HSpaceNoise);
%         VFeatureNoise = extractLBPFeatures(VSpaceNoise);
%         Feature = horzcat(HFeature, VFeature,HFeatureNoise, VFeatureNoise);
%       

         Feature = get_CFA_Dependeancy_Feature(Noise);
        
         A = sum(Feature == Features(j,:)) - 96
         
         if (A ~= 0)
            Wrong(i,k) = j;
         end
      
        fprintf('Model:%s %d . Image:%d / %d \r', CurrentModel, i, j, NumOfImages)
        
        toc
    end
    toc
end
