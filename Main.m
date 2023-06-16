% Main 2d model
clear variables

% style guide
% UPPERCASE = constants 
% lowercase = functions
% lowerCamelCase = variables
% Capitalize = structures

inputs = Minputs;

%% Initial concentrations
% Read in profiles then select by layer
[atmosphere] = Initializevars(inputs);

% initialize changing variables
variables.O3 = atmosphere.atLevel.O3.nd(1);
variables.O = atmosphere.atLevel.O.nd(1);
%% initiate time step
photo = [];
rates = [];
for i = 1:inputs.days
    rates = [];
    tic
    % initialize step components
    step = initializestep(inputs,i);
    
    for j = 1:24/inputs.hourstep
        step = initializestep(inputs,j);
        [photo,TUVnamelist,rates] = photolysis(inputs,step,atmosphere,variables,j,i,photo,rates);        
    end
    
    rates.O3.destruction = mean(rates.O3.destruction);
    
    rates = gasphaserates(inputs,step,variables,atmosphere,i,rates);
    
    %if rates.destruction
    
    variables.diff(i) = (sum(rates.O3.production) - sum(rates.O3.destruction)).*inputs.secondstep;
    variables.O3(i+1) = variables.O3(i) + variables.diff(i);
%     variables.Odiff(i) = (sum(rates.O.production) - sum(rates.O.destruction)).*inputs.secondstep;
%     variables.O(i+1) = variables.O(i) + variables.Odiff(i);
    toc;
    
%     variables.O (variables.O < 0) = 0;
        
    
    if i ==10
        a = 1
    end
    clearvars rates
end

%% heterogeneous chemistry
aerosolhet(inputs,variables)
% Shi et al function code here

%% gas phase chemistry

%% photolysis