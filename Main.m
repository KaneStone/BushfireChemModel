% 1d chemical equilibrium model for the lower stratosphere

clear variables

inputs = Minputs;

vars = {'O','O3','O1D','CLONO2','HCL','HOCL','CLO','CL2','CL2O2','OCLO','CL','BRCL',...
    'NO2','NO','NO3','N2O5','HO2NO2','OH','HO2','H2O2','HNO3','BRO','HOBR','HBR','BRONO2','BR'};

%% Initial concentrations
% Read in profiles then select by layer
[atmosphere,variables] = Initializevars(inputs);

%% load photo data
switch inputs.whichphoto
    case 'load'
        photoload = load(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushChemModel/TUVoutput/',...
            num2str(inputs.altitude),'km_0.25hourstep_photo.mat']);
        photolength = size(photoload.pout,1);        
        photoout = [];
    case 'inter'
        photoload = [];
        photolength = 1;
        photoout = zeros(inputs.timesteps,114,91);
end

%% initialize counters and output variables
count = 1;
daycount = 1;
daycount2 = 1;
flux = [];
%newday = day(datetime(inputs.startdate));
newday = inputs.dayssincestartofyear + 1;
kout = [];
climScaleFactor = [];
family = [];
dayAverage = [];
ratesDayAverage = [];
photoNamlist = TUVnamelist;

%% Begin simulation
tic;
for i = 1:inputs.timesteps
    
    % initiate step components
    step = initializestep(inputs,i,photolength);       
            
    if inputs.photosave
        %photolysis(inputs,step,atmosphere,variables,photoload);    
        [photo,~,~] = photolysis(inputs,step,atmosphere,[],[]);
        photoout(i,:,:) = photo.dataall;
        continue
    end
    
    % run gasphaserates once per day
    if step.doy == newday                
        kout = gasphaserates(atmosphere,step);
        
        if newday == 365
            newday = 1;
        else
            newday = newday+1;   
        end
    end
    
    % initiate solver
    [variables,kv] = raphsonnewton(inputs,i,atmosphere,step,variables,vars,photoload,kout);                        
    
    % Flux correction (see inputs.fluxcorrections)
    [variables,flux] = fluxcorrection(inputs,variables,flux,atmosphere,step,i);    
    
    % Calculation of chemical families (for diagostics)
    family = chemicalfamilies(variables,family,i);    
          
    % Day average calculation
    [dayAverage,daycount] = calcdayaverage(inputs,variables,dayAverage,daycount,vars,i);
    
    % concatenate rates and calculate day average
    if inputs.outputrates
       ratefields = fields(kv);
       for j = 1:length(ratefields)
           rates.(ratefields{j})(i) = kv.(ratefields{j});
       end
       % Day average calculation
       [ratesDayAverage,daycount2] = calcdayaverage(inputs,rates,ratesDayAverage,daycount2,ratefields,i);
    end  
    
    % debugging if statement (can remove)
    if i == 100
        a = 1;        
    end
    
    % timer (can remove)
    if i ==count*1000
        toc;
        i
        count = count + 1;
    end              
end

% save photodata if running in interactive mode
if inputs.photosave
    for i = 1:size(photoout,3)
        pout = photoout(:,:,i);
        save(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushChemModel/TUVoutput/',...
            num2str(i-1),'km','_',num2str(inputs.hourstep),'hourstep','_photo.mat'],'pout')
    end
end

%% save output (variables dayAverage rates)
if inputs.savedata
    save([inputs.outputdir,'data/',inputs.runtype,'_',num2str(inputs.altitude)...
        ,'_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours.mat'],'variables','dayAverage');
end

%% diagnostic plotting
vartoplot = 'BRCL';
figure;
plot(variables.(vartoplot));

%%
vartoplot = 'CLONO2';
figure;
plot(dayAverage.(vartoplot));
hold on;
plot(atmosphere.atLevel.(vartoplot).nd(1:length(dayAverage.(vartoplot))))

% %% plot daily output
% tickout = monthtick('short',0);
% for i = 1:length(vars)
%     createfig('medium','on')
%     plot(1:365,dayaverage.(vars{i}),'LineWidth',2)
%     set(gca,'xtick',tickout.tick,'xticklabels',tickout.monthnames,'fontsize',inputs.fsize);
%     xlabel('Month','fontsize',inputs.fsize+2);
%     ylabel('Number Density (molecules cm^-^3)','fontsize',inputs.fsize+2);
%     title([inputs.runtype,', ',vars{i}],'fontsize',inputs.fsize+4);    
%     savefigure([inputs.outputdir,'figures/'],[inputs.runtype,'_',inputs.fluxcorrections,'_',vars{i},sprintf('%.2f',inputs.hourstep),'hours'],1,0,0,0);
% end
