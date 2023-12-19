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
variables.O3 = 0;
variables.CLONO2 = atmosphere.atLevel.CLONO2.nd(1);
%variables.CLONO2  = 0;
variables.HCL = atmosphere.atLevel.HCL.nd(1);
variables.CL2 = atmosphere.atLevel.CL2.nd(1);
variables.CL = 0;%atmosphere.atLevel.CL.nd(1);
variables.CL2O2 = atmosphere.atLevel.CL2O2.nd(1);
variables.HOCL = atmosphere.atLevel.HOCL.nd(1);
%variables.CLO = 0;
variables.CLO = atmosphere.atLevel.CLO.nd(1);
%variables.CLO2 = 0;
climScaleFactor = [];
dayaverage.CL(1) = atmosphere.atLevel.CL.nd(1);
%variables.O = 0;
%variables.O = atmosphere.atLevel.O.nd(1);

variables_be = variables;
variables_be.O3 = atmosphere.atLevel.O3.nd(1);
variables_be.CL = atmosphere.atLevel.CL.nd(1);

variables_lst = variables_be;
variables_lst.O3 = 0;

vars = {'O3','CLONO2','HCL','HOCL','CLO','CL2','CL2O2','CL'};
%% initiate time step
photo = [];
rates = [];

switch inputs.whichphoto
    case 'load'
        photoload = load(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushChemModel/TUVoutput/',num2str(inputs.altitude),'km_0.25hourstep_photo.mat']);
        photolength = size(photoload.pout,1);        
    case 'inter'
        photoload = [];
        photolength = 1;
end
count = 1;
count2 = 1;
daycount = 1;
photoout = [];
tic;
for i = 1:inputs.timesteps
    rates = [];
    
    %tic
    % initialize step components
    step = initializestep(inputs,i,photolength);       
            
    % create daily diurnal cycle for climatological species    
    if step.hour == 0
        [climScaleFactor,SZAdiff] = diurnalfromclim(inputs,i);
    end    
    
    % photolysis and gas phase (will need to add in heterogeneous here)
    %[rates,photo,photoout] = calcrates(inputs,step,atmosphere,variables,dayaverage,i,photoload,photoout,climScaleFactor,SZAdiff,0);
    
    if ~isempty(photoout)
        continue
    end
      
    
%     %if rates.destruction    
%     variables.diff(i) = (sum(rates.O3.production) - sum(rates.O3.destruction)).*inputs.secondstep;
%     variables.O3(i+1) = variables.O3(i) + variables.diff(i);
%     
%     variables.CLONO2diff(i) = (sum(rates.CLONO2.production) - sum(rates.CLONO2.destruction)).*inputs.secondstep;
%     variables.CLONO2(i+1) = variables.CLONO2(i) + variables.CLONO2diff(i);
%     
%     variables.HCLdiff(i) = (sum(rates.HCL.production) - sum(rates.HCL.destruction)).*inputs.secondstep;
%     variables.HCL(i+1) = variables.HCL(i) + variables.HCLdiff(i);
%     
%     variables.CLOdiff(i) = (sum(rates.CLO.production) - sum(rates.CLO.destruction)).*inputs.secondstep;
%     variables.CLO(i+1) = variables.CLO(i) + variables.CLOdiff(i);
%     variables.CLO (variables.CLO < 0) = 0;
%     
%     variables.CLO2(i+1) = rates.CLOtest.production;
%     
%     variables.CL2diff(i) = (sum(rates.CL2.production) - sum(rates.CL2.destruction)).*inputs.secondstep;
%     variables.CL2(i+1) = variables.CL2(i) + variables.CL2diff(i);
%     variables.CL2 (variables.CL2 < 0) = 0;
%     
%     variables.CLdiff(i) = (sum(rates.CL.production) - sum(rates.CL.destruction)).*inputs.secondstep;
%     variables.CL(i+1) = rates.CL.production(1);
%     variables.CL (variables.CL < 0) = 0;
% %     
%     variables.CL2O2diff(i) = (sum(rates.CL2O2.production) - sum(rates.CL2O2.destruction)).*inputs.secondstep;
%     variables.CL2O2(i+1) = variables.CL2O2(i) + variables.CL2O2diff(i);
%     variables.CL2O2 (variables.CL2O2 < 0) = 0;
%     
%     variables.HOCLdiff(i) = (sum(rates.HOCL.production) - sum(rates.HOCL.destruction)).*inputs.secondstep;
%     variables.HOCL(i+1) = variables.HOCL(i) + variables.HOCLdiff(i);
%     variables.HOCL (variables.HOCL < 0) = 0;
%     
%     jclo(count2) = sum(rates.CLO.destruction([1,2]))./variables.CLO(i);
    %jclo1(count2) = sum(rates.CLO.destruction([1,2]))./variables.CLO(i);
    
    % setup backwards euler
    
    % raphson newton currently doesnt work   
    variables_be = raphsonnewton(inputs,i,rates,photo,atmosphere,step,variables_be,dayaverage,vars,climScaleFactor,SZAdiff,photoload);
    %variables_lst = linsourceterm(inputs,i,rates,photo,atmosphere,step,variables_lst,dayaverage,vars,climScaleFactor,SZAdiff,photoload);
    
%     if isnan(jclo(count2))
%         jclo(count2) = 0;
%     end
% 
%     if i == daycount*24/inputs.hourstep
%         
%         dayaverage.O3(daycount) = mean(variables.O3(1+(daycount-1)*24/inputs.hourstep:daycount*24/inputs.hourstep));
%         dayaverage.CLO(daycount) = mean(variables.CLO(1+(daycount-1)*24/inputs.hourstep:daycount*24/inputs.hourstep));        
%         dayaverage.CLONO2(daycount) = mean(variables.CLONO2(1+(daycount-1)*24/inputs.hourstep:daycount*24/inputs.hourstep));        
%         dayaverage.HCL(daycount) = mean(variables.HCL(1+(daycount-1)*24/inputs.hourstep:daycount*24/inputs.hourstep));        
%         
%         d2t = 2.30e-11.*exp(-200./atmosphere.atLevel.T(step.doy)).*dayaverage.O3(daycount);
%         d3t = 2.80e-11*exp(85./atmosphere.atLevel.T(step.doy)).*atmosphere.atLevel.O.nd(step.doy);
%         d4t = 6.40e-12*exp(290./atmosphere.atLevel.T(step.doy)).*atmosphere.atLevel.NO.nd(step.doy);
%         jclo2 = mean(jclo)+3e-5;
%                
%         dayaverage.CL(daycount+1) = dayaverage.CLO(daycount)./(d2t./(d3t+d4t+jclo2+.0105));
%         dayaverage.CL22(daycount+1) = dayaverage.CL(daycount+1);
%         dayaverage.CL(daycount+1) = atmosphere.atLevel.CL.nd(step.doy+1);
% 
%         daycount = daycount+1;
%         count2 = 1;
%     end
%     count2 = count2+1;
%     
     if i == 300
         a = 1;
    end
     if i ==count*1000
         toc;
         count = count + 1;
     end
    %toc
    clearvars rates
end
if inputs.photosave
    for i = 1:size(photoout,3)
        pout = photoout(:,:,i);
        save(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushChemModel/TUVoutput/',num2str(i-1),'km','_',num2str(inputs.hourstep),'hourstep','_photo.mat'],'pout')
    end
end

% take daily averages
% timesteps er day
tstepsinday = inputs.timesteps/inputs.days;

dayaverage.O3 = mean(reshape(variables_be.O3(1,1:inputs.timesteps),[tstepsinday,inputs.days]),1,'omitnan');
dayaverage.CLO = mean(reshape(variables_be.CLO(1,1:inputs.timesteps),[tstepsinday,inputs.days]),1,'omitnan');
dayaverage.CLONO2 = mean(reshape(variables_be.CLONO2(1,1:inputs.timesteps),[tstepsinday,inputs.days]),1,'omitnan');
dayaverage.HCL = mean(reshape(variables_be.HCL(1,1:inputs.timesteps),[tstepsinday,inputs.days]),1,'omitnan');
dayaverage.CL = mean(reshape(variables_be.CL(1,1:inputs.timesteps),[tstepsinday,inputs.days]),1,'omitnan');
dayaverage.CL2 = mean(reshape(variables_be.CL2(1,1:inputs.timesteps),[tstepsinday,inputs.days]),1,'omitnan');
dayaverage.HOCL = mean(reshape(variables_be.HOCL(1,1:inputs.timesteps),[tstepsinday,inputs.days]),1,'omitnan');
dayaverage.CL2O2 = mean(reshape(variables_be.CL2O2(1,1:inputs.timesteps),[tstepsinday,inputs.days]),1,'omitnan');



%inputs.days

%% heterogeneous chemistry
aerosolhet(inputs,variables)
% Shi et al function code here

%% gas phase chemistry

%% photolysis