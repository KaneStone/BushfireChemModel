% 1d chemical equilibrium model for the lower stratosphere

clear variables

inputs = runinputs;

vars = {'O','O3','O1D','CLONO2','HCL','HOCL','CLO','CL2','CL2O2','OCLO','CL','BRCL',...
    'NO2','NO','NO3','N2O5','HO2NO2','OH','HO2','H2O2','HNO3','BRO','HOBR','HBR','BRONO2','BR'};

%% Initial concentrations
% Read in profiles then select by layer
[atmosphere,variables] = initializevars(inputs);

%% load photo data
[photoout,photoload,photolength] = loadphoto(inputs);

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
    
    % concatenate rates and calculate day average if inputs.outputrates
    if inputs.outputrates
       ratefields = fields(kv);
       for j = 1:length(ratefields)
           rates.(ratefields{j})(i) = kv.(ratefields{j});
       end
       % Day average calculation
       [ratesDayAverage,daycount2] = calcdayaverage(inputs,rates,ratesDayAverage,daycount2,ratefields,i);
    end  
    
    % debugging if statement (can remove)
    if i == 500
        a = 1;        
    end
    
    % timer (can remove)
    if i ==count*1000
        toc;
        i
        count = count + 1;
    end              
end

%% save if interactive photo
savephoto(inputs,photoout)

%% saving output
savedata(inputs,variables,dayAverage,rates,ratesDayAverage)

%% diagnostic plotting
vartoplot = 'H2O2';
figure;
plot(variables.(vartoplot));

%%
vartoplot = 'H2O2';
figure;
plot(dayAverage.(vartoplot));
hold on;
plot(atmosphere.atLevel.(vartoplot).nd(1:length(dayAverage.(vartoplot))))

%% plotting diurnal cycles for chemical families
plotdiurnalcycles(variables,inputs)
