function [inputs] = Minputs

    % time
    inputs.year = 2020;
    inputs.hourstep = 20/60; %1/60;            %2 hour time step .015625
    inputs.secondstep = inputs.hourstep.*60.*60;    
    %inputs.secondstep = 24.*60.*60;    
    inputs.runlength = 1;%25/365;           %years
    inputs.timesteps = 365*24/inputs.hourstep*inputs.runlength;
    inputs.days = 365.*inputs.runlength;
    
    % height
    inputs.altitude = 20; % altitude to analyse in km    
    % location
    inputs.region = 'midlatitudes';
    inputs.HCLSolubility = 'solubility';
    switch inputs.region
        case 'midlatitudes'
            inputs.latitude = -45;
            inputs.longitude = -180;
            inputs.ancildir = '/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushChemModel/Ancil/variables/';
        case 'polar'
            inputs.latitude = -80;
            inputs.longitude = -180;
    end
    
    % photochemistry    
    inputs.wavelength = 200:400;
    
    % physics
    inputs.k = 1.38066e-23; % boltzmann's
    inputs.earthradius = 6371e3;
    inputs.temperature_surface = 288.15; 
    inputs.pressure_surface = 1013.25; 
    inputs.Rd = 287; 
    inputs.g0 = 9.8066;
    
    % photolysis only and save
    inputs.photosave = 0;
    inputs.whichphoto = 'load'; % load, inter
    
    
end