% 1d chemical equilibrium model for the lower stratosphere

clear variables

[inputs,vars] = runinputs;

%% Initial concentrations
[atmosphere,variables] = initializevars(inputs);

%% load photo data
[photoout,photoload,photolength] = loadphoto(inputs);

%% initialize counters and output variables
count = 1;
daycount = 1;
daycount2 = 1;
flux = [];
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
    
    % currently setup to save photo if interactive photo is selected, so
    % won't run main body.
    if inputs.photosave
        %photolysis(inputs,step,atmosphere,variables,photoload);    
        [photo,~,~] = photolysis(inputs,step,atmosphere,[],[]);
        photoout(i,:,:) = photo.dataall;  

        if i ==count*inputs.stepsinday+1
            step.date       
            count = count + 1;
            toc
        end 

        continue
    end
    
    % run gasphaserates once per day0
    if step.doy == newday                
        kout = gasphaserates(inputs,atmosphere,step);
        
        if newday == 365
            newday = 1;
        else
            newday = newday+1;   
        end
    end
    
    % initiate solver
    [variables,kv] = raphsonnewton(inputs,i,atmosphere,step,variables,vars,photoload,kout);                        
    %[variables,kv] = gear(inputs,i,atmosphere,step,variables,vars,photoload,kout);                        
    
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
    if i ==count*inputs.stepsinday+1
        step.date       
        count = count + 1;
        toc
    end                  
end

%% save if interactive photo
savephoto(inputs,photoout) 

%% saving output
savedata(inputs,variables,dayAverage,family,rates,ratesDayAverage)

%% diagnostic plotting
vartoplot = 'NO2';
figure;
plot(variables.(vartoplot));

%%
vartoplot = 'CLONO2';
figure;
plot(dayAverage.(vartoplot));
hold on;
plot(atmosphere.atLevel.(vartoplot).nd(1:length(dayAverage.(vartoplot))))

%% plotting diurnal cycles for chemical families
plotdiurnalcycles(variables,inputs)
