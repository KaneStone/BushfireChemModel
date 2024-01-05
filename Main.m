% Main 2d model
clear variables

% style guide
% UPPERCASE = constants 
% lowercase = functions
% lowerCamelCase = variables
% Capitalize = structures

% Need to make dummy variables for all atmospheric variables that I use. 
% Check NO reactions and HO reactions

inputs = Minputs;

vars = {'O','O3','O1D','CLONO2','HCL','HOCL','CLO','CL2','CL2O2','OCLO','CL','BRCL'...
    ,'NO2','NO','NO3','N2O5','HO2NO2','OH','HO2','H2O2','HNO3','BRO','HOBR','HBR','BRONO2','BR'};

%% Initial concentrations
% Read in profiles then select by layer
[atmosphere,variables] = Initializevars(inputs,vars);

%% initiate time step

switch inputs.whichphoto
    case 'load'
        photoload = load(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushChemModel/TUVoutput/',...
            num2str(inputs.altitude),'km_0.25hourstep_photo.mat']);
        photolength = size(photoload.pout,1);        
    case 'inter'
        photoload = [];
        photolength = 1;
        photoout = zeros(length(vars),inputs.timesteps,114); %#ok<PREALL>
end
count = 1;
daycount = 1;
photoout = [];

tic;
flux = [];
newday = 1;
kout = [];
climScaleFactor = [];
for i = 1:inputs.timesteps
    
    % initialize step components
    step = initializestep(inputs,i,photolength);       
            
    % create daily diurnal cycle for climatological species    
%     if step.hour == 0
%         [climScaleFactor,SZAdiff] = diurnalfromclim(inputs,i);
%     end    
% %     
    if inputs.photosave
        [photo,~,~] = photolysis(inputs,step,atmosphere,[],[]);
        photoout(i,:,:) = photo.dataall; %#ok<SAGROW>
        continue
    end
    
    % run gasphaserates once per day
    if step.doy == newday
        newday = newday+1;
        kout = gasphaserates_opt(atmosphere,step);
        
    end
    
    [variables,ratesout] = raphsonnewton(inputs,i,atmosphere,step,variables,vars,photoload,kout,climScaleFactor);                    
    %test(i) = ratesout.CLO_NO2_M;
    CLY(i) = variables.CLONO2(i) + variables.HCL(i) + variables.CL(i) +...
        variables.CL2(i).*2 + variables.CL2O2(i).*2 + variables.HOCL(i) + ...
        variables.BRCL(i) + variables.CLO(i) + variables.OCLO(i);

    BRY(i) = variables.BRONO2(i) + variables.HBR(i) + variables.BR(i) +...
        variables.BRCL(i) + variables.HOBR(i) + variables.BRO(i);
    
    NOY(i) = variables.BRONO2(i) + variables.CLONO2(i) + variables.HO2NO2(i) +...
        variables.NO3(i) + variables.NO(i) + variables.NO2(i) + variables.HNO3(i) + variables.N2O5(i).*2;
    
    HOY(i) = variables.HO2(i) + variables.OH(i) + variables.H2O2(i).*2 +...
        variables.HO2NO2(i) + variables.HNO3(i) + variables.HOBR(i) + variables.HOCL(i) + variables.HCL(i) + variables.HBR(i);

    [variables,flux] = fluxcorrection(inputs,variables,flux,atmosphere,step,i);    
    
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
save([inputs.outputdir,'data/',inputs.runtype,'_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours_5xSAD.mat'],'variables','dayaverage');
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
