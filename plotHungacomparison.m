% plot box HOBR rates

inputs = runinputs;
inputs.fluxcorrections = 0;
inputs.altitude = 21;
% Read in profiles then select by layer
[atmosphere,variables] = initializevars(inputs);

d.control = load([inputs.outputdir,'runoutput/','control','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours.mat']);

d.Hunga = load([inputs.outputdir,'runoutput/','Hunga','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours.mat']);

d.controlWA = load([inputs.outputdir,'runoutput/','control','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_WA.mat']);

d.HungaWA = load([inputs.outputdir,'runoutput/','Hunga','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_WA.mat']);

d.HungaGHCL = load([inputs.outputdir,'runoutput/','Hunga','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_ghca.mat']);

d.HunganohetHOBR = load([inputs.outputdir,'runoutput/','Hunga','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hoursno_HOBR_HCL.mat']);

d.HunganohetHOBR_WA = load([inputs.outputdir,'runoutput/','Hunga','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hoursno_HOBR_HCL.mat']);


controlHCLvmr = d.control.dayAverage.HCL.*inputs.k.*1e6./(atmosphere.atLevel.P(151:362).*100).*atmosphere.atLevel.T(151:362);
controlWAHCLvmr = d.controlWA.dayAverage.HCL.*inputs.k.*1e6./(atmosphere.atLevel.P(151:362).*100).*atmosphere.atLevel.T(151:362);
HungaHCLvmr = d.Hunga.dayAverage.HCL.*inputs.k.*1e6./(atmosphere.atLevel.P(151:362).*100).*atmosphere.atLevel.T(151:362);
HungaWAHCLvmr = d.HungaWA.dayAverage.HCL.*inputs.k.*1e6./(atmosphere.atLevel.P(151:362).*100).*atmosphere.atLevel.T(151:362);
HungaghclHCLvmr = d.HungaGHCL.dayAverage.HCL.*inputs.k.*1e6./(atmosphere.atLevel.P(151:362).*100).*atmosphere.atLevel.T(151:362);
HunganohetHOBRvmr = d.HunganohetHOBR.dayAverage.HCL.*inputs.k.*1e6./(atmosphere.atLevel.P(151:362).*100).*atmosphere.atLevel.T(151:362);
%atmosphere.dummyH2O.*inputs.k.*1e6./(atmosphere.atLevel.P.*100).*atmosphere.atLevel.T;

%% plot important rates for HCL

createfig('large','on')
t = tiledlayout(4,3);
nexttile
ph(1) = plot(151:362,d.Hunga.ratesDayAverage.CLO_OHb - d.control.ratesDayAverage.CLO_OHb,'LineWidth',2);
hold on
ph(2) = plot(151:362,d.Hunga.ratesDayAverage.CL_CH4 - d.control.ratesDayAverage.CL_CH4,'LineWidth',2);
ph(3) = plot(151:362,-d.Hunga.ratesDayAverage.HCL_OH + d.control.ratesDayAverage.HCL_OH,'LineWidth',2);
ph(4) = plot(151:362,-d.Hunga.ratesDayAverage.hetHOBR_HCL + d.control.ratesDayAverage.hetHOBR_HCL,'LineWidth',2);
ph(5) = plot(151:362,-d.Hunga.ratesDayAverage.hetCLONO2_HCL + d.control.ratesDayAverage.hetCLONO2_HCL,'LineWidth',2);
ph(6) = plot(151:362,-d.Hunga.ratesDayAverage.hetHOCL_HCL + d.control.ratesDayAverage.hetHOCL_HCL,'LineWidth',2);
plot([189 189],[1e-5 .1],'k--','LineWidth',2)
legend(ph,'CLO+OH','CL+CH4','HCL+OH','hetHOBR+HCL','hetCLONO2+HCL','hetHOCL+HCL')

nexttile;
plot(151:362,d.Hunga.ratesDayAverage.CLO_OHb - d.control.ratesDayAverage.CLO_OHb + ...
    d.Hunga.ratesDayAverage.CL_CH4 - d.control.ratesDayAverage.CL_CH4 + ...
    -d.Hunga.ratesDayAverage.HCL_OH + d.control.ratesDayAverage.HCL_OH...
    ,'LineWidth',2);

