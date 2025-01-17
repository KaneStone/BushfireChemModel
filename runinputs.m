function [inputs,vars] = runinputs
    
    % BEGIN USER INPUTS
    
    % base vars
    vars = {'O','O3','O1D','CLONO2','HCL','HOCL','CLO','CL2',...
        'CL2O2','OCLO','CL','BRCL','NO2','NO','NO3','N2O5',...
        'HO2NO2','OH','HO2','H2O2','HNO3','BRO','HOBR','HBR','BRONO2','BR'};
    
    % time
    inputs.startdate = '1-Jan-2017'; %2017 is chosen to have a 365 day year 
    inputs.hourstep = 30/60;           
    inputs.runlength = 1; %years    
            
    % height
    inputs.altitude = 19; % altitude to analyse in km    
    
    % location
    inputs.region = 'midlatitudes';    
    switch inputs.region
        case 'midlatitudes'
            inputs.latitude = -45;
            inputs.longitude = -180;
            inputs.ancildir = 'input/';            
            inputs.hemisphere = 'S';
        case 'polar'
            inputs.latitude = -80;
            inputs.longitude = -180;
            inputs.hemisphere = 'S';
        case 'equator'
            inputs.latitude = 0;
            inputs.longitude = -180;
            inputs.hemisphere = 'NS';
            inputs.ancildir = 'input/';  
    end   
    
    % physics
    inputs.k = 1.38065e-23; % boltzmann's (J/K)
    inputs.R = 8.31; % gas constant (J/mol/K);
    
    % photolysis only and save    
    inputs.whichphoto = 'load'; % load, inter (use inter only if need rates for different latitude)
    inputs.normalizedaylength = 0; % normalize photolysis to have same day length throughout year
    inputs.normalizeintensity = 0; % normalize photolysis to have same day intensity throughout the year
    
    %solver
    inputs.evolvingJ = 0;    
    inputs.maxiterations = 50; % solver will throw error if more than max
    
    % heterogeneous chemistry
    inputs.runtype = 'constantlinearnomix'; %'control','solubility','doublelinear',
    % 'ghcl','Hunga','constantdoublelinear','glassy','linearnomix','controllinearnomix',constantlinearnomix,'controldoublelinear','assumedhetchem'
    inputs.radius = 'ancil'; % ancil reads yearly average radius from CARMA ancil (standard is 1e-5 cm)
    inputs.HOBR = 'Hanson'; % Hanson or WA
    inputs.ghobr = 'ghobr'; % ghcl or ghobr
    % modules
    % adds in CH2O, CH3O2, CH3OH and CH3OOH.
    % may need to shorten time step.
    inputs.methanechemistry = 0; 
    
    % flux corrections (to relax back to climatology). Be very careful when
    % using this for sensitivity simulations.
    inputs.fluxcorrections = 0;
    
    % outputs
    inputs.outputrates = 1;
    inputs.savedata = 1;    
    inputs.outputdir = 'output/';
    inputs.saveext = ''; % extension for saving when producing debug output %_jCLONO2only_equinox
    
    %diagnostics
    inputs.plotdiurnal = 0;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % END USER INPUTS. Do not alter anything below here    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    inputs.secondstep = inputs.hourstep.*60.*60;            
    inputs.timesteps = 365*24/inputs.hourstep*inputs.runlength;
    inputs.days = 365.*inputs.runlength;
    [inputs.yearstart,~] = datevec(inputs.startdate);            
    dnum = datenum(inputs.startdate);
    snum = datenum([str2double(inputs.startdate(end-3:end)),1,1,0,0,0]);
    inputs.dayssincestartofyear = (dnum - snum); %used for climatology data
    inputs.stepssincestartofyear = inputs.dayssincestartofyear*24/inputs.hourstep; %used for photodata
    inputs.stepsinday = 24/inputs.hourstep;
    inputs.stepsinhour = 1/inputs.hourstep;
    
    switch inputs.whichphoto
        case 'inter'
            inputs.photosave = 1;
        otherwise
            inputs.photosave = 0;
    end
    
    if inputs.methanechemistry
        addvars = {'CH2O','CH3O2','CH3OOH','CH3OH'};
        addvarslength = length(addvars);
        varslength = length(vars);        
        vars(varslength+1:addvarslength+varslength) = addvars;
        inputs.hourstep = 5/60;     
    end
    
end