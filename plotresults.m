% plotting 1D model
inputs = runinputs;
inputs.fluxcorrections = 0;
inputs.altitude = 18;
% Read in profiles then select by layer
[atmosphere,variables] = initializevars(inputs);

d.control = load([inputs.outputdir,'runoutput/','control','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours.mat']);

d.doublelinear = load([inputs.outputdir,'runoutput/','doublelinear','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours.mat']);

d.doublelinear2 = load([inputs.outputdir,'runoutput/','doublelinear','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_testingtempCH3O2.mat']);


%% if compare CARMA
comparecarma = 1;
if comparecarma
    [~,olddata.data,~] = Read_in_netcdf('/Volumes/ExternalOne/work/data/Bushfire/CESM/finalensembles/SD/raw/out_SD_hexanoic_nowt.nc');
    [~,oldcontrol.data,~] = Read_in_netcdf('/Volumes/ExternalOne/work/data/Bushfire/CESM/finalensembles/SD/raw/out_SD_control.nc');
%%
    temp = squeeze(olddata.data.T(9,20,:));
    temp2 = squeeze(oldcontrol.data.T(9,20,:));
    diff1 = diff(temp);
    badind = find(diff1 < -10)+1;
    diff2 = diff(temp2);
    badind2 = find(diff2 < -10)+1;
        
    vars = {'HCL','CLONO2','O3','CH2O'};
    for i = 1:length(vars)
        
        for l = 1:length(badind)
            olddata.data.(vars{i})(:,:,badind(l)) = nanmean(cat(3,olddata.data.(vars{i})(:,:,badind(l)-1),olddata.data.(vars{i})(:,:,badind(l)+1)),3);        
            oldcontrol.data.(vars{i})(:,:,badind2(l)) = nanmean(cat(3,oldcontrol.data.(vars{i})(:,:,badind2(l)-1),oldcontrol.data.(vars{i})(:,:,badind2(l)+1)),3);
            if i == length(vars)
                  olddata.data.T(:,:,badind(l)) = nanmean(cat(3,olddata.data.T(:,:,badind(l)-1),olddata.data.T(:,:,badind(l)+1)),3);
                  oldcontrol.data.T(:,:,badind2(l)) = nanmean(cat(3,olddata.data.T(:,:,badind2(l)-1),oldcontrol.data.T(:,:,badind2(l)+1)),3);                        
            end
        end
        
        %[vertical.(vars{i}),altgrid,rpres] = calculatePressureAltitudeSE(vars{i},data,1:40);  
        %[cvertical.(vars{i}),~,~] = calculatePressureAltitudeSE(vars{i},control,1:40);  

        [oldvertical.(vars{i}),altgrid,rpres] = calculatePressureAltitudeSE(vars{i},olddata,1:40);  
        [coldvertical.(vars{i}),~,~] = calculatePressureAltitudeSE(vars{i},oldcontrol,1:40);  
    end

    %% extract latitude range and height
    lats = [-50, -40];
    lev = 18;
    %latind = olddata.data.lat >= lats(1) & olddata.data.lat <= lats(2);
    oldlatind = olddata.data.lat >= lats(1) & olddata.data.lat <= lats(2);
    %[~,mlevind] = min(abs(lev - rpres./100));
    %latextract = data.data.lat(latind);
    oldlatextract = olddata.data.lat(oldlatind);

    % old
    for i = 1:length(vars)
        oldmodel.(vars{i}) = weightedaverage(squeeze(oldvertical.(vars{i}).regrid(oldlatind,lev,:)),oldlatextract ,1);
        oldmodel2.(vars{i}) = weightedaverage(squeeze(oldvertical.(vars{i}).regPresregrid(oldlatind,15,:)),oldlatextract ,1);
        oldmodel3.(vars{i}) = weightedaverage(squeeze(oldvertical.(vars{i}).pressureregrid(oldlatind,lev,:)),oldlatextract ,1);
        coldmodel.(vars{i}) = weightedaverage(squeeze(coldvertical.(vars{i}).regrid(oldlatind,lev,:)),oldlatextract ,1);
        
        
        
