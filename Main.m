%1d chemical equilibrium model for the lower stratosphere

clear variables

% style guide
% UPPERCASE = constants 
% lowercase = functions
% lowerCamelCase = variables
% Capitalize = structures

inputs = Minputs;

vars = {'O','O3','O1D','CLONO2','HCL','HOCL','CLO','CL2','CL2O2','OCLO','CL','BRCL'...
    ,'NO2','NO','NO3','N2O5','HO2NO2','OH','HO2','H2O2','HNO3','BRO','HOBR','HBR','BRONO2','BR'};

%% Initial concentrations
% Read in profiles then select by layer
[atmosphere,variables] = Initializevars(inputs);

%% initiate time step

switch inputs.whichphoto
    case 'load'
        photoload = load(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushChemModel/TUVoutput/',...
            num2str(inputs.altitude),'km_0.25hourstep_photo.mat']);
        photolength = size(photoload.pout,1);        
        photoout = [];
    case 'inter'
        photoload = [];
        photolength = 1;
        photoout = zeros(length(vars),inputs.timesteps,114);
end

count = 1;
daycount = 1;

tic;
flux = [];
newday = day(datetime(inputs.startdate));
kout = [];
climScaleFactor = [];
family = [];
dayAverage = [];
photoNamlist = TUVnamelist;

for i = 1:inputs.timesteps
    
    % initiate step components
    step = initializestep(inputs,i,photolength);       
            
    if inputs.photosave
        [photo,~,~] = photolysis(inputs,step,atmosphere,[],[]);
        photoout(i,:,:) = photo.dataall;
        continue
    end
    
    % run gasphaserates once per day
    if step.doy == newday        
        %kout = gasphaserates_opt2(atmosphere,step);
        kout = gasphaserates_opt(atmosphere,step);
        newday = newday+1;   
        if newday == 365
            newday = 1;
        end
    end
    
    % initiate solver
    [variables,ratesout] = raphsonnewton(inputs,i,atmosphere,step,variables,vars,photoload,kout,climScaleFactor);                        

    % Flux correction (see inputs.fluxcorrections)
    [variables,flux] = fluxcorrection(inputs,variables,flux,atmosphere,step,i);    
    
    % Calculation of chemical families (for diagostics)
    family = chemicalfamilies(variables,family,i);    
          
    % Day average calculation
    [dayAverage,daycount] = calcdayaverage(inputs,variables,dayAverage,daycount,vars,i);
        
    if i == 1001
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
vartoplot = 'NO2';
figure;
plot(variables.(vartoplot));

%%
vartoplot = 'BRONO2';
figure;
plot(dayaverage.(vartoplot));
hold on;
plot(atmosphere.atLevel.(vartoplot).nd(1:length(dayaverage.(vartoplot))))

%% setup save output
save([inputs.outputdir,'data/',inputs.runtype,'_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours_nohclflux.mat'],'variables','dayaverage');
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