nexttile;
plot(151:362,d.Hunga.ratesDayAverage.CLO_OHb - d.control.ratesDayAverage.CLO_OHb + ...
    d.Hunga.ratesDayAverage.CL_CH4 - d.control.ratesDayAverage.CL_CH4 + ...
    -d.Hunga.ratesDayAverage.HCL_OH + d.control.ratesDayAverage.HCL_OH + ...
    -d.Hunga.ratesDayAverage.hetHOBR_HCL + d.control.ratesDayAverage.hetHOBR_HCL,'LineWidth',2);


nexttile;
ph(1) = plot(151:362,d.HunganohetHOBR.ratesDayAverage.CLO_OHb - d.control.ratesDayAverage.CLO_OHb,'LineWidth',2);
hold on
ph(2) = plot(151:362,d.HunganohetHOBR.ratesDayAverage.CL_CH4 - d.control.ratesDayAverage.CL_CH4,'LineWidth',2);
ph(3) = plot(151:362,-d.HunganohetHOBR.ratesDayAverage.HCL_OH + d.control.ratesDayAverage.HCL_OH,'LineWidth',2);
ph(4) = plot(151:362,-d.HunganohetHOBR.ratesDayAverage.hetHOBR_HCL + d.control.ratesDayAverage.hetHOBR_HCL,'LineWidth',2);
ph(5) = plot(151:362,-d.HunganohetHOBR.ratesDayAverage.hetCLONO2_HCL + d.control.ratesDayAverage.hetCLONO2_HCL,'LineWidth',2);
ph(6) = plot(151:362,-d.HunganohetHOBR.ratesDayAverage.hetHOCL_HCL + d.control.ratesDayAverage.hetHOCL_HCL,'LineWidth',2);
plot([189 189],[1e-5 .1],'k--','LineWidth',2)
legend(ph,'CLO+OH','CL+CH4','HCL+OH','hetHOBR+HCL','hetCLONO2+HCL','hetHOCL+HCL')

nexttile;
plot(151:362,d.HunganohetHOBR.ratesDayAverage.CLO_OHb - d.control.ratesDayAverage.CLO_OHb + ...
    d.HunganohetHOBR.ratesDayAverage.CL_CH4 - d.control.ratesDayAverage.CL_CH4 + ...
    -d.HunganohetHOBR.ratesDayAverage.HCL_OH + d.control.ratesDayAverage.HCL_OH...
    ,'LineWidth',2);

nexttile;
plot(151:362,d.HunganohetHOBR.ratesDayAverage.CLO_OHb - d.control.ratesDayAverage.CLO_OHb + ...
    d.HunganohetHOBR.ratesDayAverage.CL_CH4 - d.control.ratesDayAverage.CL_CH4 + ...
    -d.HunganohetHOBR.ratesDayAverage.HCL_OH + d.control.ratesDayAverage.HCL_OH + ...
    -d.HunganohetHOBR.ratesDayAverage.hetHOBR_HCL + d.control.ratesDayAverage.hetHOBR_HCL,'LineWidth',2);

nexttile;
ph(1) = plot(151:362,d.HungaWA.ratesDayAverage.CLO_OHb - d.controlWA.ratesDayAverage.CLO_OHb,'LineWidth',2);
hold on
ph(2) = plot(151:362,d.HungaWA.ratesDayAverage.CL_CH4 - d.controlWA.ratesDayAverage.CL_CH4,'LineWidth',2);
ph(3) = plot(151:362,-d.HungaWA.ratesDayAverage.HCL_OH + d.controlWA.ratesDayAverage.HCL_OH,'LineWidth',2);
ph(4) = plot(151:362,-d.HungaWA.ratesDayAverage.hetHOBR_HCL + d.controlWA.ratesDayAverage.hetHOBR_HCL,'LineWidth',2);
ph(5) = plot(151:362,-d.HungaWA.ratesDayAverage.hetCLONO2_HCL + d.controlWA.ratesDayAverage.hetCLONO2_HCL,'LineWidth',2);
ph(6) = plot(151:362,-d.HungaWA.ratesDayAverage.hetHOCL_HCL + d.controlWA.ratesDayAverage.hetHOCL_HCL,'LineWidth',2);
plot([189 189],[1e-5 .1],'k--','LineWidth',2)
legend(ph,'CLO+OH','CL+CH4','HCL+OH','hetHOBR+HCL','hetCLONO2+HCL','hetHOCL+HCL')

