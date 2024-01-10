function plotdiurnalcycles(variables,inputs)
    
    %plot diurnal cycles for debugging purposes

    if ~inputs.plotdiurnal
        return
    end
    
    lwidth = 2;
    fsize = 16;

    %Nitrogen
    createfig('largelandscape','on')
    tiledlayout(2,2)
    nexttile;
    plot(variables.NO2(2*inputs.stepsinday+1:3*inputs.stepsinday),'LineWidth',lwidth);
    hold on
    plot(variables.NO(2*inputs.stepsinday+1:3*inputs.stepsinday),'LineWidth',lwidth)
    plot(variables.NO3(2*inputs.stepsinday+1:3*inputs.stepsinday).*1e2,'LineWidth',lwidth)
    plot(variables.N2O5(2*inputs.stepsinday+1:3*inputs.stepsinday).*2,'LineWidth',lwidth)
    %plot(variables.HNO3(2*inputs.stepsinday+1:3*inputs.stepsinday)./10,'LineWidth',lwidth);
    %plot(variables.HO2NO2(2*inputs.stepsinday+1:3*inputs.stepsinday).*2,'LineWidth',lwidth);
    legend('NO2','NO','NO3*1e2','N2O5*2','fontsize',fsize+2,'location','northwest','box','off');
    set(gca,'xtick',1:inputs.stepsinhour*3:inputs.stepsinday*2,'xticklabel',0:3:21);
    addLabels(fsize,['Nitrogen species diurnal cycle at ',num2str(inputs.altitude),'km and ', num2str(abs(inputs.latitude)),inputs.hemisphere],...
        'Hour','Number density (molecules/cm^3)');
    nexttile;
    %Chlorine
    plot(variables.CL(2*inputs.stepsinday+1:3*inputs.stepsinday),'LineWidth',lwidth);
    hold on
    plot(variables.CL2(2*inputs.stepsinday+1:3*inputs.stepsinday),'LineWidth',lwidth)
    plot(variables.CL2O2(2*inputs.stepsinday+1:3*inputs.stepsinday),'LineWidth',lwidth)
    plot(variables.CLO(2*inputs.stepsinday+1:3*inputs.stepsinday)./500,'LineWidth',lwidth)
    plot(variables.CLONO2(2*inputs.stepsinday+1:3*inputs.stepsinday)./10000,'LineWidth',lwidth);
    plot(variables.HOCL(2*inputs.stepsinday+1:3*inputs.stepsinday)./100,'LineWidth',lwidth);
    legend('CL','CL2','CL2O2','CLO/500','CLONO2/10000','HOCL','fontsize',fsize+2,'location','northwest','box','off');
    set(gca,'xtick',1:inputs.stepsinhour*3:inputs.stepsinday*2,'xticklabel',0:3:21);
    addLabels(fsize,['Chlorine species diurnal cycle at ',num2str(inputs.altitude),'km and ', num2str(abs(inputs.latitude)),inputs.hemisphere],...
       'Hour','Number density (molecules/cm^3)');
    nexttile;
    %Bromine
    plot(variables.BR(2*inputs.stepsinday+1:3*inputs.stepsinday),'LineWidth',lwidth);
    hold on
    plot(variables.BRCL(2*inputs.stepsinday+1:3*inputs.stepsinday).*10,'LineWidth',lwidth)
    plot(variables.BRO(2*inputs.stepsinday+1:3*inputs.stepsinday)./40,'LineWidth',lwidth)
    plot(variables.BRONO2(2*inputs.stepsinday+1:3*inputs.stepsinday)./40,'LineWidth',lwidth)
    plot(variables.HOBR(2*inputs.stepsinday+1:3*inputs.stepsinday)./20,'LineWidth',lwidth);
    legend('BR','BRCL.*10','BRO/40','BRONO2/40','HOBR/20','fontsize',fsize+2,'location','northwest','box','off');
    set(gca,'xtick',1:inputs.stepsinhour*3:inputs.stepsinday*2,'xticklabel',0:3:21);
    addLabels(fsize,['Bromine species diurnal cycle at ',num2str(inputs.altitude),'km and ', num2str(abs(inputs.latitude)),inputs.hemisphere],...
        'Hour','Number density (molecules/cm^3)');
    nexttile;
    %HOx
    plot(variables.OH(2*inputs.stepsinday+1:3*inputs.stepsinday).*4,'LineWidth',lwidth);
    hold on
    plot(variables.HO2(2*inputs.stepsinday+1:3*inputs.stepsinday),'LineWidth',lwidth)
    plot(variables.H2O2(2*inputs.stepsinday+1:3*inputs.stepsinday)./2,'LineWidth',lwidth)
    plot(variables.HO2NO2(2*inputs.stepsinday+1:3*inputs.stepsinday)./50,'LineWidth',lwidth)
    legend('OH*2','HO2','H2O2/2','HO2NO2/100','fontsize',fsize+2,'location','northwest','box','off');
    set(gca,'xtick',1:inputs.stepsinhour*3:inputs.stepsinday*2,'xticklabel',0:3:21);
    addLabels(fsize,['HO species species diurnal cycle at ',num2str(inputs.altitude),'km and ', num2str(abs(inputs.latitude)),inputs.hemisphere],...
        'Hour','Number density (molecules/cm^3)');


end