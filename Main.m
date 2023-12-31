% Main 2d model
clear variables

% style guide
% UPPERCASE = constants 
% lowercase = functions
% lowerCamelCase = variables
% Capitalize = structures

inputs = Minputs;

vars = {'O','O3','O1D','CLONO2','HCL','HOCL','CLO','CL2','CL2O2','OCLO','CL','BRCL'...
    ,'NO2','NO','NO3','N2O5','HO2NO2','OH','HO2','H2O2','HNO3','BRO','HOBR','HBR','BRONO2','BR'}; %BRO, BRONO2, HOBR, HBR, BR

%% Initial concentrations
% Read in profiles then select by layer
[atmosphere,variables] = Initializevars(inputs,vars);

%% Look at extensive OH BR reactions and CH4 reaction
%In many cases, when the chemical lifetimes of the N chemical species (which are provided by the inverse of the eigenvalues λi of the Jacobian matrix ∂S/∂y) 
%look over NOX
%if doesnt converge half time step. If matrix is singular use another
%method
% check to see how MAM handles HNO3 in concensced phase

% NOx is too low at 20 km. OK at 25 km. and too high at 30 km??

% How can I force NOy to be converved to NOy seasonal cycle

%HOBR, BRONO2, HNO3, N2O5, HO2NO2. Figure out how to deal with HO2NO2
%photolysis and quantu, yields
%% put in OH and HO2
%% Then put in midlatitude aerosol chemistry using SAD
%% initiate time step

switch inputs.whichphoto
    case 'load'
        photoload = load(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushChemModel/TUVoutput/',...
            num2str(inputs.altitude),'km_0.25hourstep_photo.mat']);
        photolength = size(photoload.pout,1);        
    case 'inter'
        photoload = [];
        photolength = 1;
end
count = 1;
daycount = 1;
photoout = [];

%atmosphere.atLevel.T(:) = atmosphere.atLevel.T(1);
%problem with NO somehow. Calculate NO by using equilibrium.
% simulate O1D
tic;
flux = [];
for i = 1:inputs.timesteps
    
    %rates = []; %remove
    
    %tic
    % initialize step components
    step = initializestep(inputs,i,photolength);       
            
    % create daily diurnal cycle for climatological species    
    if step.hour == 0
        [climScaleFactor,SZAdiff] = diurnalfromclim(inputs,i);
    end    
    
    if ~isempty(photoout)
        continue
    end
    
    test = transport(inputs,step,atmosphere,variables,i);
    
    [variables,~] = raphsonnewton(inputs,i,atmosphere,step,variables,vars,photoload,climScaleFactor);                
    
    
    [variables,flux] = fluxcorrection(inputs,variables,flux,atmosphere,step,i);
    
%      variables.O3(i+1) = variables.O3(i+1) + test.O3;
%     variables.CLONO2(i+1) = variables.CLONO2(i+1) + test.CLONO2;
%     variables.HCL(i+1) = variables.HCL(i+1) + test.HCL;
%     variables.HNO3(i+1) = variables.HNO3(i+1) + test.HNO3;
%     variables.N2O5(i+1) = variables.N2O5(i+1) + test.N2O5;
    
    if i == daycount*24/inputs.hourstep        
        for k = 1:length(vars)
            dayaverage.(vars{k})(daycount) = mean(variables.(vars{k})(1+(daycount-1)*24/inputs.hourstep:daycount*24/inputs.hourstep));
        end        
        daycount = daycount+1;        
    end    
%     
    if i == 1000
        a = 1;        
    end
     if i ==count*1000
         toc;
         i
         count = count + 1;
     end        
end
if inputs.photosave
    for i = 1:size(photoout,3)
        pout = photoout(:,:,i);
        save(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushChemModel/TUVoutput/',...
            num2str(i-1),'km','_',num2str(inputs.hourstep),'hourstep','_photo.mat'],'pout')
    end
end

%% diagnostic plots
vartoplot = 'HO2NO2';
figure;
plot(variables.(vartoplot));

figure;
plot(dayaverage.(vartoplot));
hold on;
plot(atmosphere.atLevel.(vartoplot).nd)

%% setup save output
save([inputs.outputdir,'data/',inputs.runtype,'_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours.mat'],'variables','dayaverage');
%% plot daily output
tickout = monthtick('short',0);
for i = 1:length(vars)
    createfig('medium','on')
    plot(1:365,dayaverage.(vars{i}),'LineWidth',2)
    set(gca,'xtick',tickout.tick,'xticklabels',tickout.monthnames,'fontsize',inputs.fsize);
    xlabel('Month','fontsize',inputs.fsize+2);
    ylabel('Number Density (molecules cm^-^3)','fontsize',inputs.fsize+2);
    title([inputs.runtype,', ',vars{i}],'fontsize',inputs.fsize+4);    
    savefigure([inputs.outputdir,'figures/'],[inputs.runtype,'_',inputs.fluxcorrections,'_',vars{i},sprintf('%.2f',inputs.hourstep),'hours'],1,0,0,0);
end