nexttile;
plot(151:362,d.HungaWA.ratesDayAverage.CLO_OHb - d.controlWA.ratesDayAverage.CLO_OHb + ...
    d.HungaWA.ratesDayAverage.CL_CH4 - d.controlWA.ratesDayAverage.CL_CH4 + ...
    -d.HungaWA.ratesDayAverage.HCL_OH + d.controlWA.ratesDayAverage.HCL_OH...
    ,'LineWidth',2);

nexttile;
plot(151:362,d.HungaWA.ratesDayAverage.CLO_OHb - d.controlWA.ratesDayAverage.CLO_OHb + ...
    d.HungaWA.ratesDayAverage.CL_CH4 - d.controlWA.ratesDayAverage.CL_CH4 + ...
    -d.HungaWA.ratesDayAverage.HCL_OH + d.controlWA.ratesDayAverage.HCL_OH + ...
    -d.HungaWA.ratesDayAverage.hetHOBR_HCL + d.controlWA.ratesDayAverage.hetHOBR_HCL,'LineWidth',2);

nexttile;
ph(1) = plot(151:362,d.HunganohetHOBR_WA.ratesDayAverage.CLO_OHb - d.controlWA.ratesDayAverage.CLO_OHb,'LineWidth',2);
hold on
ph(2) = plot(151:362,d.HunganohetHOBR_WA.ratesDayAverage.CL_CH4 - d.controlWA.ratesDayAverage.CL_CH4,'LineWidth',2);
ph(3) = plot(151:362,-d.HunganohetHOBR_WA.ratesDayAverage.HCL_OH + d.controlWA.ratesDayAverage.HCL_OH,'LineWidth',2);
ph(4) = plot(151:362,-d.HunganohetHOBR_WA.ratesDayAverage.hetHOBR_HCL + d.controlWA.ratesDayAverage.hetHOBR_HCL,'LineWidth',2);
ph(5) = plot(151:362,-d.HunganohetHOBR_WA.ratesDayAverage.hetCLONO2_HCL + d.controlWA.ratesDayAverage.hetCLONO2_HCL,'LineWidth',2);
ph(6) = plot(151:362,-d.HunganohetHOBR_WA.ratesDayAverage.hetHOCL_HCL + d.controlWA.ratesDayAverage.hetHOCL_HCL,'LineWidth',2);
plot([189 189],[1e-5 .1],'k--','LineWidth',2)
legend(ph,'CLO+OH','CL+CH4','HCL+OH','hetHOBR+HCL','hetCLONO2+HCL','hetHOCL+HCL')

nexttile;
plot(151:362,d.HunganohetHOBR_WA.ratesDayAverage.CLO_OHb - d.controlWA.ratesDayAverage.CLO_OHb + ...
    d.HunganohetHOBR_WA.ratesDayAverage.CL_CH4 - d.controlWA.ratesDayAverage.CL_CH4 + ...
    -d.HunganohetHOBR_WA.ratesDayAverage.HCL_OH + d.controlWA.ratesDayAverage.HCL_OH...
    ,'LineWidth',2);

nexttile;
plot(151:362,d.HunganohetHOBR_WA.ratesDayAverage.CLO_OHb - d.controlWA.ratesDayAverage.CLO_OHb + ...
    d.HunganohetHOBR_WA.ratesDayAverage.CL_CH4 - d.controlWA.ratesDayAverage.CL_CH4 + ...
    -d.HunganohetHOBR_WA.ratesDayAverage.HCL_OH + d.controlWA.ratesDayAverage.HCL_OH + ...
    -d.HunganohetHOBR_WA.ratesDayAverage.hetHOBR_HCL + d.controlWA.ratesDayAverage.hetHOBR_HCL,'LineWidth',2);
%%

