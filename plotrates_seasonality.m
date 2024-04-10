clear all
inputs = runinputs;
inputs.fluxcorrections = 0;
inputs.altitude = 19;
% Read in profiles then select by layer
[atmosphere,variables] = initializevars(inputs);


d.doublelinear = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_onlyOx.mat']);

d.doublelinear1 = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_onlyHNO3_N2O5_Ox.mat']);

d.doublelinear2 = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_onlyCLONO2_Ox.mat']);

d.doublelinear3 = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_onlyCLONO2_Ox_winter.mat']);

d.doublelinear4 = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_onlyCLONO2_NO2_HNO3_N2O5_Ox.mat']);

d.doublelinear5 = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_2years.mat']);

d.control = load([inputs.outputdir,'runoutput/','control','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_2years.mat']);
%lngth = length(d.doublelinear.dayAverage.HCL);
lngth = 365;


%% plot day average variables first
lngth = 365;
vars = {'HCL','CLONO2','CLO','CL','CL2','HOCL','O3','NO2','NO','HNO3','N2O5'};
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
    ph1 = plot(1:lngth,d.control.dayAverage.(vars{i})(1:lngth),'LineWidth',lwidth);
    hold on
    ph2 = plot(1:lngth,d.doublelinear.dayAverage.(vars{i})(1:lngth),'LineWidth',lwidth);
    ph3 = plot(1:lngth,d.doublelinear1.dayAverage.(vars{i})(1:lngth),'LineWidth',lwidth);
    ph4 = plot(1:lngth,d.doublelinear2.dayAverage.(vars{i})(1:lngth),'LineWidth',lwidth);
    ph5 = plot(1:lngth,d.doublelinear3.dayAverage.(vars{i})(1:lngth),'LineWidth',lwidth);     
    ph6 = plot(1:lngth,d.doublelinear4.dayAverage.(vars{i})(1:lngth),'LineWidth',lwidth);     
    ph7 = plot(1:lngth,d.doublelinear5.dayAverage.(vars{i})(1:lngth),'LineWidth',lwidth);     
    % ph6 = plot(1:lngth,d.doublelinear5.dayAverage.(vars{i})(1:lngth),'LineWidth',lwidth);
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
lh = legend([ph1,ph2,ph3,ph4,ph5,ph6,ph7],'control','Only Ox','+HNO3+N2O5','Ox+CLONO2','Ox+CLONO2+NO2','Ox+CLONO2+NO2+HNO3+N2O5','all (double linear)','fontsize',fsize,'box','off');
set(lh,'position',[.7 .1 .2 .175])
if strcmp(vars{i},'CH4')
    legend(ph2,'CARMA CH4 (used in box model)','box', 'off')
end
savefigure(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushfireChemistry/BoxModelOutput/seasonality/'],['variables_timeseries_seasonality_analysis'],1,0,0,0);

