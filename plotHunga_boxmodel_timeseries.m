% plot box HOBR rates

inputs = runinputs;
inputs.fluxcorrections = 0;
inputs.altitude = 21;
% Read in profiles then select by layer
[atmosphere,variables] = initializevars(inputs);

% gamma_hobr Hanson control run (no Hunga)
d.control = load([inputs.outputdir,'runoutput/','control','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours.mat']);

% gamma_hobr Hanson Hunga run
d.Hunga = load([inputs.outputdir,'runoutput/','Hunga','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours.mat']);

% gamma hobr WA99 control run
d.controlWA = load([inputs.outputdir,'runoutput/','control','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_WA.mat']);

% gamma hobr WA99 Hunga run
d.HungaWA = load([inputs.outputdir,'runoutput/','Hunga','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_WA.mat']);

% gamma hcl WA99 Hunga run
d.HungaWAGHCL = load([inputs.outputdir,'runoutput/','Hunga','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_WA_ghcl.mat']);

% gamma hcl Hanson Hunga run
d.HungaGHCL = load([inputs.outputdir,'runoutput/','Hunga','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_ghca.mat']);

% Run where I turned off HOBR + HCL;
d.HunganohetHOBR = load([inputs.outputdir,'runoutput/','Hunga','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hoursno_HOBR_HCL.mat']);


controlHCLvmr = d.control.dayAverage.HCL.*inputs.k.*1e6./(atmosphere.atLevel.P(151:362).*100).*atmosphere.atLevel.T(151:362);
controlWAHCLvmr = d.controlWA.dayAverage.HCL.*inputs.k.*1e6./(atmosphere.atLevel.P(151:362).*100).*atmosphere.atLevel.T(151:362);
HungaHCLvmr = d.Hunga.dayAverage.HCL.*inputs.k.*1e6./(atmosphere.atLevel.P(151:362).*100).*atmosphere.atLevel.T(151:362);
HungaWAHCLvmr = d.HungaWA.dayAverage.HCL.*inputs.k.*1e6./(atmosphere.atLevel.P(151:362).*100).*atmosphere.atLevel.T(151:362);
HungaghclHCLvmr = d.HungaGHCL.dayAverage.HCL.*inputs.k.*1e6./(atmosphere.atLevel.P(151:362).*100).*atmosphere.atLevel.T(151:362);
HunganohetHOBRvmr = d.HunganohetHOBR.dayAverage.HCL.*inputs.k.*1e6./(atmosphere.atLevel.P(151:362).*100).*atmosphere.atLevel.T(151:362);
HungaWAGHCLvmr = d.HungaWAGHCL.dayAverage.HCL.*inputs.k.*1e6./(atmosphere.atLevel.P(151:362).*100).*atmosphere.atLevel.T(151:362);

%% plot important rates for HCL


%%

fig = figure;
set(fig,'color','white','position',[100 100 1400 900],'Visible','on');
t= tiledlayout(2,2);
title(t,['June-December, ','45',char(186),'S, 21 km, box model HOBR+HCL parameters'],'fontsize',24,'fontweight','bold')
nexttile;

lwidth = 3;
fsize = 18;
cbrew = cbrewer('qual','Set1',10);
cbrewtouse = [0	0	0
0.600000000000000	0.600000000000000	0.600000000000000
0.894117647058824	0.101960784313725	0.109803921568627
0.215686274509804	0.494117647058824	0.721568627450980
0.596078431372549	0.305882352941177	0.639215686274510
0.650980392156863	0.337254901960784	0.156862745098039
0.968627450980392	0.505882352941176	0.749019607843137];

vars = 'hetHOBR_HCL';
vartit = {'het. HOBR+HCL'};
lstyle = {'-','-','-',':','--'};

plot([189 189],[0 200],'k--','LineWidth',2)
hold on
ph(1) = plot(151:362,d.control.ratesDayAverage.(vars),...
    'LineStyle',lstyle{1},'color',cbrewtouse(1,:),'LineWidth',lwidth);

ph(2) = plot(151:362,d.controlWA.ratesDayAverage.(vars),...
    'LineStyle',':','color',cbrewtouse(2,:),'LineWidth',lwidth);
