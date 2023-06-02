% Main 2d model

% style guide
% UPPERCASE = constants 
% lowercase = functions
% lowerCamelCase = variables
% Capitalize = structures

inputs = Minputs;

%% Initial concentrations
% Read in profiles then select by layer
variables = Initializevars(inputs);
%% heterogeneous chemistry
aerosolhet(inputs,variables)
% Shi et al function code here

%% gas phase chemistry

%% photolysis