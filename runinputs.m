function [inputs] = runinputs
    
    % BEGIN USER INPUTS
    
    % time
    inputs.startdate = '1-Jan-2017'; %2017 is chosen to have a 365 day year 
    inputs.hourstep = 15/60;           
    inputs.runlength = 1; %years    
            
    % height
    inputs.altitude = 18; % altitude to analyse in km    
    
    % location
    inputs.region = 'midlatitudes';    
    switch inputs.region
        case 'midlatitudes'
            inputs.latitude = -45;
            inputs.longitude = -180;
            inputs.ancildir = 'input/';
            inputs.outputdir = 'output/';
            inputs.hemisphere = 'S';
        case 'polar'
            inputs.latitude = -80;
            inputs.longitude = -180;
            inputs.hemisphere = 'S';
    end   
    
    % physics
    inputs.k = 1.38065e-23; % boltzmann's (J/K)
    inputs.R = 8.31; % gas constant (J/mol/K);
    
    % photolysis only and save    
    inputs.whichphoto = 'load'; % load, inter (use inter only if need rates for different latitude)
    
    %solver
    inputs.evolvingJ = 0;    
    inputs.maxiterations = 50; % solver will throw error if more than max
    
    % heterogeneous chemistry
    inputs.runtype = 'doublelinear'; %'control','solubility','doublelinear'
    inputs.radius = 'ancil'; % ancil reads yearly average radius from CARMA ancil (standard is 1e-5 cm)
    
    % flux corrections (to relax back to climatology). Be very careful when
    % using this for sensitivity simulations.
    inputs.fluxcorrections = 0;
    
    % outputs
    inputs.outputrates = 1;
    inputs.savedata = 1;    
    
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
    
end