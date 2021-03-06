function [data] = import_LIGO(filename,GPSTimeConvert)
%% Initialize variables.
delimiter = ' ';
startRow = 1;
endRow = inf;
%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
%   column9: double (%f)
%	column10: double (%f)
%   column11: double (%f)
%	column12: double (%f)
%   column13: double (%f)
%	column14: double (%f)
%   column15: double (%f)
%	column16: double (%f)
%   column17: double (%f)
%	column18: double (%f)
%   column19: double (%f)
%	column20: double (%f)
%   column21: double (%f)
%	column22: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true,'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end
fclose(fileID);
%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names

Mag = dataArray{:, 2};
pgm = dataArray{:, 8};
Latitude = dataArray{:, 11};
Longitude = dataArray{:, 12};
Distance = dataArray{:, 13};
Depth = dataArray{:, 14};
pgv = dataArray{:, 16};
pga = dataArray{:, 18};
pgd = dataArray{:, 20};
LockLossFlag = dataArray{:, 21};
if GPSTimeConvert == 1
    EqGPSTime = tconvert(dataArray{:, 1});
    P_GpsTime = tconvert(dataArray{:, 3});
    S_GpsTime = tconvert(dataArray{:, 4});
    r2_GpsTime = tconvert(dataArray{:, 5});
    r35_GpsTime = tconvert(dataArray{:, 6});
    r5_GpsTime = tconvert(dataArray{:, 7});
    lb_GpsTime = tconvert(dataArray{:, 9});
    ub_GpsTime = tconvert(dataArray{:, 10});
    pgv_GpsTime = tconvert(dataArray{:, 15});
    pga_GpsTime = tconvert(dataArray{:, 17});
    pgd_GpsTime = tconvert(dataArray{:, 19});
    for ii = 1 : length(dataArray{:,22})
        if dataArray{1,22}(ii) >=0 
            LockLoss_GpsTime(ii,1) = tconvert(dataArray{1, 22}(ii));
        else
            LockLoss_GpsTime(ii,1) = dataArray{1, 22}(ii);
        end
    end
else
    EqGPSTime = dataArray{:, 1};
    P_GpsTime = dataArray{:, 3};
    S_GpsTime = dataArray{:, 4};
    r2_GpsTime = dataArray{:, 5};
    r35_GpsTime = dataArray{:, 6};
    r5_GpsTime = dataArray{:, 7};
    lb_GpsTime = dataArray{:, 9};
    ub_GpsTime = dataArray{:, 10};
    pgv_GpsTime = dataArray{:, 15};
    pga_GpsTime = dataArray{:, 17};
    pgd_GpsTime = dataArray{:, 19};
    LockLoss_GpsTime(:,1) = dataArray{:, 22};
end
data = [EqGPSTime, Mag, P_GpsTime, S_GpsTime, r2_GpsTime, r35_GpsTime, ...
    r5_GpsTime, pgm, lb_GpsTime,ub_GpsTime,Latitude,Longitude,Distance,...
    Depth, pgv_GpsTime, pgv, pga_GpsTime, pga, pgd_GpsTime, pgd, ...
    LockLossFlag, LockLoss_GpsTime];