clear all
inputs = runinputs;
inputs.fluxcorrections = 0;
inputs.altitude = 19;
% Read in profiles then select by layer
[atmosphere,variables] = initializevars(inputs);


d.pyrocb = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours.mat']);

% d.pyrocbConstantdaylength = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
%     'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
%     ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_NOY_SummerDayLength.mat']);
% 
% d.pyrocbConstantdaylength2 = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
%     'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
%     ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_NOY_SummerIntensity.mat']);
% 
% d.pyrocbConstantdaylength3 = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
%     'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
%     ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_NOY_WinterDayLength.mat']);
% 
% d.pyrocbConstantdaylength4 = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
%     'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
%     ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_NOY_WinterIntensity.mat']);

% d.pyrocbConstantintensity = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
%     'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
%     ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_constantintensity_summer.mat']);
% 
% d.pyrocbConstantintensity2 = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
%     'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
%     ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_constantintensity_equinox.mat']);

% d.noNO2NO3 = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
%     'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
%     ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_jCLONO2_jO3O2O1D_NOy_noBRONO2HO2NO2_NO2NO3_only_summer.mat']);

% d.summerjclono2O3 = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
%     'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
%     ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_jCLONO2_jO3O1D_only_summer.mat']);

% d.summerjclono2O3HNO3 = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
%     'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
%     ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_jCLONO2_jO3O2O1D_HNO3_only_summer.mat']);

% d.summerallNOy = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
%     'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
%     ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_jCLONO2_jO3O2O1D_NOy_noBRONO2HO2NO2_only_summer.mat']);



% d.doublelinear4 = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
%     'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
%     ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_allexceptCLONO2_summer.mat']);
% 
% d.doublelinear5 = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
%     'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
%     ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_allexceptHNO3_summer.mat']);
% 
% d.doublelinear6 = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
%     'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
%     ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_allexceptCLONO2_O3O1D_summer.mat']);


% d.doublelinear3 = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
%     'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
%     ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_constantJ_exceptCLONO2.mat']);
% 
% d.doublelinear4 = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
%     'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
%     ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_onlyCLONO2_HNO3_HO2NO2_N2O5_NO2_NO3_Ox.mat']);
% 
% d.doublelinear5 = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
%     'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
%     ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_2years.mat']);

d.control = load([inputs.outputdir,'runoutput/','control','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_2years.mat']);
%lngth = length(d.doublelinear.dayAverage.HCL);
lngth = 365;

fi = fieldnames(d)
%% plot day average variables first
lngth = 365;
vars = {'HCL','CLONO2','CLO','CL','BR','BRCL','BRO','BRONO2','HOBR','HBR','HOCL'};
createfig('largelandscape','on')
t = tiledlayout(4,3);
fsize = 18;
title(t,'Box model, 19 km, 45S, constant T, SAD, RAD, H2O, and organics (wildfire levels)',...
    'fontsize',fsize+6,'fontweight','bold')
lwidth = 3;

tickout = monthtick('short',0);    
d.control.dayAverage.CH4 = repmat(atmosphere.atLevel.CH4.nd(1:365),1,lngth/365);
d.doublelinear.dayAverage.CH4 = repmat(atmosphere.atLevel.CH4.nd(1:365),1,lngth/365);
for i = 1:length(vars)
    nexttile;
    for j = 1:length(fi)
        ph(j) = plot(1:lngth,d.(fi{j}).dayAverage.(vars{i})(1:lngth),'LineWidth',lwidth);
        hold on
    end
    % ph2 = plot(1:lngth,d.doublelinear.dayAverage.(vars{i})(1:lngth),'LineWidth',lwidth);
    % ph3 = plot(1:lngth,d.doublelinear1.dayAverage.(vars{i})(1:lngth),'LineWidth',lwidth);
    % ph4 = plot(1:lngth,d.doublelinear2.dayAverage.(vars{i})(1:lngth),'LineWidth',lwidth);
    % ph5 = plot(1:lngth,d.doublelinear3.dayAverage.(vars{i})(1:lngth),'LineWidth',lwidth);     
    % ph6 = plot(1:lngth,d.doublelinear4.dayAverage.(vars{i})(1:lngth),'LineWidth',lwidth);     
    % ph7 = plot(1:lngth,d.doublelinear5.dayAverage.(vars{i})(1:lngth),'LineWidth',lwidth);     
    % ph8 = plot(1:lngth,d.doublelinear6.dayAverage.(vars{i})(1:lngth),'LineWidth',lwidth);
    % ph7 = plot(1:lngth,d.doublelinear6.dayAverage.(vars{i})(1:lngth),'LineWidth',lwidth);

    set(gca,'xtick',[tickout.tick(1:3:12),tickout.tick(1:3:12)+365],'xticklabels',[tickout.monthnames(1:3:12),tickout.monthnames(1:3:12)],'fontsize',fsize);
    if i == 10 
        addLabels(fsize,vars{i},'Month','molec./cm^3/s')
    elseif i > 10
        addLabels(fsize,vars{i},'Month','')
    elseif i == 1 || i == 4 || i == 7
        addLabels(fsize,vars{i},'','molec./cm^3/s')
    else
        addLabels(fsize,vars{i},'','')
    end        
