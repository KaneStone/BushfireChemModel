% load an dplot Pinatubo test

noHOBR = load('/Users/kanestone/work/code/BushfireChemModel/output/runoutput/control_19km_-45S_0flux_0.25hourscontrol_SADx25_noHOBRhet.mat');
HOBR = load('/Users/kanestone/work/code/BushfireChemModel/output/runoutput/control_19km_-45S_0flux_0.25hourscontrol_SADx25.mat');
HOBRconstant = load('/Users/kanestone/work/code/BushfireChemModel/output/runoutput/control_19km_-45S_0flux_0.25hourscontroltest.mat');
control = load('/Users/kanestone/work/code/BushfireChemModel/output/runoutput/control_19km_-45S_0flux_0.25hours_2years.mat');

%% plot HCL, O3, CLONO2, OH

[inputs,vars] = runinputs;

%Initial concentrations
fsize = 18;
[atmosphere,variables] = initializevars(inputs);
tick = monthtick('short',1);
createfig('large','on');
t = tiledlayout(3,2);
title(t,'19 km Pinatubo test','fontweight','bold','fontsize',fsize+6);

lwidth = 2;


nexttile([1 2]);
plot(atmosphere.dummySAD(1:365),'LineWidth',lwidth);
%title('SAD','fontsize',fsize+2)
set(gca,'xtick',tick.tick,'xticklabel',tick.monthnames)
addLabels(18,'SAD','Month','SAD cm^2/cm^3')
vars = {'HCL','CLONO2','O3','OH'};
for i = 1:length(vars)
    nexttile;
    ph(1) = plot(control.dayAverage.(vars{i}),'Linewidth',lwidth);
    hold on;
    ph(2) = plot(HOBR.dayAverage.(vars{i}),'Linewidth',lwidth);
    
    ph(3) = plot(noHOBR.dayAverage.(vars{i}),'Linewidth',lwidth);
    ph(4) = plot(HOBRconstant.dayAverage.(vars{i}),'Linewidth',lwidth);
    %title(vars{i},'fontsize',fsize+2)
    if i == 2
        lh = legend(ph,'control','Pinatubo','Pinatubo no het. HOBr','Pinatubo constant','fontsize',fsize,'box','off','location','southwest');
    end
    set(gca,'xtick',[tick.tick(1:4:end),tick.tick(1:4:end)+365],'xticklabel',tick.monthnames(1:4:end))
    addLabels(18,vars{i},'Month','Number density (cm^-^1)')
end

outdir = '/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/';
filename = ['PinatuboTest2'];
savefigure(outdir,filename,1,0,0,0);