createfig('largelandscape','on')
t= tiledlayout(2,2)
title(t,'June-December, 45S, 21 km, box model HOBR+HCL reaction rates','fontsize',24,'fontweight','bold')
nexttile;

lwidth = 3;
fsize = 18;
cbrew = cbrewer('qual','Set1',10);
cbrewtouse = [[0 0 0];[.6 .6 .6];cbrew([1,2,4,8,9],:)];
vars = 'hetHOBR_HCL';
vartit = {'het HOBR+HCL'};
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
ph(6) = plot(151:362,d.HunganohetHOBR.ratesDayAverage.(vars),'color',cbrewtouse(6,:),'LineStyle','--','LineWidth',lwidth);    

lh = legend(ph,'control, Hanson gamma hobr','control, Wasch-Abbatt gamma hobr','Hunga-Tonga, Hanson gamma hobr (WACCM values)','Hunga-Tonga, Wasch-Abbatt gamma hobr',...
    'Hunga-Tonga, Hanson gamma hcl','Gas phase only','fontsize',fsize,'box','off');
set(lh,'position',[.5 .2 .3 .2])
tickout = monthtick('short',0);
set(gca,'xtick',tickout.tick(6:end),'xticklabels',tickout.monthnames(6:end),'fontsize',fsize);
addLabels(fsize,'het HOBR+HCL reaction rates','Month','molecules/cm^3/s')

nexttile;
plot([189 189],[1e-5 .1],'k--','LineWidth',2)
hold on
plot(151:362,d.control.ratesDayAverage.gprob_hobr_hcl,...
    'LineStyle',lstyle{1},'color',cbrewtouse(1,:),'LineWidth',lwidth);

plot(151:362,d.controlWA.ratesDayAverage.gprob_hobr_hcl,...
    'LineStyle',':','color',cbrewtouse(2,:),'LineWidth',lwidth);
plot(151:362,d.Hunga.ratesDayAverage.gprob_hobr_hcl,'color',cbrewtouse(3,:),'LineWidth',lwidth);
plot(151:362,d.HungaWA.ratesDayAverage.gprob_hobr_hcl,'color',cbrewtouse(4,:),'LineWidth',lwidth);
plot(151:362,d.HungaGHCL.ratesDayAverage.gprob_hobr_hcl,'color',cbrewtouse(5,:),'LineStyle','--','LineWidth',lwidth);    

% legend('control Hanson gamma hobr','control, Wasch-Abbatt gamma hobr','Hunga-Tonga, Hanson gamma hobr','Hunga-Tonga, Wasch-Abbatt gamma hobr',...
%     'Hunga-Tonga, Hanson gamma hcl','fontsize',fsize,'box','off','location','southeast')
tickout = monthtick('short',0);
set(gca,'xtick',tickout.tick(6:end),'xticklabels',tickout.monthnames(6:end),'fontsize',fsize,...
    'Yscale','log');
addLabels(fsize,'gamma hobr (hcl)','Month','Reaction probability')

nexttile;
plot([189 189],[-.2 .05],'k--','LineWidth',2)
hold on
plot(151:362,(HungaHCLvmr - controlHCLvmr).*1e9,...
    'LineStyle',lstyle{1},'color',cbrewtouse(3,:),'LineWidth',lwidth);
ylim([-.2 .05]);
% plot(151:362,controlWAHCLvmr,...
%     'LineStyle',lstyle{i},'color',cbrewtouse(2,:),'LineWidth',lwidth);
%plot(151:362,HungaHCLvmr,'color',cbrewtouse(3,:),'LineWidth',lwidth);
plot(151:362,(HungaWAHCLvmr - controlWAHCLvmr).*1e9,'color',cbrewtouse(4,:),'LineWidth',lwidth);
plot(151:362,(HungaghclHCLvmr - controlHCLvmr).*1e9,'color',cbrewtouse(5,:),'LineStyle','--','LineWidth',lwidth);    
plot(151:362,(HunganohetHOBRvmr - controlHCLvmr).*1e9,'color',cbrewtouse(6,:),'LineStyle','--','LineWidth',lwidth);    

