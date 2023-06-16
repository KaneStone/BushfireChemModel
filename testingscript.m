%% testing

pathToScript = fullfile(pwd,'myBashScrupt.sh');  % assumes script is in curent directory
 subject1     = 'bert';
 subject2     = 'ernie';
 cmdStr       = [pathToScript ' ' subject1 ' ' subject2];
 %%
 a = system(cmdStr);