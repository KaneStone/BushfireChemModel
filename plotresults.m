% plotting 1D model
inputs = Minputs;
inputs.fluxcorrections = 0;
inputs.altitude = 20;
% Read in profiles then select by layer
[atmosphere,variables] = Initializevars(inputs);

d.control = load([inputs.outputdir,'data/','control','_',num2str(inputs.altitude),'_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours.mat']);
d.doublelinear = load([inputs.outputdir,'data/','doublelinear','_',num2str(inputs.altitude),'_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours.mat']);
%d.solubility = load([inputs.outputdir,'data/','solubility','_',num2str(inputs.altitude),'_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours.mat']);

% convert to vmr
d.control.HCLvmr = d.control.dayAverage.HCL.*inputs.k.*1e6./(atmosphere.atLevel.P(1:365).*100).*atmosphere.atLevel.T(1:365);
d.doublelinear.HCLvmr = d.doublelinear.dayAverage.HCL.*inputs.k.*1e6./(atmosphere.atLevel.P(1:365).*100).*atmosphere.atLevel.T(1:365);

d.control.CLONO2vmr = d.control.dayAverage.CLONO2.*inputs.k.*1e6./(atmosphere.atLevel.P(1:365).*100).*atmosphere.atLevel.T(1:365);
d.doublelinear.CLONO2vmr = d.doublelinear.dayAverage.CLONO2.*inputs.k.*1e6./(atmosphere.atLevel.P(1:365).*100).*atmosphere.atLevel.T(1:365);

d.control.O3vmr = d.control.dayAverage.O3.*inputs.k.*1e6./(atmosphere.atLevel.P(1:365).*100).*atmosphere.atLevel.T(1:365);
d.doublelinear.O3vmr = d.doublelinear.dayAverage.O3.*inputs.k.*1e6./(atmosphere.atLevel.P(1:365).*100).*atmosphere.atLevel.T(1:365);

%%
[~,olddata.data,~] = Read_in_netcdf('/Volumes/ExternalOne/work/data/Bushfire/CESM/finalensembles/SD/raw/out_SD_hexanoic_nowt.nc');
[~,oldcontrol.data,~] = Read_in_netcdf('/Volumes/ExternalOne/work/data/Bushfire/CESM/finalensembles/SD/raw/out_SD_control.nc');

vars = {'O3','HCL','CLONO2'};
for i = 1:length(vars)
    %[vertical.(vars{i}),altgrid,rpres] = calculatePressureAltitudeSE(vars{i},data,1:40);  
    %[cvertical.(vars{i}),~,~] = calculatePressureAltitudeSE(vars{i},control,1:40);  
    
    [oldvertical.(vars{i}),altgrid,rpres] = calculatePressureAltitudeSE(vars{i},olddata,1:40);  
    [coldvertical.(vars{i}),~,~] = calculatePressureAltitudeSE(vars{i},oldcontrol,1:40);  
end


% orgdata.data.T = data.data.T;
% [orgvertical.org,~,~] = calculatePressureAltitudeSE('XORG',orgdata,1:40);  

%% extract latitude range and height
lats = [-50, -30];
lev = 20;
%latind = olddata.data.lat >= lats(1) & olddata.data.lat <= lats(2);
oldlatind = olddata.data.lat >= lats(1) & olddata.data.lat <= lats(2);
%[~,mlevind] = min(abs(lev - rpres./100));
%latextract = data.data.lat(latind);
oldlatextract = olddata.data.lat(oldlatind);

% old
oldmodelHCLlatextract = weightedaverage(squeeze(oldvertical.HCL.regrid(oldlatind,lev,:)),oldlatextract ,1);
oldmodelO3latextract = weightedaverage(squeeze(oldvertical.O3.regrid(oldlatind,lev,:)),oldlatextract ,1);
oldmodelCLONO2latextract = weightedaverage(squeeze(oldvertical.CLONO2.regrid(oldlatind,lev,:)),oldlatextract ,1);

coldmodelHCLlatextract = weightedaverage(squeeze(coldvertical.HCL.regrid(oldlatind,lev,:)),oldlatextract ,1);
coldmodelO3latextract = weightedaverage(squeeze(coldvertical.O3.regrid(oldlatind,lev,:)),oldlatextract ,1);
coldmodelCLONO2latextract = weightedaverage(squeeze(coldvertical.CLONO2.regrid(oldlatind,lev,:)),oldlatextract ,1);