% legend('Hunga-Tonga, Hanson gamma hobr','Hunga-Tonga, Wasch-Abbatt gamma hobr',...
%     'Hunga-Tonga, Hanson gamma hcl','fontsize',fsize,'box','off','location','southeast')
tickout = monthtick('short',0);
set(gca,'xtick',tickout.tick(6:end),'xticklabels',tickout.monthnames(6:end),'fontsize',fsize);
addLabels(fsize,'HCL anomaly from control','Month','ppb')

savefigure(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/HungaTonga/'],['HungaTonga_gammaAnalysis'],1,0,0,0);

%% plot HCL+OH and CH4+CL and others
createfig('largelandscape','on')
t= tiledlayout(3,2);
title(t,'June-December, 45S, 21 km, box model reaction rates','fontsize',24,'fontweight','bold')


lwidth = 3;
fsize = 18;
cbrew = cbrewer('qual','Set1',10);
cbrewtouse = [[0 0 0];[.6 .6 .6];cbrew([1,2,4,8,9],:)];
vars = {'HCL_OH','CL_CH4','CLO_OHb','hetHOBR_HCL'};
vartit = {'HCL+OH','CL+CH4','CLO+OH','het. HOBR+HCL anomaly','all gas phase HCL production/loss anomaly','all gas+het. phase HCL production/loss anomaly'};
lstyle = {'-','-','-',':','--'};
lims = [0 1500; 0 1500; 0 200; 0 200; -200 200; -200 200]

for i = 1:6



if i < 4
    nexttile;
    box on
    hold on
    plot([189 189],[lims(i,1) lims(i,2)],'k--','LineWidth',2)
    ph(1) = plot(151:362,d.control.ratesDayAverage.(vars{i}),...
        'LineStyle',lstyle{1},'color',cbrewtouse(1,:),'LineWidth',lwidth);
    
    ph(2) = plot(151:362,d.controlWA.ratesDayAverage.(vars{i}),...
        'LineStyle',':','color',cbrewtouse(2,:),'LineWidth',lwidth);
    ph(3) = plot(151:362,d.Hunga.ratesDayAverage.(vars{i}),'color',cbrewtouse(3,:),'LineWidth',lwidth);
    ph(4) = plot(151:362,d.HungaWA.ratesDayAverage.(vars{i}),'color',cbrewtouse(4,:),'LineWidth',lwidth);
    ph(5) = plot(151:362,d.HungaGHCL.ratesDayAverage.(vars{i}),'color',cbrewtouse(5,:),'LineStyle','--','LineWidth',lwidth);    
    ph(6) = plot(151:362,d.HunganohetHOBR.ratesDayAverage.(vars{i}),'color',cbrewtouse(6,:),'LineStyle','-.','LineWidth',lwidth);    
elseif i == 4
    nexttile;
    box on
    hold on
    plot([189 189],[lims(i,1) lims(i,2)],'k--','LineWidth',2)
    % ph(1) = plot(151:362,d.control.ratesDayAverage.(vars{i}),...
    %     'LineStyle',lstyle{1},'color',cbrewtouse(1,:),'LineWidth',lwidth);
    % 
    % ph(2) = plot(151:362,d.controlWA.ratesDayAverage.(vars{i}),...
    %     'LineStyle',':','color',cbrewtouse(2,:),'LineWidth',lwidth);
    plot(151:362,d.Hunga.ratesDayAverage.(vars{i})-d.control.ratesDayAverage.(vars{i}),'color',cbrewtouse(3,:),'LineWidth',lwidth);
    plot(151:362,d.HungaWA.ratesDayAverage.(vars{i})-d.controlWA.ratesDayAverage.(vars{i}),'color',cbrewtouse(4,:),'LineWidth',lwidth);
    plot(151:362,d.HungaGHCL.ratesDayAverage.(vars{i})-d.control.ratesDayAverage.(vars{i}),'color',cbrewtouse(5,:),'LineStyle','--','LineWidth',lwidth);    
elseif i == 5
    nexttile;
    hold on;
    box on
    plot([189 189],[-200 200],'k--','LineWidth',2)
    plot([151 362],[0 0],'k--','LineWidth',2)
    controlgpr = d.control.ratesDayAverage.CL_CH4+d.control.ratesDayAverage.CLO_OHb+d.control.ratesDayAverage.CL_CH2O+d.control.ratesDayAverage.CL_H2+d.control.ratesDayAverage.CL_HO2a - d.control.ratesDayAverage.HCL_OH;
    controlgpr2 = d.controlWA.ratesDayAverage.CL_CH4+d.controlWA.ratesDayAverage.CLO_OHb - d.controlWA.ratesDayAverage.HCL_OH+d.controlWA.ratesDayAverage.CL_CH2O+d.controlWA.ratesDayAverage.CL_H2+d.controlWA.ratesDayAverage.CL_HO2a;
    % plot(151:362,d.control.ratesDayAverage.CL_CH4+d.control.ratesDayAverage.CLO_OHb - d.control.ratesDayAverage.HCL_OH,'color',cbrewtouse(1,:),'LineWidth',lwidth)
    % plot(151:362,d.controlWA.ratesDayAverage.CL_CH4+d.controlWA.ratesDayAverage.CLO_OHb - d.controlWA.ratesDayAverage.HCL_OH,'color',cbrewtouse(2,:),'LineWidth',lwidth)
    plot(151:362,d.Hunga.ratesDayAverage.CL_CH2O+d.Hunga.ratesDayAverage.CL_H2+d.Hunga.ratesDayAverage.CL_HO2a+d.Hunga.ratesDayAverage.CL_CH4+d.Hunga.ratesDayAverage.CLO_OHb - d.Hunga.ratesDayAverage.HCL_OH-controlgpr,'color',cbrewtouse(3,:),'LineWidth',lwidth)
    plot(151:362,d.HungaWA.ratesDayAverage.CL_CH2O+d.HungaWA.ratesDayAverage.CL_H2+d.HungaWA.ratesDayAverage.CL_HO2a+d.HungaWA.ratesDayAverage.CL_CH4+d.HungaWA.ratesDayAverage.CLO_OHb - d.HungaWA.ratesDayAverage.HCL_OH-controlgpr2,'color',cbrewtouse(4,:),'LineWidth',lwidth)
    plot(151:362,d.HungaGHCL.ratesDayAverage.CL_CH2O+d.HungaGHCL.ratesDayAverage.CL_H2+d.HungaGHCL.ratesDayAverage.CL_HO2a+d.HungaGHCL.ratesDayAverage.CL_CH4+d.HungaGHCL.ratesDayAverage.CLO_OHb - d.HungaGHCL.ratesDayAverage.HCL_OH-controlgpr,'color',cbrewtouse(5,:),'LineWidth',lwidth,'LineStyle','--')
    plot(151:362,d.HunganohetHOBR.ratesDayAverage.CL_CH2O+d.HunganohetHOBR.ratesDayAverage.CL_H2+d.HunganohetHOBR.ratesDayAverage.CL_HO2a+d.HunganohetHOBR.ratesDayAverage.CL_CH4+d.HunganohetHOBR.ratesDayAverage.CLO_OHb - d.HunganohetHOBR.ratesDayAverage.HCL_OH-controlgpr,'color',cbrewtouse(6,:),'LineWidth',lwidth,'LineStyle','-.')
elseif i == 6
    nexttile;
    hold on;
    box on
    plot([189 189],[-200 200],'k--','LineWidth',2)
    plot([151 362],[0 0],'k--','LineWidth',2)
    controlgpr = d.control.ratesDayAverage.CL_CH4+d.control.ratesDayAverage.CLO_OHb - d.control.ratesDayAverage.HCL_OH - d.control.ratesDayAverage.hetHOBR_HCL+d.control.ratesDayAverage.CL_CH2O+d.control.ratesDayAverage.CL_H2+d.control.ratesDayAverage.CL_HO2a;
    controlgpr2 = d.controlWA.ratesDayAverage.CL_CH4+d.controlWA.ratesDayAverage.CLO_OHb - d.controlWA.ratesDayAverage.HCL_OH - d.controlWA.ratesDayAverage.hetHOBR_HCL+d.controlWA.ratesDayAverage.CL_CH2O+d.controlWA.ratesDayAverage.CL_H2+d.controlWA.ratesDayAverage.CL_HO2a;
    % plot(151:362,d.control.ratesDayAverage.CL_CH4+d.control.ratesDayAverage.CLO_OHb - d.control.ratesDayAverage.HCL_OH - d.control.ratesDayAverage.hetHOBR_HCL,'color',cbrewtouse(1,:),'LineWidth',lwidth)
    % plot(151:362,d.controlWA.ratesDayAverage.CL_CH4+d.controlWA.ratesDayAverage.CLO_OHb - d.controlWA.ratesDayAverage.HCL_OH - d.controlWA.ratesDayAverage.hetHOBR_HCL,'color',cbrewtouse(2,:),'LineWidth',lwidth)
    plot(151:362,d.Hunga.ratesDayAverage.CL_CH2O+d.Hunga.ratesDayAverage.CL_H2+d.Hunga.ratesDayAverage.CL_HO2a+d.Hunga.ratesDayAverage.CL_CH4+d.Hunga.ratesDayAverage.CLO_OHb - d.Hunga.ratesDayAverage.HCL_OH - d.Hunga.ratesDayAverage.hetHOBR_HCL-controlgpr,'color',cbrewtouse(3,:),'LineWidth',lwidth)
    plot(151:362,d.HungaWA.ratesDayAverage.CL_CH2O+d.HungaWA.ratesDayAverage.CL_H2+d.HungaWA.ratesDayAverage.CL_HO2a+d.HungaWA.ratesDayAverage.CL_CH4+d.HungaWA.ratesDayAverage.CLO_OHb - d.HungaWA.ratesDayAverage.HCL_OH - d.HungaWA.ratesDayAverage.hetHOBR_HCL-controlgpr2,'color',cbrewtouse(4,:),'LineWidth',lwidth)
    plot(151:362,d.HungaGHCL.ratesDayAverage.CL_CH2O+d.HungaGHCL.ratesDayAverage.CL_H2+d.HungaGHCL.ratesDayAverage.CL_HO2a+d.HungaGHCL.ratesDayAverage.CL_CH4+d.HungaGHCL.ratesDayAverage.CLO_OHb - d.HungaGHCL.ratesDayAverage.HCL_OH - d.HungaGHCL.ratesDayAverage.hetHOBR_HCL-controlgpr,'color',cbrewtouse(5,:),'LineWidth',lwidth,'LineStyle','--')
    plot(151:362,d.HunganohetHOBR.ratesDayAverage.CL_CH2O+d.HunganohetHOBR.ratesDayAverage.CL_H2+d.HunganohetHOBR.ratesDayAverage.CL_HO2a+d.HunganohetHOBR.ratesDayAverage.CL_CH4+d.HunganohetHOBR.ratesDayAverage.CLO_OHb - d.HunganohetHOBR.ratesDayAverage.HCL_OH - d.HunganohetHOBR.ratesDayAverage.hetHOBR_HCL-controlgpr,'color',cbrewtouse(6,:),'LineWidth',lwidth,'LineStyle','-.')
end
if i == 1
    lh = legend(ph,'control, Hanson gamma hobr','control, Wasch-Abbatt gamma hobr','Hunga-Tonga, Hanson gamma hobr (WACCM values)','Hunga-Tonga, Wasch-Abbatt gamma hobr',...
        'Hunga-Tonga, Hanson gamma hcl','Gas phase only','fontsize',fsize-4,'box','off');
    %set(lh,'position',[.5 .2 .3 .2])
    set(lh,'location','northwest')
end
tickout = monthtick('short',0);
set(gca,'xtick',tickout.tick(6:end),'xticklabels',tickout.monthnames(6:end),'fontsize',fsize);
if i == 1 || i == 3 
    addLabels(fsize,vartit{i},'','molecules/cm^3/s')
elseif i == 5
    addLabels(fsize,vartit{i},'Month','molecules/cm^3/s')
elseif i == 6
    addLabels(fsize,vartit{i},'Month','')
else
    addLabels(fsize,vartit{i},'','')
end
xlim([150 363])
end
savefigure(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/HungaTonga/'],['HungaTonga_gasphaserates'],1,0,0,0);