% %         % convert to vmr
        d.control.([vars{i},'vmr']) = d.control.dayAverage.(vars{i}).*inputs.k.*1e6./(atmosphere.atLevel.P(1:365).*100).*atmosphere.atLevel.T(1:365);
        d.doublelinear.([vars{i},'vmr']) = d.doublelinear.dayAverage.(vars{i}).*inputs.k.*1e6./((atmosphere.atLevel.P(1:365)).*100).*(atmosphere.atLevel.T(1:365));
%         d.doublelinear2.([vars{i},'vmr']) = d.doublelinear2.dayAverage.(vars{i}).*inputs.k.*1e6./((atmosphere.atLevel.P(1:365)).*100).*(atmosphere.atLevel.T(1:365));
% 
%         d.control.CLONO2vmr = d.control.dayAverage.CLONO2.*inputs.k.*1e6./(atmosphere.atLevel.P(1:365).*100).*atmosphere.atLevel.T(1:365);
%         d.doublelinear.CLONO2vmr = d.doublelinear.dayAverage.CLONO2.*inputs.k.*1e6./(atmosphere.atLevel.P(1:365).*100).*atmosphere.atLevel.T(1:365);
% 
%         d.control.O3vmr = d.control.dayAverage.O3.*inputs.k.*1e6./(atmosphere.atLevel.P(1:365).*100).*atmosphere.atLevel.T(1:365);
%         d.doublelinear.O3vmr = d.doublelinear.dayAverage.O3.*inputs.k.*1e6./(atmosphere.atLevel.P(1:365).*100).*atmosphere.atLevel.T(1:365);

%     oldmodelHCLlatextract = weightedaverage(squeeze(oldvertical.HCL.regrid(oldlatind,lev,:)),oldlatextract ,1);
%     oldmodelO3latextract = weightedaverage(squeeze(oldvertical.O3.regrid(oldlatind,lev,:)),oldlatextract ,1);
%     oldmodelCLONO2latextract = weightedaverage(squeeze(oldvertical.CLONO2.regrid(oldlatind,lev,:)),oldlatextract ,1);
%     oldmodelN2O5latextract = weightedaverage(squeeze(oldvertical.N2O5.regrid(oldlatind,lev,:)),oldlatextract ,1);
    end
%     coldmodelHCLlatextract = weightedaverage(squeeze(coldvertical.HCL.regrid(oldlatind,lev,:)),oldlatextract ,1);
%     coldmodelO3latextract = weightedaverage(squeeze(coldvertical.O3.regrid(oldlatind,lev,:)),oldlatextract ,1);
%     coldmodelCLONO2latextract = weightedaverage(squeeze(coldvertical.CLONO2.regrid(oldlatind,lev,:)),oldlatextract ,1);

    %%
    vars2 = {'CH2O'};
    for i = 1:length(vars2)
        createfig('medium','on')
        oldtick = [1:53]./53*12-1/53*12;
        newtick = [1:365]./365*12;
        lwidth = 3;
        
        ph1 = plot(oldtick,coldmodel.(vars2{i})(1:53),'LineWidth',lwidth,'color','k','LineStyle','--');
        hold on
        ph2 = plot(oldtick,oldmodel.(vars2{i})(1:53),'LineWidth',lwidth,'color','k');
        ph3 = plot(newtick,d.control.([vars2{i},'vmr']),'LineWidth',lwidth,'color','r','LineStyle','--');
        %ph4 = plot(newtick,d.doublelinear.([vars2{i},'vmr']),'LineWidth',lwidth,'color','r');
        ph5 = plot(newtick,d.doublelinear.([vars2{i},'vmr']),'LineWidth',lwidth,'color','r');
        %ylim([.1e-10 1.5e-10]);
    end
