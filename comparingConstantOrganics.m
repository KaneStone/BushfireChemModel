%% plotting constant organics seasonality

clear all
inputs = runinputs;
inputs.fluxcorrections = 0;
inputs.altitude = 19;
% Read in profiles then select by layer
[atmosphere,variables] = initializevars(inputs);


d.pyrocb = load([inputs.outputdir,'runoutput/','constantlinearnomix','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours.mat']);

d.control = load([inputs.outputdir,'runoutput/','constantcontrol','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours.mat']);

%%
%convert to ppm.
k=1.38066e-23;
HCLppb = k./1e-6.*d.pyrocb.dayAverage.HCL./6500.*214.*1e9;
HCLppbcontrol = k./1e-6.*d.control.dayAverage.HCL./6500.*214.*1e9;

CLONO2ppb = k./1e-6.*d.pyrocb.dayAverage.CLONO2./6500.*214.*1e9;
CLONO2ppbcontrol = k./1e-6.*d.control.dayAverage.CLONO2./6500.*214.*1e9;
%atmosphere.dummyH2O.*inputs.k.*1e6./(atmosphere.atLevel.P.*100).*atmosphere.atLevel.T;
% nd = 1./k*1e-6.*data(i).data.(vartemp).*data2(i).pressure./data(i).data.T;
% ppb = nd.*k./1e-6./pressure.*temperature
tick = monthtick('long','short');
createfig('medium','on')
plot(HCLppb - HCLppbcontrol,'LineWidth',3);
hold on
plot(CLONO2ppb - CLONO2ppbcontrol,'LineWidth',3);
plot([0 731], [0,0],'k--')
plot([366 366], [-.5,.5],'k--')
set(gca,'xtick',[tick.tick(1:3:end),tick.tick(1:3:end)+365],'xticklabel',[tick.monthnames(1:3:end),tick.monthnames(1:3:end)])
legend('HCL','CLONO2','box','off','fontsize',20);
ylim([-.5 .5])
xlim([0 731])
addLabels(18,'Seasonality of enhanced HCl het. chem','Month','ppb anomaly');

savefigure('/Users/kanestone/Dropbox (MIT)/Work_Share/meetingsPresentations/HarvardSeminar2024/newfigures/','seasonality_midlats',1,0,0,0);
