function [inputs] = Minputs

    % time
    inputs.year = 2020;
    inputs.hourstep = 15/60;           
    inputs.secondstep = inputs.hourstep.*60.*60;    
    %inputs.secondstep = 24.*60.*60;    
    inputs.runlength = 1;%25/365;           %years
    inputs.timesteps = 365*24/inputs.hourstep*inputs.runlength;
    inputs.days = 365.*inputs.runlength;
    
    % height
    inputs.altitude = 20; % altitude to analyse in km    
    % location
    inputs.region = 'midlatitudes';    
    switch inputs.region
        case 'midlatitudes'
            inputs.latitude = -45;
            inputs.longitude = -180;
            inputs.ancildir = '/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushChemModel/Ancil/';
            inputs.outputdir = '/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushChemModel/output/';
        case 'polar'
            inputs.latitude = -80;
            inputs.longitude = -180;
    end   
    
    % physics
    inputs.k = 1.38065e-23; % boltzmann's
    
    % photolysis only and save
    inputs.photosave = 0;
    inputs.whichphoto = 'load'; % load, inter
    
    %solver
    inputs.evolvingJ = 0;    
    inputs.maxiterations = 50; % solver will throw if more than max
    
    % heterogeneous chemistry
    inputs.runtype = 'control'; %'control','solubility','double linear'
    inputs.radius = 'ancil'; % ancil reads yearly average radius from CARMA ancil (standard is 1e-5 cm)
    
    % flux corrections
    inputs.fluxcorrections = 0;
    
    % plotting
    inputs.fsize = 18;
    
end