%     createfig('medium','on')
%     oldtick = [1:53]./53*12;
%     newtick = [1:365]./365*12;
%     lwidth = 3;
%     ph = plot(oldtick,coldmodelCLONO2latextract(1:53),'LineWidth',lwidth,'color','k');
%     hold on
%     ph2 = plot(oldtick,oldmodelCLONO2latextract(1:53),'LineWidth',lwidth,'color','k','LineStyle','--');
%     ph3 = plot(newtick,d.control.CLONO2vmr,'LineWidth',lwidth,'color','r');
%     ph4 = plot(newtick,d.doublelinear.CLONO2vmr,'LineWidth',lwidth,'color','r','LineStyle','--');
% 
%     createfig('medium','on')
%     oldtick = [1:53]./53*12;
%     newtick = [1:365]./365*12;
%     lwidth = 3;
%     ph = plot(oldtick,coldmodelO3latextract(1:53),'LineWidth',lwidth,'color','k');
%     hold on
%     ph2 = plot(oldtick,oldmodelO3latextract(1:53),'LineWidth',lwidth,'color','k','LineStyle','--');
%     ph3 = plot(newtick,d.control.O3vmr,'LineWidth',lwidth,'color','r');
%     ph4 = plot(newtick,d.doublelinear.O3vmr,'LineWidth',lwidth,'color','r','LineStyle','--');
end
% d.doublelinear_5timesSAD = load([inputs.outputdir,'data/','doublelinear','_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours_5xSAD.mat']);
%d.solubility = load([inputs.outputdir,'data/','solubility','_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours.mat']);
%d.SAD5 = load([inputs.outputdir,'data/','doublelinear','_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours_5xSAD.mat']);
% doublelinear2 = load([inputs.outputdir,'data/','doublelinear','_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours_nohclfluxcorrection.mat']);
% doublelinear3 = load([inputs.outputdir,'data/','doublelinear','_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours_nohno3fluxcorrection.mat']);
% doublelinear4 = load([inputs.outputdir,'data/','doublelinear','_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours_fluxtodummy.mat']);

%%
fsize = 18;
df = fields(d);
tickout = monthtick('short',0);
vars = {'CLONO2'};
for i = 1:length(vars)
    createfig('medium','on')
    for j = 1:length(df)
        
        ph(j) = plot(1:365,d.(df{j}).dayAverage.(vars{i}),'LineWidth',2);
        hold on                
    end
    
    set(gca,'xtick',tickout.tick,'xticklabels',tickout.monthnames,'fontsize',fsize);
    xlabel('Month','fontsize',fsize+2);
    ylabel('Number Density (molecules cm^-^3)','fontsize',fsize+2);
    title([inputs.runtype,', ',vars{i}],'fontsize',fsize+4);    
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
    
    set(gca,'xtick',tickout.tick,'xticklabels',tickout.monthnames,'fontsize',fsize);
    xlabel('Month','fontsize',fsize+2);
    ylabel('Number Density (molecules cm^-^3)','fontsize',fsize+2);
    title([inputs.runtype,', ',vars{i}],'fontsize',fsize+4);    
    lh = legend(ph2,df2,'location','southeastoutside','box','off');
    %set(gca,'Yscale','log')
  %  savefigure([inputs.outputdir,'figures/'],[inputs.runtype,'_',inputs.fluxcorrections,'_',vars{i},sprintf('%.2f',inputs.hourstep),'hours'],1,0,0,0);
end

%% plot rates
%%
fsize = 18;
df = fields(d);
tickout = monthtick('short',0);
vars = {'CLO_CH3O2'};
for i = 1:length(vars)
    createfig('medium','on')
    for j = 1:length(df)
        
        ph(j) = plot(1:365,d.(df{j}).ratesDayAverage.(vars{i}),'LineWidth',2);
        hold on                
    end
    
    set(gca,'xtick',tickout.tick,'xticklabels',tickout.monthnames,'fontsize',fsize);
    xlabel('Month','fontsize',fsize+2);
    ylabel('Number Density (molecules cm^-^3)','fontsize',fsize+2);
    title([inputs.runtype,', ',vars{i}],'fontsize',fsize+4);    
    lh = legend(ph,df,'location','southeastoutside','box','off');
    set(gca,'Yscale','log')
  %  savefigure([inputs.outputdir,'figures/'],[inputs.runtype,'_',inputs.fluxcorrections,'_',vars{i},sprintf('%.2f',inputs.hourstep),'hours'],1,0,0,0);
end