end
set(gca,'color','none')

%lh = legend([ph1,ph2,ph3,ph4,ph5,ph6],'control','Only Ox','+HNO3+N2O5','+CLONO2','all (double linear)','fontsize',fsize,'box','off','location','south');
%lh = legend([ph1,ph2,ph3,ph4,ph5,ph6,ph7],'control','Only Ox','+HNO3+N2O5','Ox+CLONO2','CLONO2 only','Ox+CLONO2+NO2+HNO3+N2O5','all (double linear)','fontsize',fsize,'box','off');
%lh = legend(ph,fi,'fontsize',fsize,'box','off');
lh = legend(ph,'pyroCB conditions','pyroCB conditions and constant summer day length','pyroCB conditions and constant winter day length','pyroCB conditions and constant summer intensity','pyroCB conditions and constant winter intensity','Control','fontsize',fsize,'box','off');
set(lh,'position',[.65 .1 .2 .175])
if strcmp(vars{i},'CH4')
    legend(ph2,'CARMA CH4 (used in box model)','box', 'off')
end
savefigure(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushfireChemistry/BoxModelOutput/seasonality/'],['variables_timeseries_seasonality_analysis'],1,0,0,0);

%% plot rates over a course of a day in summer and winter
d.pyrocb.rates.jCLONO2 = d.pyrocb.rates.jCLONO2_CL_NO3+d.pyrocb.rates.jCLONO2_CLO_NO2;

createfig('medium','on')
tiledlayout(2,2)
nexttile;
plot(d.pyrocb.rates.CLO_NO2_M(97:97+95));
hold on
plot(d.pyrocb.rates.CLO_NO2_M(17281:17281+95));
plot(d.pyrocb.rates.CLO_NO2_M(8641:8641+95))

nexttile;
plot(d.pyrocb.rates.jCLONO2(97:97+95));
hold on
plot(d.pyrocb.rates.jCLONO2(17281:17281+95));
plot(d.pyrocb.rates.jCLONO2(8641:8641+95))

%% plot all HCL production and loss
%HCL production 
run = 'pyrocb'
lngth = 365
prodratevars = {'CL_CH4','CLO_OHb','HOCL_CL','CL_CH2O','CL_HO2a','CL_H2','CL_H2O2'};
desratevars = {'HCL_OH','HCL_O1D','HCL_O','hetCLONO2_HCL','hetHOBR_HCL','hetHOCL_HCL','jHCL_CL_H'};
createfig('large','on')
tiledlayout(2,2);
nexttile;
prodsum = 0;
dessum = 0;
for i = 1:length(prodratevars)
    hold on
    plot(d.(run).ratesDayAverage.(prodratevars{i})(1:lngth))
    prodsum = prodsum+d.(run).ratesDayAverage.(prodratevars{i})(1:lngth);
end
nexttile;
for i = 1:length(desratevars)
    hold on
    plot(d.(run).ratesDayAverage.(desratevars{i})(1:lngth))
    dessum = dessum+d.(run).ratesDayAverage.(desratevars{i})(1:lngth);
end
nexttile; 
plot(prodsum(1:lngth));
hold on
plot(dessum(1:lngth))
legend('prod','dest')
nexttile;
plot(prodsum-dessum)

%% CLONO2
run = 'pyrocb'
d.(run).ratesDayAverage.jCLONO2 = d.(run).ratesDayAverage.jCLONO2_CL_NO3+d.(run).ratesDayAverage.jCLONO2_CLO_NO2;
lngth = 365;
prodratevars = {'CLO_NO2_M'};
desratevars = {'CLONO2_OH','CLONO2_O','CLONO2_CL','hetCLONO2_HCL','hetCLONO2_H2O','jCLONO2'};
createfig('large','on')
tiledlayout(2,2);
nexttile;
prodsum = 0;
dessum = 0;
for i = 1:length(prodratevars)
    hold on
    plot(d.(run).ratesDayAverage.(prodratevars{i})(1:lngth))
    prodsum = prodsum+d.(run).ratesDayAverage.(prodratevars{i})(1:lngth);
end
nexttile;
for i = 1:length(desratevars)
    hold on
    plot(d.(run).ratesDayAverage.(desratevars{i})(1:lngth))
    dessum = dessum+d.(run).ratesDayAverage.(desratevars{i})(1:lngth);
end
nexttile; 
plot(prodsum(1:lngth));
hold on
plot(dessum(1:lngth))
legend('prod','dest')
nexttile;
plot(prodsum-dessum)

%% production vs destruction over the course of a day

run = 'pyrocb';
tm = 96*55+1:96*55+1+95; %summer
%tm = 17281:17281+95; %winter
%tm = 7681:7681+95;%equinox
%tm = 25537:25537+95;%equino
prodratevars = {'CL_CH4','CLO_OHb','HOCL_CL','CL_CH2O','CL_HO2a','CL_H2','CL_H2O2'};
desratevars = {'HCL_OH','HCL_O1D','HCL_O','hetCLONO2_HCL','hetHOBR_HCL','hetHOCL_HCL','jHCL_CL_H'};
createfig('large','on')
tiledlayout(2,2);
nexttile;
prodsum = 0;
dessum = 0;
for i = 1:length(prodratevars)
    hold on
    plot(d.(run).rates.(prodratevars{i})(tm))
    prodsum = prodsum+d.(run).rates.(prodratevars{i})(tm);
end
nexttile;
for i = 1:length(desratevars)
    hold on
    plot(d.(run).rates.(desratevars{i})(tm))
    dessum = dessum+d.(run).rates.(desratevars{i})(tm);
end
nexttile; 
plot(prodsum);
hold on
plot(dessum)
legend('prod','dest')
nexttile;
plot(prodsum-dessum)
sum(prodsum-dessum)

%%
run = 'pyrocb';
%d.(run).ratesDayAverage.jCLONO2 = d.(run).ratesDayAverage.jCLONO2_CL_NO3+d.(run).ratesDayAverage.jCLONO2_CLO_NO2;
d.(run).rates.jCLONO2 = d.(run).rates.jCLONO2_CL_NO3+d.(run).rates.jCLONO2_CLO_NO2;
%tm = 97:97+95; %summer
tm = 17281:17281+95; %winter
%tm = 7681:7681+95;%equinox
tm2 = 25537:25537+95;%equino
prodratevars = {'CLO_NO2_M'};
desratevars = {'CLONO2_OH','CLONO2_O','CLONO2_CL','hetCLONO2_HCL','hetCLONO2_H2O','jCLONO2'};
%desratevars = {'jCLONO2'};
createfig('large','on')
tiledlayout(2,2);
nexttile;
prodsum = 0;
dessum = 0;
for i = 1:length(prodratevars)
    hold on
    plot(d.(run).rates.(prodratevars{i})(tm))
    plot(d.(run).rates.(prodratevars{i})(tm2),'--')
    prodsum = prodsum+d.(run).rates.(prodratevars{i})(tm);
    prodsum2 = prodsum+d.(run).rates.(prodratevars{i})(tm2);
end
nexttile;
for i = 1:length(desratevars)
    hold on
    plot(d.(run).rates.(desratevars{i})(tm))
    plot(d.(run).rates.(desratevars{i})(tm2),'--')
    dessum = dessum+d.(run).rates.(desratevars{i})(tm);
    dessum2 = dessum+d.(run).rates.(desratevars{i})(tm2);
end
nexttile; 
plot(prodsum);
hold on
plot(dessum)
legend('prod','dest')
nexttile;
plot(prodsum-dessum)
sum(prodsum-dessum)

%% plot both equinoxes together

%%



