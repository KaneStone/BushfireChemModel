% plot box HOBR rates

inputs = runinputs;
inputs.fluxcorrections = 0;
inputs.altitude = 19;
% Read in profiles then select by layer
[atmosphere,variables] = initializevars(inputs);

d.control = load([inputs.outputdir,'runoutput/','control','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_ghobrtest.mat']);

d.ghcl = load([inputs.outputdir,'runoutput/','ghcl','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours.mat']);

%%
plotrates = 1;
if plotrates
    createfig('large','on')
    tiledlayout(2,1)
    nexttile;
    
    lwidth = 3;
    fsize = 18;
    cbrew = cbrewer('qual','Set1',10);
    cbrewtouse = [[0 0 0];cbrew([1,2,4,8],:)]
    vars = {'hetHOBR_HCL'};
    vartit = {'het HOBR+HCL'};
    lstyle = {'-','-','-',':','--'};
    for i = 1:length(vars)
    
        ph(i) = plot(1:91,d.control.ratesDayAverage.(vars{i}),...
            'LineStyle',lstyle{i},'color',cbrewtouse(i+1,:),'LineWidth',lwidth);
        hold on
        plot(1:91,d.ghcl.ratesDayAverage.(vars{i}),'color',cbrewtouse(i+2,:),'LineWidth',lwidth);
    end
    legend('gamma HOBR','gamma HCL','fontsize',fsize,'box','off','location','southeast')
    tickout = monthtick('short',0);
    set(gca,'xtick',tickout.tick,'xticklabels',tickout.monthnames,'fontsize',fsize);
    addLabels(fsize,'January-March, 45S, 19 km, box model HOBR+HCL reaction rates','Day','molecules/cm^3/s')
    nexttile;
    plot((d.ghcl.ratesDayAverage.(vars{i})-d.control.ratesDayAverage.(vars{i}))./d.control.ratesDayAverage.(vars{i}).*100,...
        'color','k','LineWidth',lwidth)
    set(gca,'xtick',tickout.tick,'xticklabels',tickout.monthnames,'fontsize',fsize);
    addLabels(fsize,'(gamma hcl - gamma hobr)/gamma hobr*100','Day','percent difference')
    savefigure([inputs.outputdir,'figures/'],['ghobr_hcl'],1,0,0,0);
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