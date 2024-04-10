% plot box model rates
clear all
inputs = runinputs;
inputs.fluxcorrections = 0;
inputs.altitude = 19;
% Read in profiles then select by layer
[atmosphere,variables] = initializevars(inputs);

d.doublelinear = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_onlyCLONO2_HNO3_NO2_NO3_N2O5.mat']);

% d.doublelinear = load([inputs.outputdir,'runoutput/','doublelinear','_',num2str(inputs.altitude),...
%     'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
%     ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours.mat']);

d.control = load([inputs.outputdir,'runoutput/','control','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_2years.mat']);
%lngth = length(d.doublelinear.dayAverage.HCL);
lngth = 365;

%% plot individual rates
fsize = 18;
lngth = 365;
ratetoplot = 'CL_CH4';
vartit = ratetoplot;
vartit (vartit == '_') = '+';
createfig('medium','on')
plot(1:lngth,d.doublelinear.ratesDayAverage.(ratetoplot)(1:lngth),'LineWidth',3)
addLabels(18,[vartit,' rate'],'molec./cm^3/s','Month')
tickout = monthtick('short',0);
set(gca,'xtick',[tickout.tick(1:1:12),tickout.tick(1:1:12)+365],'xticklabels',[tickout.monthnames(1:1:12),tickout.monthnames(1:1:12)],'fontsize',fsize);
xlim([0 366])
savefigure(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushfireChemistry/BoxModelOutput/seasonality/'],[vartit,'_ind_timeseries'],1,0,0,0);
%% plot day average variables first
lngth = 365;
vars = {'HCL','CLONO2','CLO','CL','CL2','O3','NO2','HO2NO2','HNO3'};
createfig('largelandscape','on')
t = tiledlayout(3,3);
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

    set(gca,'xtick',[tickout.tick(1:3:12),tickout.tick(1:3:12)+365],'xticklabels',[tickout.monthnames(1:3:12),tickout.monthnames(1:3:12)],'fontsize',fsize);
    if i == 7 
        addLabels(fsize,vars{i},'Month','molec./cm^3/s')
    elseif i > 7
        addLabels(fsize,vars{i},'Month','')
    elseif i == 1 || i == 4
        addLabels(fsize,vars{i},'','molec./cm^3/s')
    else
        addLabels(fsize,vars{i},'','')
    end
    if i == 1
        lh = legend([ph1,ph2],'control','double linear','fontsize',fsize,'box','off','location','south');
    end
    if strcmp(vars{i},'CH4')
        legend(ph2,'CARMA CH4 (used in box model)','box', 'off')
    end
end
savefigure(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushfireChemistry/BoxModelOutput/seasonality/'],['variables_timeseries'],1,0,0,0);

createfig('largelandscape','on')
t = tiledlayout(3,3);
fsize = 18;
title(t,'Box model, 19 km, 45S, constant T, SAD, RAD, H2O, and organics (wildfire levels)',...
    'fontsize',fsize+6,'fontweight','bold')
lwidth = 3;

tickout = monthtick('short',0);    
for i = 1:length(vars)
    nexttile;
    ph1 = plot(1:lngth,d.doublelinear.dayAverage.(vars{i})(1:lngth)-d.control.dayAverage.(vars{i})(1:lngth),'LineWidth',lwidth);
    hold on
    plot([0 lngth],[0 0],'--','color',[.4 .4 .4],'LineWidth',2)
    
    set(gca,'xtick',[tickout.tick(1:3:12),tickout.tick(1:3:12)+365],'xticklabels',[tickout.monthnames(1:3:12),tickout.monthnames(1:3:12)],'fontsize',fsize);
    if i == 7 
        addLabels(fsize,[vars{i},' anomaly'],'Month','molec./cm^3/s')
    elseif i > 7
        addLabels(fsize,[vars{i},' anomaly'],'Month','')
    elseif i == 1 || i == 4
        addLabels(fsize,[vars{i},' anomaly'],'','molec./cm^3/s')
    else
        addLabels(fsize,[vars{i},' anomaly'],'','')
    end
    if i == 1
        lh = legend([ph1,ph2],'anomaly from control','fontsize',fsize,'box','off','location','southeast');
    end
    % if strcmp(vars{i},'CH4')
    %     legend(ph2,'CARMA CH4 (used in box model)','box', 'off')
    % end
end
savefigure(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushfireChemistry/BoxModelOutput/seasonality/'],['anomalies_timeseries'],1,0,0,0);

%% plot individual rates
d.doublelinear.ratesDayAverage.jCLONO2 = (d.doublelinear.ratesDayAverage.jCLONO2_CL_NO3 + ...
    d.doublelinear.ratesDayAverage.jCLONO2_CLO_NO2);

d.control.ratesDayAverage.jCLONO2 = (d.control.ratesDayAverage.jCLONO2_CL_NO3 + ...
    d.control.ratesDayAverage.jCLONO2_CLO_NO2);
lngth = 365;
vars = {'HCL_OH','CL_CH4','CLO_NO2_M','jCLONO2','jCL2_2CL','jCL2O2_CL_2CL','CL_O3','hetCLONO2_HCL','hetHOBR_HCL'};
vartit = {'HCL+OH','CL+CH4','CLO+NO2+M','jCLONO2','jCL2','jCL2O2','CL+O3','het. CLONO2+HCL','het. HOBR+HCL'};
createfig('largelandscape','on')
t = tiledlayout(3,3);
fsize = 18;
title(t,'Box model, 19 km, 45S, constant T, SAD, RAD, H2O, and organics (wildfire levels)',...
    'fontsize',fsize+6,'fontweight','bold')
lwidth = 3;

tickout = monthtick('short',0);    
d.control.dayAverage.CH4 = repmat(atmosphere.atLevel.CH4.nd(1:365),1,lngth/365);
d.doublelinear.dayAverage.CH4 = repmat(atmosphere.atLevel.CH4.nd(1:365),1,lngth/365);
for i = 1:length(vars)
    nexttile;
    ph1 = plot(1:lngth,d.control.ratesDayAverage.(vars{i})(1:lngth),'LineWidth',lwidth);
    hold on
    ph2 = plot(1:lngth,d.doublelinear.ratesDayAverage.(vars{i})(1:lngth),'LineWidth',lwidth);

    set(gca,'xtick',[tickout.tick(1:3:12),tickout.tick(1:3:12)+365],'xticklabels',[tickout.monthnames(1:3:12),tickout.monthnames(1:3:12)],'fontsize',fsize);
    if i == 7 
        addLabels(fsize,vartit{i},'Month','molec./cm^3/s')
    elseif i > 7
        addLabels(fsize,vartit{i},'Month','')
    elseif i == 1 || i == 4
        addLabels(fsize,vartit{i},'','molec./cm^3/s')
    else
        addLabels(fsize,vartit{i},'','')
    end
    if i == 1
        lh = legend([ph1,ph2],'control','double linear','fontsize',fsize,'box','off','location','southeast');
    end
    if strcmp(vars{i},'CH4')
        legend(ph2,'CARMA CH4 (used in box model)','box', 'off')
    end
end
savefigure(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushfireChemistry/BoxModelOutput/seasonality/'],['rates_timeseries'],1,0,0,0);

%%
% want to plot CLONO2, HCL total production and loss
% want to plot individual aswell
lngth = 730;
d.doublelinear.ratesDayAverage.jCLONO2 = (d.doublelinear.ratesDayAverage.jCLONO2_CL_NO3 + ...
    d.doublelinear.ratesDayAverage.jCLONO2_CLO_NO2);

d.control.ratesDayAverage.jCLONO2 = (d.control.ratesDayAverage.jCLONO2_CL_NO3 + ...
    d.control.ratesDayAverage.jCLONO2_CLO_NO2);

    createfig('largelandscape','on');
    lwidth = 3;
    fsize = 18;
    cbrew = cbrewer('qual','Set1',10);
    cbrewtouse = [[0 0 0];cbrew([1,2,4,8],:)];
    vars = {'jCLONO2','CLONO2_CL','CLONO2_OH','CLONO2_O','hetCLONO2_HCL','hetCLONO2_H2O'};
    vartit = {'jCLONO2/100','CLONO2+CL','CLONO2+OH','CLONO2+O','het. CLONO2+HCL','het. CLONO2+H2O'};
    % vars = {'jCLONO2','CLONO2_CL','CLONO2_OH','hetCLONO2_HCL'};
    % vartit = {'jCLONO2/100','CLONO2+CL','CLONO2+OH','het. CLONO2+HCL'};
    %lstyle = {'-','-','-',':','--'};
    t = tiledlayout(2,2);
    title(t,'Box model, 19km, 45S, reaction rates','fontsize',fsize+6,'fontweight','bold')
    nexttile;
    for i = 1:length(vars)
        if i == 1
            phs(i) = plot(1:lngth ,-d.doublelinear.ratesDayAverage.(vars{i})(1:lngth)./100,...
                'LineStyle','-','color',cbrew(i,:),'LineWidth',lwidth);
        else
            phs(i) = plot(1:lngth ,-d.doublelinear.ratesDayAverage.(vars{i})(1:lngth),...
                'LineStyle','-','color',cbrew(i,:),'LineWidth',lwidth);
        end
        %set(gca,'Yscale','log')
        hold on
        %plot(1:365,d.control.ratesDayAverage.(vars{i}),'--','color',cbrew(i,:),'LineWidth',lwidth);
        Cdestructionall(i,:) = d.doublelinear.ratesDayAverage.(vars{i})(1:lngth);

    end

    legend(phs,vartit,'fontsize',fsize,'box','off')
    tickout = monthtick('short',0);
    set(gca,'xtick',[tickout.tick(1:3:12),tickout.tick(1:3:12)+365],'xticklabels',[tickout.monthnames(1:3:12),tickout.monthnames(1:3:12)],'fontsize',fsize);
    addLabels(fsize,'','Month','molecules/cm^3/s')

    nexttile;
    plot(1:lngth ,-sum(Cdestructionall,1),'LineStyle','-','color','k','LineWidth',lwidth)
    set(gca,'xtick',[tickout.tick(1:3:12),tickout.tick(1:3:12)+365],'xticklabels',[tickout.monthnames(1:3:12),tickout.monthnames(1:3:12)],'fontsize',fsize);

    vars = {'CLO_NO2_M'};
    vartit = {'CLO_NO2_M'};
    nexttile;
    
     for i = 1:length(vars)
    
        ph(i) = plot(1:lngth,d.doublelinear.ratesDayAverage.(vars{i})(1:lngth),...
            'LineStyle','-','color',cbrewtouse(i,:),'LineWidth',lwidth);
        %set(gca,'Yscale','log')
        hold on
        %plot(1:365,d.control.ratesDayAverage.(vars{i}),'--','color',cbrew(i,:),'LineWidth',lwidth);
        %destructionall(i,:) = d.doublelinear.ratesDayAverage.(vars{i});

     end
      tickout = monthtick('short',0);
    set(gca,'xtick',[tickout.tick(1:3:12),tickout.tick(1:3:12)+365],'xticklabels',[tickout.monthnames(1:3:12),tickout.monthnames(1:3:12)],'fontsize',fsize);
    addLabels(fsize,'','Month','molecules/cm^3/s')

    nexttile;
    plot(1:lngth ,d.doublelinear.ratesDayAverage.(vars{i})(1:lngth) - sum(Cdestructionall,1),'LineStyle','-','color','k','LineWidth',lwidth)
    hold on
    plot([1 lngth ],[0 0],'--','color',[.5 .5 .5],'LineWidth',2)
    set(gca,'xtick',[tickout.tick(1:3:12),tickout.tick(1:3:12)+365],'xticklabels',[tickout.monthnames(1:3:12),tickout.monthnames(1:3:12)],'fontsize',fsize);

    createfig('medium','on')
    plot(1:lngth,sum(Cdestructionall,1));
    hold on
    plot(d.doublelinear.ratesDayAverage.CLO_NO2_M);

    %% HCL

    % d.doublelinear.ratesDayAverage.jCLONO2 = d.doublelinear.ratesDayAverage.jCLONO2_CL_NO3 + ...
    % d.doublelinear.ratesDayAverage.jCLONO2_CLO_NO2;
    toplot = 'doublelinear';
    createfig('largelandscape','on');
    lwidth = 3;
    fsize = 18;
    cbrew = cbrewer('qual','Set1',10);
    cbrewtouse = [[0 0 0];cbrew([1,2,4,8],:)];
    vars = {'HCL_OH','jHCL_CL_H','HCL_O1D','HCL_O','hetCLONO2_HCL','hetHOCL_HCL','hetHOBR_HCL'};
    vartit = {'HCL+OH','jHCL','HCL+O1D','HCL+O','het. CLONO2+HCL','het. HOCL+HCL','het. HOBR+HCL'};
    %lstyle = {'-','-','-',':','--'};
    t = tiledlayout(2,2);
    nexttile;
    for i = 1:length(vars)
    
        ph(i) = plot(1:lngth ,d.(toplot).ratesDayAverage.(vars{i})(1:lngth),...
            'LineStyle','-','color',cbrew(i,:),'LineWidth',lwidth);
        %set(gca,'Yscale','log')
        hold on
        %plot(1:365,d.control.ratesDayAverage.(vars{i})(1:lngth),'--','color',cbrew(i,:),'LineWidth',lwidth);
        Hdestructionall(i,:) = d.(toplot).ratesDayAverage.(vars{i})(1:lngth);

    end

    legend(ph,vartit,'fontsize',fsize,'box','off')
    tickout = monthtick('short',0);
    set(gca,'xtick',[tickout.tick(1:3:12),tickout.tick(1:3:12)+365],'xticklabels',[tickout.monthnames(1:3:12),tickout.monthnames(1:3:12)],'fontsize',fsize);
    addLabels(fsize,'2020 45S Box model heterogeneous reaction rates','Month','molecules/cm^3/s')

    nexttile;

    %nexttile;
    plot(1:lngth ,sum(Hdestructionall,1),'LineStyle','-','color','k','LineWidth',lwidth)
    set(gca,'xtick',[tickout.tick(1:3:12),tickout.tick(1:3:12)+365],'xticklabels',[tickout.monthnames(1:3:12),tickout.monthnames(1:3:12)],'fontsize',fsize);


    vars = {'CL_CH4','CL_CH2O','CLO_OHb','CL_H2','CL_H2O2','CL_HO2a'};
    vartit = {'CL+CH4','CL+CH2O','CLO+OHb','CL+H2','CL+H2O2','CL+HO2a'};
    nexttile;
    
     for i = 1:length(vars)
    
        ph(i) = plot(1:lngth ,d.(toplot).ratesDayAverage.(vars{i})(1:lngth),...
            'LineStyle','-','color',cbrew(i,:),'LineWidth',lwidth);
        %set(gca,'Yscale','log')
        hold on
        %plot(1:365,d.control.ratesDayAverage.(vars{i})(1:lngth),'--','color',cbrew(i,:),'LineWidth',lwidth);
        Hproductionall(i,:) = d.(toplot).ratesDayAverage.(vars{i})(1:lngth);

     end
     legend(ph,vartit,'fontsize',fsize,'box','off')
      tickout = monthtick('short',0);
    set(gca,'xtick',[tickout.tick(1:3:12),tickout.tick(1:3:12)+365],'xticklabels',[tickout.monthnames(1:3:12),tickout.monthnames(1:3:12)],'fontsize',fsize);
    addLabels(fsize,'2020 45S Box model heterogeneous reaction rates','Month','molecules/cm^3/s')

    nexttile;
    plot(1:lngth ,sum(Hproductionall,1) - sum(Hdestructionall,1),'LineStyle','-','color','k','LineWidth',lwidth)
    hold on
    plot([1 lngth],[0 0],'--','color',[.5 .5 .5],'LineWidth',2)
    set(gca,'xtick',[tickout.tick(1:3:12),tickout.tick(1:3:12)+365],'xticklabels',[tickout.monthnames(1:3:12),tickout.monthnames(1:3:12)],'fontsize',fsize);
    
    createfig('medium','on'); 
    plot(1:lngth,sum(Hdestructionall,1))
    hold on
    plot(1:lngth,sum(Hproductionall,1))
    

    %% CL
    lngth = 365
    toplot = 'doublelinear';
    createfig('largelandscape','on');
    lwidth = 3;
    fsize = 18;
    cbrew = cbrewer('qual','Set1',10);
    cbrewtouse = [[0 0 0];cbrew([1,2,4,8],:)];
    vars = {'CL_CH4','CL_O3'};
    vartit = {'CL+CH4','Cl+O3'};
    %lstyle = {'-','-','-',':','--'};
    t = tiledlayout(2,2);
    nexttile;
    for i = 1:length(vars)
    
        phcl(i) = plot(1:lngth ,d.(toplot).ratesDayAverage.(vars{i})(1:lngth),...
            'LineStyle','-','color',cbrew(i,:),'LineWidth',lwidth);
        %set(gca,'Yscale','log')
        hold on
        %plot(1:365,d.control.ratesDayAverage.(vars{i})(1:lngth),'--','color',cbrew(i,:),'LineWidth',lwidth);
        Hdestructionall(i,:) = d.(toplot).ratesDayAverage.(vars{i})(1:lngth);

    end

    legend(phcl,vartit,'fontsize',fsize,'box','off')
    tickout = monthtick('short',0);
    set(gca,'xtick',[tickout.tick(1:3:12),tickout.tick(1:3:12)+365],'xticklabels',[tickout.monthnames(1:3:12),tickout.monthnames(1:3:12)],'fontsize',fsize);
    addLabels(fsize,'2020 45S Box model heterogeneous reaction rates','Month','molecules/cm^3/s')

    nexttile;

    %nexttile;
    plot(1:lngth ,sum(Hdestructionall,1),'LineStyle','-','color','k','LineWidth',lwidth)
    set(gca,'xtick',[tickout.tick(1:3:12),tickout.tick(1:3:12)+365],'xticklabels',[tickout.monthnames(1:3:12),tickout.monthnames(1:3:12)],'fontsize',fsize);


    vars = {'jCL2_2CL','jCL2O2_CL_2CL',};
    vartit = {'jCL2','jCL2O2'};
    nexttile;
    
     for i = 1:length(vars)
    
        phcll(i) = plot(1:lngth ,d.(toplot).ratesDayAverage.(vars{i})(1:lngth),...
            'LineStyle','-','color',cbrew(i,:),'LineWidth',lwidth);
        %set(gca,'Yscale','log')
        hold on
        %plot(1:365,d.control.ratesDayAverage.(vars{i})(1:lngth),'--','color',cbrew(i,:),'LineWidth',lwidth);
        Hproductionall(i,:) = d.(toplot).ratesDayAverage.(vars{i})(1:lngth);

     end
     legend(phcll,vartit,'fontsize',fsize,'box','off')
      tickout = monthtick('short',0);
    set(gca,'xtick',[tickout.tick(1:3:12),tickout.tick(1:3:12)+365],'xticklabels',[tickout.monthnames(1:3:12),tickout.monthnames(1:3:12)],'fontsize',fsize);
    addLabels(fsize,'2020 45S Box model heterogeneous reaction rates','Month','molecules/cm^3/s')

    nexttile;
    plot(1:lngth ,sum(Hproductionall,1) - sum(Hdestructionall,1),'LineStyle','-','color','k','LineWidth',lwidth)
    hold on
    plot([1 lngth],[0 0],'--','color',[.5 .5 .5],'LineWidth',2)
    set(gca,'xtick',[tickout.tick(1:3:12),tickout.tick(1:3:12)+365],'xticklabels',[tickout.monthnames(1:3:12),tickout.monthnames(1:3:12)],'fontsize',fsize);

%%
toplot = 'doublelinear';
createfig('largelandscape','on');
lwidth = 3;
fsize = 18;
cbrew = cbrewer('qual','Set1',10);
cbrewtouse = [[0 0 0];cbrew([1,2,4,8],:)];
vars = {'hetCLONO2_HCL','hetHOBR_HCL','hetHOCL_HCL'};
vartit = {'het. CLONO2 + HCL','het. HOBR + HCL','het. HOCL + HCL'};
%lstyle = {'-','-','-',':','--'};
%t = tiledlayout(2,2);
%nexttile;
for i = 1:length(vars)

    phcl(i) = plot(1:lngth ,d.(toplot).ratesDayAverage.(vars{i})(1:lngth),...
        'LineStyle','-','color',cbrew(i,:),'LineWidth',lwidth);
    %set(gca,'Yscale','log')
    hold on
    %plot(1:365,d.control.ratesDayAverage.(vars{i})(1:lngth),'--','color',cbrew(i,:),'LineWidth',lwidth);
    Hdestructionall(i,:) = d.(toplot).ratesDayAverage.(vars{i})(1:lngth);

end

legend(phcl,vartit,'fontsize',fsize,'box','off')
tickout = monthtick('short',0);
set(gca,'xtick',[tickout.tick(1:3:12),tickout.tick(1:3:12)+365],'xticklabels',[tickout.monthnames(1:3:12),tickout.monthnames(1:3:12)],'fontsize',fsize);
addLabels(fsize,'2020 45S Box model heterogeneous reaction rates','Month','molec./cm^3/s')

savefigure(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushfireChemistry/BoxModelOutput/seasonality/'],['hetreactions'],1,0,0,0);

%% addition of reactions in each figure for HCL and CLONO2 and CL
%CLONO2
vars = {'CLONO2_CL','CLONO2_OH','CLONO2_O','hetCLONO2_HCL'};
%t = tiledlayout(3,2)
createfig('medium','on');
lngth = 365;
for i = 1:length(vars)+1
    hold on
    if i == 1
        toplot1 = d.(toplot).ratesDayAverage.CLO_NO2_M(1:lngth) - d.(toplot).ratesDayAverage.jCLONO2(1:lngth);
    else 
        toplot1 = toplot1 - d.(toplot).ratesDayAverage.(vars{i-1})(1:lngth);
    end
    if i == 1
        plot(1:lngth,toplot1(1:lngth),'LineWidth',3,'color','k','LineStyle','--');
    elseif i == length(vars)+1
        plot(1:lngth,toplot1(1:lngth),'LineWidth',3,'color','k');
    else
        plot(1:lngth,toplot1(1:lngth),'LineWidth',2);
    end
end
plot([0 365],[0 0],'--','color',[ .6 .6 .6],'LineWidth',1.5)
tickout = monthtick('short',0);
set(gca,'xtick',[tickout.tick(1:3:12),tickout.tick(1:3:12)+365],'xticklabels',[tickout.monthnames(1:3:12),tickout.monthnames(1:3:12)],'fontsize',fsize);
legend('(CLO+NO2+M) - jCLONO2',' - (CLONO2 + CL)',' - (CLONO2 + OH)',' - (CLONO2 + O)',' - (het. CLONO2 + HCL)','fontsize',fsize+2,'box','off')
box on;
addLabels(fsize,'2020 45S Box model CLONO2 reaction rates','Month','molec./cm^3/s')

savefigure(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushfireChemistry/BoxModelOutput/seasonality/'],['CLONO2_total_prod_loss'],1,0,0,0);

%% addition of reactions in each figure for HCL and CLONO2 and CL
%HCL
vars = {'hetCLONO2_HCL','hetHOBR_HCL','hetHOCL_HCL'};
vars2 = {'CL_CH2O','CLO_OHb'};
%t = tiledlayout(3,2)
createfig('medium','on');
lngth = 365;
for i = 1:length(vars)+2
    hold on
    if i == 1
        toplot1 = d.(toplot).ratesDayAverage.CL_CH4(1:lngth) - d.(toplot).ratesDayAverage.HCL_OH(1:lngth);
    elseif i == 2
        toplot1 = toplot1 + d.(toplot).ratesDayAverage.(vars2{1})(1:lngth) + d.(toplot).ratesDayAverage.(vars2{2})(1:lngth);
    else 
        toplot1 = toplot1 - d.(toplot).ratesDayAverage.(vars{i-2})(1:lngth);
    end
    if i == 1
        plot(1:lngth,toplot1(1:lngth),'LineWidth',3,'color','k','LineStyle','--');
    elseif i == length(vars)+2
        plot(1:lngth,toplot1(1:lngth),'LineWidth',3,'color','k');
    else
        plot(1:lngth,toplot1(1:lngth),'LineWidth',2);
    end
end
% for i = 1:length(vars2)
%     hold on
% 
%     toplot1 = toplot1 + d.(toplot).ratesDayAverage.(vars2{i})(1:lngth);
% 
%     plot(1:lngth,toplot1(1:lngth),'LineWidth',1.5);
% end
plot([0 365],[0 0],'--','color',[ .6 .6 .6],'LineWidth',1.5)
tickout = monthtick('short',0);
set(gca,'xtick',[tickout.tick(1:3:12),tickout.tick(1:3:12)+365],'xticklabels',[tickout.monthnames(1:3:12),tickout.monthnames(1:3:12)],'fontsize',fsize);
legend('(Cl+CH4) - (HCL+OH)',' + (CL + CH2O) + (CLO+OHb)',' - (het. CLONO2 + HCL)',' - (het. HOBR + HCL)',' - (het. HOCL + HCL)','fontsize',fsize+2,'box','off')
box on;
addLabels(fsize,'2020 45S Box model HCL reaction rates','Month','molec./cm^3/s')

savefigure(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushfireChemistry/BoxModelOutput/seasonality/'],['HCL_total_prod_loss'],1,0,0,0);
    

%% addition of reactions in each figure for HCL and CLONO2 and CL
%HCL
vars = {'CL_O3'};
vars2 = {'jCL2_2CL','jCL2_2CL','jCL2O2_CL_2CL','jCL2O2_CL_2CL','jHOCL_HO_CL','jBRCL_BR_CL','jCLO_O3P_CL','jCLONO2_CL_NO3'};
%t = tiledlayout(3,2)
createfig('medium','on');
lngth = 365;
for i = 1:length(vars2)+2
    hold on
    if i == 1
        toplot1 = -d.(toplot).ratesDayAverage.CL_O3(1:lngth)+d.(toplot).ratesDayAverage.CLO_NO(1:lngth)+...
            d.(toplot).ratesDayAverage.BRO_CLOb(1:lngth) + d.(toplot).ratesDayAverage.HCL_OH(1:lngth) + ...
            d.(toplot).ratesDayAverage.CLO_O(1:lngth);
    elseif i == 2
        toplot1 = toplot1 - d.(toplot).ratesDayAverage.CL_CH4(1:lngth);
    else 
        toplot1 = toplot1 + d.(toplot).ratesDayAverage.(vars2{i-2})(1:lngth);
    end
    plot(1:lngth,toplot1(1:lngth),'LineWidth',1.5);
end
% for i = 1:length(vars2)
%     hold on
% 
%     toplot1 = toplot1 + d.(toplot).ratesDayAverage.(vars2{i})(1:lngth);
% 
%     plot(1:lngth,toplot1(1:lngth),'LineWidth',1.5);
% end
plot([0 365],[0 0],'--','color',[ .6 .6 .6],'LineWidth',1.5)
tickout = monthtick('short',0);
set(gca,'xtick',[tickout.tick(1:3:12),tickout.tick(1:3:12)+365],'xticklabels',[tickout.monthnames(1:3:12),tickout.monthnames(1:3:12)],'fontsize',fsize);
legend('jCL2 - (Cl+CH4)',' - (CL + O3)','fontsize',fsize+2,'box','off')
box on;
addLabels(fsize,'2020 45S Box model CL reaction rates','Month','molec./cm^3/s')

savefigure(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushfireChemistry/BoxModelOutput/seasonality/'],['CL_total_prod_loss'],1,0,0,0);

%%
cbrew = cbrewer('qual','Set1',10);
lngth = 365;
createfig('medium','on');
vars = {'CL2','CLO','CL2O2','CL','BRCL','CLONO2','HCL','HOCL'};
for i = 1:length(vars)
    ph(i) = plot(1:lngth,abs(d.doublelinear.dayAverage.(vars{i})(1:lngth) - d.control.dayAverage.(vars{i})(1:lngth))...
        ./max(abs(d.doublelinear.dayAverage.(vars{i})(1:lngth)-d.control.dayAverage.(vars{i})(1:lngth))),'LineWidth',3,'color',cbrew(i,:));
    hold on
end
ylim([0 1.1]);
tickout = monthtick('short',0);
set(gca,'xtick',[tickout.tick(1:3:12),tickout.tick(1:3:12)+365],'xticklabels',[tickout.monthnames(1:3:12),tickout.monthnames(1:3:12)],'fontsize',fsize);
legend(ph,vars,'fontsize',fsize+2,'box','off')
box on;
addLabels(fsize,'2020 45S normalized absolute anomalies from control','Month','normalized concentration')

savefigure(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushfireChemistry/BoxModelOutput/seasonality/'],['CL_species_peak_timing'],1,0,0,0);
    