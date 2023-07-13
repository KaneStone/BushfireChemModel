function [out,sza] = readinTUVoutput(filename,startRow,endRow)

%% Initialize variables.
% startRow = 146;
% endRow = 226;

formatSpec = '%12f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%12f%10f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%f%[^\n\r]';
formatSpec2 = '%4s%2s%9s%1s%2s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');
fileID2 = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this code. If an error occurs for a different file, try regenerating the code from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow-startRow+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'HeaderLines', startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
szatext = textscan(fileID2, formatSpec2, 115-115+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'HeaderLines', 115-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
szatemp = szatext{6};
szatemp = szatemp{1};
ind = szatemp == '=';
ind2 = find(ind);
sza = szatemp(ind2+5:ind2+11);
sza = str2double(sza);
%% Close the text file.
fclose(fileID);
fclose(fileID2);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post processing code is included. To generate code which works for unimportable data, select unimportable cells in a file and regenerate the script.

%% Create output variable
out = [dataArray{1:end-1}];
%% Clear temporary variables
clearvars filename startRow endRow formatSpec fileID dataArray ans;
end