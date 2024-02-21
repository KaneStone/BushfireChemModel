% plot box model rates

inputs = runinputs;
inputs.fluxcorrections = 0;
inputs.altitude = 19;
% Read in profiles then select by layer
[atmosphere,variables] = initializevars(inputs);

d.doublelinear = load([inputs.outputdir,'runoutput/','doublelinear','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours.mat']);

d.doublelinear2 = load([inputs.outputdir,'runoutput/','doublelinear','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_ah_effectsall.mat']);

%%
plotrates = 0;
if plotrates
    createfig('medium','on')
    lwidth = 3;
    fsize = 18;
    cbrew = cbrewer('qual','Set1',10);
    cbrewtouse = [[0 0 0];cbrew([1,2,4,8],:)]
    vars = {'hetN2O5_H2O','hetCLONO2_HCL','hetHOCL_HCL','hetHOBR_HCL','hetN2O5_HCL'};
    vartit = {'het N2O5+H2O','het CLONO2+HCL','het HOCL+HCL','het HOBR+HCL','het N2O5+HCL'};
    lstyle = {'-','-','-',':','--'};
    for i = 1:length(vars)
    
        ph(i) = plot(1:365,d.doublelinear.ratesDayAverage.(vars{i}),...
            'LineStyle',lstyle{i},'color',cbrewtouse(i,:),'LineWidth',lwidth);
        hold on
        %plot(1:365,d.control.ratesDayAverage.(vars{i}),'--','color',cbrew(i,:),'LineWidth',lwidth);
    end
    legend(ph,vartit,'fontsize',fsize,'box','off')
    tickout = monthtick('short',0);
    set(gca,'xtick',tickout.tick,'xticklabels',tickout.monthnames,'fontsize',fsize);
    addLabels(fsize,'2020 45S Box model heterogeneous reaction rates','Month','molecules/cm^3/s')
    
    savefigure([inputs.outputdir,'figures/'],['hetreactionsrates'],1,0,0,0);
end
createfig('medium','on')
lwidth = 3;
fsize = 18;
cbrew = cbrewer('qual','Set1',10);
cbrewtouse = [[0 0 0];cbrew([1,2,4,8],:)];
vars = {'NO2'};
vartit = {'HCL'};
lstyle = {'-','-','-',':','--'};
for i = 1:length(vars)

    ph(i) = plot(1:365,d.doublelinear.dayAverage.(vars{i}),...
        'LineStyle',lstyle{i},'color',cbrewtouse(i,:),'LineWidth',lwidth);
    hold on
    plot(1:365,d.doublelinear2.dayAverage.(vars{i}),'--','color',cbrew(i,:),'LineWidth',lwidth);
end
legend(ph,vartit,'fontsize',fsize,'box','off')
tickout = monthtick('short',0);
set(gca,'xtick',tickout.tick,'xticklabels',tickout.monthnames,'fontsize',fsize);
addLabels(fsize,'2020 45S, 19 km, Box model heterogeneous reaction rates','Month','molecules/cm^3')

%savefigure([inputs.outputdir,'figures/'],['hetreactionsrates'],1,0,0,0);