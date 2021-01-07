% %
%
% Author: Bibek Shrestha
%
% Major Project 
%
% Date: May 11. 2018
% Time : 8:17 PM
%
% Reads image names and classes from pre-structured directory hierarchy
% To be placed in same directory level as the folder 'Final-Models'.
% Saves
%           Name of all camera models.
%           Name, path, make,and model of all camera in a table as csv and .mat
%           
%     
% 
%    Dependencies:
%           None
%


Separator = '/ '; % if windows Separator = '\'
WinSep = '\';

Rootdir = pwd();
ImageIndexMATDir = strcat(Rootdir,Separator,'ImageIndex');
ImageIndexTXTDir = strcat(Rootdir,Separator,'ImageIndex-text');

Models = strings(10);           %number of Camera Models.

cd ('Final-Models');
camera_Makers = dir( );         %get list of all directories. The folder is supposed to contain only directories
camera_Makers = camera_Makers(3 :numel(camera_Makers) ); % remove the '.', and '..' directories.
numCameraMakers = size(camera_Makers);                %Total number of Makers' (or directories).
Makers = strings(numCameraMakers);                    %preallocate for Makers' (or directory) name.


TotalNumberOfModels = 0;


for i = 1:numCameraMakers 
    Makers(i) = camera_Makers(i).name;      %Name of Camera Maker
    cd( char(Makers(i)) );
    camera_Models = dir( );
    camera_Models = camera_Models(3:numel(camera_Models) );   
    Num_Models = size(camera_Models);       %similar to what is done for Makers
    Num_Models = Num_Models(1);             %because indexing in mablab is s***ty
    
    Models = strings( Num_Models );         %preallocate for modelnames
    
    for j = 1:Num_Models
        
        
        TotalNumberOfModels = TotalNumberOfModels +  1;
        
        Models(j) = camera_Models(j).name;      %name of camera model
        ModelNames(TotalNumberOfModels).Name = char(Models(j));
        
        cd( char(Models(j) ));
        Samples =  vertcat(dir( '*.jpg'), dir( '*.JPG'));       %replace by vertcat
        
        
        Num_Samples = size(Samples);        %number of images inside a model directory. (eg. 'iPhone X')
        Num_Samples = Num_Samples(1);        %because indexing in mablab is s***ty
    
        Images = struct('name',cell(1,Num_Samples),'path',cell(1,Num_Samples),'winpath', cell(1,Num_Samples),'make',cell(1,Num_Samples),'model',cell(1,Num_Samples));
        %preallocating memory for strucutre array
        for k = 1:Num_Samples
            
            Images(k).name = char(Samples(k).name);
            Images(k).path = strcat( Separator , Makers(i ), Separator, Models(j), Separator );
            Images(k).winpath = strcat( WinSep , Makers(i ), WinSep, Models(j), WinSep );
            Images(k).make = char( Makers( i ) );
            Images(k).model =  char( Models(j) );
        end
        cd('..');

        SaveTable = struct2table(Images);          %Table to save the data of single model.
        StorageLocation = strcat(ImageIndexMATDir,Separator,Models(j));
        save(strcat(StorageLocation,'.mat'),'SaveTable');
        
        StorageLocation = strcat(ImageIndexTXTDir,Separator,Models(j));        
        writetable(SaveTable,StorageLocation)
        %writetable('hey',SaveTable)
             
    end
    cd('..');
            
end
cd('..')


save('ModelNames.mat','ModelNames');
