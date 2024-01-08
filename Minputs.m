function [inputs] = Minputs

    % time
    inputs.startdate = '1-Jan-2016'; %2019 is chosen to have a 365 day year
    inputs.hourstep = 15/60;           
    inputs.secondstep = inputs.hourstep.*60.*60;        
    inputs.runlength = 1; %years
    inputs.timesteps = 365*24/inputs.hourstep*inputs.runlength;
    inputs.days = 365.*inputs.runlength;
    [inputs.yearstart,~] = datevec(inputs.startdate);            
    dnum = datenum(inputs.startdate);
    snum = datenum([2016,1,1,0,0,0]);
    inputs.dayssincestartofyear = (dnum - snum); %used for climatology data
    inputs.stepssincestartofyear = inputs.dayssincestartofyear*24/inputs.hourstep; %used for photodata
            
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
    inputs.runtype = 'control'; %'control','solubility','doublelinear'
    inputs.radius = 'ancil'; % ancil reads yearly average radius from CARMA ancil (standard is 1e-5 cm)
    
    % flux corrections
    inputs.fluxcorrections = 0;
    
    % plotting
    inputs.fsize = 18;
    
    % end inputs. Do not alter anything below here    
    
end