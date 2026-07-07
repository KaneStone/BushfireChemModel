% compare nox

[~,dilution,~] = Read_in_netcdf('/Users/kanestone/work/data/Bushfire/out_SD_dilution.nc');
[~,solubility,~] = Read_in_netcdf('/Users/kanestone/work/data/Bushfire/out_SD_solubility.nc');
[~,control,~] = Read_in_netcdf('/Users/kanestone/work/data/Bushfire/control/out_SD_control.nc');

%% box model
% gammap1 = load('/Users/kanestone/work/code/BushfireChemModel/output/runoutput/constantlinearnomix_19km_-45S_0flux_0.25hoursgamma.1.mat');
gammap004 = load('/Users/kanestone/work/code/BushfireChemModel/output/runoutput/linearnomix_19km_-45S_0flux_0.50hoursgamma.004.mat');
% gammap007 = load('/Users/kanestone/work/code/BushfireChemModel/output/runoutput/linearnomix_19km_-45S_0flux_0.50hoursgamma.007.mat');
gammap01 = load('/Users/kanestone/work/code/BushfireChemModel/output/runoutput/linearnomix_19km_-45S_0flux_0.50hoursgamma.01.mat');
boxcontrol = load('/Users/kanestone/work/code/BushfireChemModel/output/runoutput/control_19km_-45S_0flux_0.50hours.mat');
% wt25 = load('/Users/kanestone/work/code/BushfireChemModel/output/runoutput/linearnomix_19km_-45S_0flux_0.50hourswt');

%% figure
cbrew = cbrewer('qual','Set1',10);
createfig('large','on');
vars = {'HCL','CLONO2','O3','NO','NO2','CLO','HOCL','N2O5'};
t = tiledlayout(length(vars)/2,2,'TileSpacing','compact');
title(t,'2020 anomalies, 19 km, 45˚S','fontweight','bold','fontsize',20);
for i =1:length(vars)
    nexttile;
    % plot(1:7:365,squeeze(control.(vars{i})(25,20,1:53)));
    hold on
    ph1 = plot(1:7:365,squeeze(solubility.(vars{i})(25,20,1:53)) - squeeze(control.(vars{i})(25,20,1:53)),'LineWidth',2,'color',cbrew(1,:));
    ph2 = plot(1:7:365,squeeze(dilution.(vars{i})(25,20,1:53)) - squeeze(control.(vars{i})(25,20,1:53)),'LineWidth',2,'color',cbrew(2,:));
    temp = gammap01.dayAverage.(vars{i}).*1.38065e-23.*1e6./(70.*100).*215;
    temp2 = gammap004.dayAverage.(vars{i}).*1.38065e-23.*1e6./(70.*100).*215;
    % temp4 = wt25.dayAverage.(vars{i}).*1.38065e-23.*1e6./(70.*100).*215;
    temp3 = boxcontrol.dayAverage.(vars{i}).*1.38065e-23.*1e6./(70.*100).*215;
    plot([0 400],[0 0],'k--');
    % temp3 = gammap007.dayAverage.(var).*1.38065e-23.*1e6./(70.*100).*215;
    ph3 = plot(1:170,temp(1:170) - temp3(1:170),'LineWidth',2,'color',[.5 .5 .5],'LineStyle','--');
    ph4 = plot(1:365,temp2 - temp3(1:365),'LineWidth',2,'color',cbrew(4,:));
    % plot(1:156,temp4(1:156) - temp3(1:156));
    title(vars{i});
    box on
    
    if i == 1 || i == 3 || i == 5 
        addLabels(14,vars{i},'','vmr');
    elseif i == 7 
        addLabels(14,vars{i},'doy','vmr');
    elseif i == 8
        addLabels(14,vars{i},'doy','');
    else
        addLabels(14,vars{i},'','');
    end

    if i == 7
        l = legend([ph1,ph2,ph3,ph4],'CARMA - solubility','CARMA - dilution','box model - gamma .01','box model - gamma .004','box', 'off','location','northeast','fontsize',10);
        % l = legend([ph1,ph2,ph3,ph4],'CARMA - solubility','CARMA - dilution','box model - gamma .01','box model - gamma .004','box', 'off','location','southoutside','orientation','horizontal');
        % set(l,'position',[.08 0 1 .1])
    end
    % plot(1:271,temp3);
end

savefigure('/Users/kanestone/','gammatesting',1,0,0,0);