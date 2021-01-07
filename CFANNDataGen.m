% This Script Trains and saves a SVM from CFA Dataset.
%
%
%       Dependencies: Should have extracted CFA dependency features
%                     get_CFA_Dependeancy_Feature.m
%
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


%
Models = dir('CFAFeatures/');
Models = Models(3:numel(Models));        %The Models in the database
NumOfModels = numel(Models);             %Total number of models
%Models contains the name of .mat file which in turn contains the CFA
%dependency feature of all images for that model in (n,96) array.

Targets = [];
TotalFeatures = [];
KeySet = 1:NumOfModels;
ValueSet = {};



for i = 1:NumOfModels
    
    CurrentModel = Models(i).name(1:numel(Models(i).name) - 4);
    % -4 is to remove the trailing '.mat' from the names.
    load(strcat('CFAFeatures',Separator,Models(i).name ));
    %the loaded variable name is Features.
    
    NumOfFeatures = size(Features);
    NumOfFeatures = NumOfFeatures(1);
    
    TempTargets = zeros(NumOfFeatures,NumOfModels);
    TempTargets(:,i) = 1;
    
    
    TotalFeatures = vertcat(TotalFeatures,Features);
    Targets = vertcat(Targets,TempTargets);
    ValueSet = [ValueSet,CurrentModel];
    
end


ModelMap = containers.Map(KeySet,ValueSet);
%ModelMap gives the name of the model for given index output by the NN
save('./NNData/CFAModelMap','ModelMap');
save('./NNData/CFATargets','Targets');
save('./NNData/CFATotalFeatures','TotalFeatures');





