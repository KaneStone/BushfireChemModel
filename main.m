% 0d chemical equilibrium model for the lower stratosphere

clear variables

[inputs,vars] = runinputs;

%% Initial concentrations
[atmosphere,variables] = initializevars(inputs);

%% load photo data
[photoout,photoload,photolength] = loadphoto(inputs);

% photoload.pout(17521:35040,:,:) = flip(photoload.pout(1:17520,:,:),1);
% photolength = size(photoload.pout,1);
if strcmp(inputs.region,'polarwinter')
    photoload.pout(:,2:end) = 0;
end
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
% clearvars photoout;
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
        if i == 96
                a = 1;
        end

        continue
    end
    
    % run gasphaserates once per day
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
    if count == 60
        a = 60;        
    end
    
    % timer (can remove)
    if i ==count*inputs.stepsinday+1
        step.date       
        count = count + 1;
        toc
    end       
    if i == 48
        a = 1;
    end
end

%% save if interactive photo
savephoto(inputs,photoout) 

%% saving output
savedata(inputs,variables,dayAverage,family,rates,ratesDayAverage)

%% diagnostic plotting
vartoplot = 'HCL';
% figure;
% plot(variables.(vartoplot));
vmr = variables.(vartoplot).*inputs.k.*1e6./(atmosphere.atLevel.P(1).*100).*atmosphere.atLevel.T(1).*1e12;
vmr2 = dayAverage.(vartoplot).*inputs.k.*1e6./(atmosphere.atLevel.P(1).*100).*atmosphere.atLevel.T(1).*1e12;
vmr3 = ratesDayAverage.hetCLONO2_HCL.*inputs.k.*1e6./(atmosphere.atLevel.P(1).*100).*atmosphere.atLevel.T(1).*1e12;
% vmr3 = atmosphere.atLevel.(vartoplot).nd.*inputs.k.*1e6./(atmosphere.atLevel.P(1).*100).*atmosphere.atLevel.T(1).*1e12;

%
figure;
plot(vmr2);

figure;
plot(ratesDayAverage.hetCLONO2_HCL);
hold on
plot(ratesDayAverage.hetHOCL_HCL);
plot(ratesDayAverage.hetHOBR_HCL);
% plot(ratesDayAverage.hetCLONO2_HCL);

%%
cbrew = cbrewer('qual','Set1',10);
createfig('large','on')
t = tiledlayout(3,1,'tilespacing','compact');
title(t,'200 mbar, 210 K, 1.5 SAD, 15 ppm H2O, and 2 months of perpetual night','fontsize',18,'fontweight','bold')
nexttile;
plot(ratesDayAverage.hetCLONO2_HCL,'LineWidth',2,'color',cbrew(2,:));
hold on
plot(ratesDayAverage.hetCLONO2_H2O,'LineWidth',2,'color',cbrew(1,:));
plot(ratesDayAverage.hetHOCL_HCL,'LineWidth',2,'color',cbrew(4,:),'LineStyle','--');
plot(ratesDayAverage.hetHOBR_HCL,'LineWidth',2,'color',[.7 .7 .7]);
lh = legend('ClONO2 + HCl','ClONO2 + H2O','HOCl + HCl','HOBr + HCl','box','off');
addLabels(16,'het rates','','molecules/cm3/s')

nexttile;
vmr2 = dayAverage.HCL.*inputs.k.*1e6./(atmosphere.atLevel.P(1).*100).*atmosphere.atLevel.T(1).*1e12;
vmr3 = dayAverage.CL2.*inputs.k.*1e6./(atmosphere.atLevel.P(1).*100).*atmosphere.atLevel.T(1).*1e12;
plot(vmr2,'LineWidth',2,'color',cbrew(2,:));
hold on
plot(vmr3,'LineWidth',2,'color','k');
addLabels(16,'HCl','','ppt')
lh = legend('HCl','Cl2','box','off');

nexttile;
vmr2 = dayAverage.CLONO2.*inputs.k.*1e6./(atmosphere.atLevel.P(1).*100).*atmosphere.atLevel.T(1).*1e12;
vmr3 = dayAverage.HOCL.*inputs.k.*1e6./(atmosphere.atLevel.P(1).*100).*atmosphere.atLevel.T(1).*1e12;
plot(vmr2,'LineWidth',2,'color',cbrew(2,:));
hold on
plot(vmr3,'LineWidth',2,'color',cbrew(4,:),'LineStyle','--');
addLabels(16,'ClONO2 and HOCl','Day','ppt')
lh = legend('ClONO2','HOCl','box','off');
savefigure('/Users/kanestone/work/code/BushfireChemModel/','200mabr_cl2test',1,0,0,0);
%%
figure;
plot(variables.(vartoplot)(97:97+96));
hold on;
plot(variables.CLO(97:97+96));
plot(variables.HOCL(97:97+96));
plot(variables.CL(97:97+96));
plot(variables.CLONO2(97:97+96));
plot(variables.HCL(97:97+96));
yscale('log');
%% quick test plot
createfig('medium','on');
time = 1/96;
plot(1/96:1/96:6,vmr(1:576),'LineWidth',2);
hold on
plot(1:6,vmr2);
plot(1:6,vmr3(90:95));
%%
vartoplot = 'HCL';
figure;
plot(dayAverage.(vartoplot));
hold on;
plot(atmosphere.atLevel.(vartoplot).nd(1:length(dayAverage.(vartoplot))))

%% plotting diurnal cycles for chemical families
plotdiurnalcycles(variables,inputs)
