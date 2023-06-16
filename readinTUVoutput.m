function [out] = readinTUVoutput(filename,startRow,endRow)

%% Initialize variables.
% startRow = 146;
% endRow = 226;

formatSpec = '%12f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%12f%10f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%11f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this code. If an error occurs for a different file, try regenerating the code from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow-startRow+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'HeaderLines', startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post processing code is included. To generate code which works for unimportable data, select unimportable cells in a file and regenerate the script.

%% Create output variable
out = [dataArray{1:end-1}];
%% Clear temporary variables
clearvars filename startRow endRow formatSpec fileID dataArray ans;
end