ph(3) = plot(151:362,d.Hunga.ratesDayAverage.(vars),'color',cbrewtouse(3,:),'LineWidth',lwidth);
ph(4) = plot(151:362,d.HungaWA.ratesDayAverage.(vars),'color',cbrewtouse(4,:),'LineWidth',lwidth);
ph(5) = plot(151:362,d.HungaGHCL.ratesDayAverage.(vars),'color',cbrewtouse(5,:),'LineStyle','--','LineWidth',lwidth);    
ph(6) = plot(151:362,d.HungaWAGHCL.ratesDayAverage.(vars),'color',cbrewtouse(6,:),'LineStyle','--','LineWidth',lwidth);    

lh = legend(ph,'control, Hanson gamma hobr','control, Wasch-Abbatt gamma hobr','HTHH, Hanson gamma hobr (WACCM values)','HTHH, Wasch-Abbatt gamma hobr',...
    'HTHH, Hanson gamma hcl','HTHH, Wasch-Abbatt gamma hcl','fontsize',fsize,'box','off');
set(lh,'position',[.5 .2 .3 .2])
tickout = monthtick('short',0);
set(gca,'xtick',tickout.tick(6:end),'xticklabels',tickout.monthnames(6:end),'fontsize',fsize);
addLabels(fsize,'het HOBR+HCL reaction rates','Month','molecules/cm^3/s')
xlim([150 363])
nexttile;
plot([189 189],[1e-6 .1],'k--','LineWidth',2)
hold on
plot(151:362,d.control.ratesDayAverage.gprob_hobr_hcl,...
    'LineStyle',lstyle{1},'color',cbrewtouse(1,:),'LineWidth',lwidth);

plot(151:362,d.controlWA.ratesDayAverage.gprob_hobr_hcl,...
    'LineStyle',':','color',cbrewtouse(2,:),'LineWidth',lwidth);
plot(151:362,d.Hunga.ratesDayAverage.gprob_hobr_hcl,'color',cbrewtouse(3,:),'LineWidth',lwidth);
plot(151:362,d.HungaWA.ratesDayAverage.gprob_hobr_hcl,'color',cbrewtouse(4,:),'LineWidth',lwidth);
plot(151:362,d.HungaGHCL.ratesDayAverage.gprob_hobr_hcl,'color',cbrewtouse(5,:),'LineStyle','--','LineWidth',lwidth);    
plot(151:362,d.HungaWAGHCL.ratesDayAverage.gprob_hobr_hcl,'color',cbrewtouse(6,:),'LineStyle','--','LineWidth',lwidth);    

% legend('control Hanson gamma hobr','control, Wasch-Abbatt gamma hobr','Hunga-Tonga, Hanson gamma hobr','Hunga-Tonga, Wasch-Abbatt gamma hobr',...
%     'Hunga-Tonga, Hanson gamma hcl','fontsize',fsize,'box','off','location','southeast')
tickout = monthtick('short',0);
set(gca,'xtick',tickout.tick(6:end),'xticklabels',tickout.monthnames(6:end),'fontsize',fsize,...
    'Yscale','log');
addLabels(fsize,'gamma hobr (hcl)','Month','Reaction probability')
xlim([150 363])
nexttile;
plot([189 189],[-.2 .05],'k--','LineWidth',2)
hold on
plot(151:362,(HungaHCLvmr - controlHCLvmr).*1e9,...
    'LineStyle',lstyle{1},'color',cbrewtouse(3,:),'LineWidth',lwidth);
ylim([-.2 .05]);

plot(151:362,(HungaWAHCLvmr - controlWAHCLvmr).*1e9,'color',cbrewtouse(4,:),'LineWidth',lwidth);
plot(151:362,(HungaghclHCLvmr - controlHCLvmr).*1e9,'color',cbrewtouse(5,:),'LineStyle','--','LineWidth',lwidth);    
plot(151:362,(HungaWAGHCLvmr - controlWAHCLvmr).*1e9,'color',cbrewtouse(6,:),'LineStyle','--','LineWidth',lwidth);    

tickout = monthtick('short',0);
set(gca,'xtick',tickout.tick(6:end),'xticklabels',tickout.monthnames(6:end),'fontsize',fsize);
addLabels(fsize,'HCL anomaly from control','Month','ppb')
xlim([150 363])
%savefigure(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/HungaTonga/'],['HungaTonga_gammaAnalysis'],1,0,0,0);