%%
createfig('medium','on')
oldtick = [1:53]./53*12;
newtick = [1:365]./365*12;
lwidth = 3;
ph = plot(oldtick,coldmodelHCLlatextract(1:53),'LineWidth',lwidth,'color','k');
hold on
ph2 = plot(oldtick,oldmodelHCLlatextract(1:53),'LineWidth',lwidth,'color','k','LineStyle','--');
ph3 = plot(newtick,d.control.HCLvmr,'LineWidth',lwidth,'color','r');
ph4 = plot(newtick,d.doublelinear.HCLvmr,'LineWidth',lwidth,'color','r','LineStyle','--');

createfig('medium','on')
oldtick = [1:53]./53*12;
newtick = [1:365]./365*12;
lwidth = 3;
ph = plot(oldtick,coldmodelCLONO2latextract(1:53),'LineWidth',lwidth,'color','k');
hold on
ph2 = plot(oldtick,oldmodelCLONO2latextract(1:53),'LineWidth',lwidth,'color','k','LineStyle','--');
ph3 = plot(newtick,d.control.CLONO2vmr,'LineWidth',lwidth,'color','k');
ph4 = plot(newtick,d.doublelinear.CLONO2vmr,'LineWidth',lwidth,'color','k','LineStyle','--');

createfig('medium','on')
oldtick = [1:53]./53*12;
newtick = [1:365]./365*12;
lwidth = 3;
ph = plot(oldtick,coldmodelO3latextract(1:53),'LineWidth',lwidth,'color','k');
hold on
ph2 = plot(oldtick,oldmodelO3latextract(1:53),'LineWidth',lwidth,'color','k','LineStyle','--');
ph3 = plot(newtick,d.control.O3vmr,'LineWidth',lwidth,'color','k');
ph4 = plot(newtick,d.doublelinear.O3vmr,'LineWidth',lwidth,'color','k','LineStyle','--');
% d.doublelinear_5timesSAD = load([inputs.outputdir,'data/','doublelinear','_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours_5xSAD.mat']);
%d.solubility = load([inputs.outputdir,'data/','solubility','_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours.mat']);
%d.SAD5 = load([inputs.outputdir,'data/','doublelinear','_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours_5xSAD.mat']);
% doublelinear2 = load([inputs.outputdir,'data/','doublelinear','_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours_nohclfluxcorrection.mat']);
% doublelinear3 = load([inputs.outputdir,'data/','doublelinear','_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours_nohno3fluxcorrection.mat']);
% doublelinear4 = load([inputs.outputdir,'data/','doublelinear','_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours_fluxtodummy.mat']);

%%
df = fields(d);
tickout = monthtick('short',0);
vars = {'CLONO2'};
for i = 1:length(vars)
    createfig('medium','on')
    for j = 1:length(df)
        
        ph(j) = plot(1:365,d.(df{j}).dayAverage.(vars{i}),'LineWidth',2);
        hold on                
    end
    
    set(gca,'xtick',tickout.tick,'xticklabels',tickout.monthnames,'fontsize',inputs.fsize);
    xlabel('Month','fontsize',inputs.fsize+2);
    ylabel('Number Density (molecules cm^-^3)','fontsize',inputs.fsize+2);
    title([inputs.runtype,', ',vars{i}],'fontsize',inputs.fsize+4);    
    lh = legend(ph,df,'location','southeastoutside','box','off');
    set(gca,'Yscale','log')
  %  savefigure([inputs.outputdir,'figures/'],[inputs.runtype,'_',inputs.fluxcorrections,'_',vars{i},sprintf('%.2f',inputs.hourstep),'hours'],1,0,0,0);
end

%%
df2 = df
df2(1) = [];
for i = 1:length(vars)
    createfig('medium','on')
    for j = 1:length(df2)
        
        ph2(j) = plot(1:365,d.(df2{j}).dayAverage.(vars{i}) - d.(df{1}).dayAverage.(vars{i}),'LineWidth',2);
        hold on                
    end
    
    set(gca,'xtick',tickout.tick,'xticklabels',tickout.monthnames,'fontsize',inputs.fsize);
    xlabel('Month','fontsize',inputs.fsize+2);
    ylabel('Number Density (molecules cm^-^3)','fontsize',inputs.fsize+2);
    title([inputs.runtype,', ',vars{i}],'fontsize',inputs.fsize+4);    
    lh = legend(ph2,df2,'location','southeastoutside','box','off');
    %set(gca,'Yscale','log')
  %  savefigure([inputs.outputdir,'figures/'],[inputs.runtype,'_',inputs.fluxcorrections,'_',vars{i},sprintf('%.2f',inputs.hourstep),'hours'],1,0,0,0);
end