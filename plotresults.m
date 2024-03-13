% plotting 1D model
inputs = runinputs;
inputs.fluxcorrections = 0;
inputs.altitude = 19;
% Read in profiles then select by layer
[atmosphere,variables] = initializevars(inputs);

d.control = load([inputs.outputdir,'runoutput/','control','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours.mat']);

d.doublelinear = load([inputs.outputdir,'runoutput/','doublelinear','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours.mat']);

d.doublelinear2 = load([inputs.outputdir,'runoutput/','2xorganics','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours.mat']);

d.doublelinear3 = load([inputs.outputdir,'runoutput/','2xorganics','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_aheffectsall.mat']);

d.doublelinear4 = load([inputs.outputdir,'runoutput/','2xorganics','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_aheffectsall_4x.mat']);

% d.doublelinear5 = load([inputs.outputdir,'runoutput/','doublelinear','_',num2str(inputs.altitude),...
%     'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
%     ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_newah_quadH_HCL.mat']);

% d.doublelinear4 = load([inputs.outputdir,'runoutput/','doublelinear_wtsulf','_',num2str(inputs.altitude),...
%     'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
%     ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_ahreaction_difx1000.mat']);

boxfields = fieldnames(d);
% d.doublelinear3 = load([inputs.outputdir,'runoutput/','doublelinear','_',num2str(inputs.altitude),...
%     'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
%     ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hoursno-n2o5onlyx10.mat']);

% d.doublelinear4 = load([inputs.outputdir,'runoutput/','doublelinear','_',num2str(inputs.altitude),...
%     'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
%     ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hoursnon2o5onlyx10.mat']);
% 
% d.doublelinear5 = load([inputs.outputdir,'runoutput/','doublelinear','_',num2str(inputs.altitude),...
%     'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
%     ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_newahreaction.mat']);

%% if compare CARMA
comparecarma = 1;
if comparecarma
    % [~,olddata.data,~] = Read_in_netcdf('/Volumes/ExternalOne/work/data/Bushfire/CESM/finalensembles/SD/raw/out_SD_hexanoic_nowt.nc');
    % [~,oldcontrol.data,~] = Read_in_netcdf('/Volumes/ExternalOne/work/data/Bushfire/CESM/finalensembles/SD/raw/out_SD_control.nc');

    [~,olddata.data,~] = Read_in_netcdf('/Users/kanestone/work/data/Bushfire/SD/raw/out_SD_hexanoic_nowt.nc');
    [~,oldcontrol.data,~] = Read_in_netcdf('/Users/kanestone/work/data/Bushfire/SD/raw/out_SD_control.nc');
    [~,oldn2o5.data,~] = Read_in_netcdf('/Users/kanestone/work/data/Bushfire/SD/raw/out_SD_n2o5.nc');
%%
    temp = squeeze(olddata.data.T(9,20,:));
    temp2 = squeeze(oldcontrol.data.T(9,20,:));
    diff1 = diff(temp);
    badind = find(diff1 < -10)+1;
    diff2 = diff(temp2);
    badind2 = find(diff2 < -10)+1;
        
    %vars = {'NO2','NO'};
    vars = {'HCL','O3','CLONO2','CLO','HOCL'};
    for i = 1:length(vars)
        
        for l = 1:length(badind)
            olddata.data.(vars{i})(:,:,badind(l)) = nanmean(cat(3,olddata.data.(vars{i})(:,:,badind(l)-1),olddata.data.(vars{i})(:,:,badind(l)+1)),3);        
            oldcontrol.data.(vars{i})(:,:,badind2(l)) = nanmean(cat(3,oldcontrol.data.(vars{i})(:,:,badind2(l)-1),oldcontrol.data.(vars{i})(:,:,badind2(l)+1)),3);
            oldn2o5.data.(vars{i})(:,:,badind2(l)) = nanmean(cat(3,oldn2o5.data.(vars{i})(:,:,badind2(l)-1),oldn2o5.data.(vars{i})(:,:,badind2(l)+1)),3);
            if i == 1
                  olddata.data.T(:,:,badind(l)) = nanmean(cat(3,olddata.data.T(:,:,badind(l)-1),olddata.data.T(:,:,badind(l)+1)),3);
                  oldcontrol.data.T(:,:,badind2(l)) = nanmean(cat(3,olddata.data.T(:,:,badind2(l)-1),oldcontrol.data.T(:,:,badind2(l)+1)),3);                        
                  oldn2o5.data.T(:,:,badind2(l)) = nanmean(cat(3,olddata.data.T(:,:,badind2(l)-1),oldn2o5.data.T(:,:,badind2(l)+1)),3);                        
            end
        end
        
        %[vertical.(vars{i}),altgrid,rpres] = calculatePressureAltitudeSE(vars{i},data,1:40);  
        %[cvertical.(vars{i}),~,~] = calculatePressureAltitudeSE(vars{i},control,1:40);  

        [oldvertical.(vars{i}),altgrid,rpres] = calculatePressureAltitudeSE(vars{i},olddata,1:40);  
        [coldvertical.(vars{i}),~,~] = calculatePressureAltitudeSE(vars{i},oldcontrol,1:40);  
        [noldvertical.(vars{i}),~,~] = calculatePressureAltitudeSE(vars{i},oldn2o5,1:40);  
    end

    %% extract latitude range and height
    lats = [-45, -40];
    lev = 19;
    %latind = olddata.data.lat >= lats(1) & olddata.data.lat <= lats(2);
    oldlatind = olddata.data.lat >= lats(1) & olddata.data.lat <= lats(2);
    %[~,mlevind] = min(abs(lev - rpres./100));
    %latextract = data.data.lat(latind);
    oldlatextract = olddata.data.lat(oldlatind);

    % old
    for i = 1:length(vars)
        oldmodel.(vars{i}) = weightedaverage(squeeze(oldvertical.(vars{i}).concregrid(oldlatind,lev,:)),oldlatextract ,1);
        oldmodel2.(vars{i}) = weightedaverage(squeeze(oldvertical.(vars{i}).regPresregrid(oldlatind,15,:)),oldlatextract ,1);
        oldmodel3.(vars{i}) = weightedaverage(squeeze(oldvertical.(vars{i}).pressureregrid(oldlatind,lev,:)),oldlatextract ,1);
        coldmodel.(vars{i}) = weightedaverage(squeeze(coldvertical.(vars{i}).concregrid(oldlatind,lev,:)),oldlatextract ,1);
        noldmodel.(vars{i}) = weightedaverage(squeeze(noldvertical.(vars{i}).concregrid(oldlatind,lev,:)),oldlatextract ,1);
        
        
        
% %         % convert to vmr
        ln = length(d.control.dayAverage.(vars{i}));
        % d.control.([vars{i},'vmr']) = d.control.dayAverage.(vars{i}).*inputs.k.*1e6./(atmosphere.atLevel.P(1:ln).*100).*atmosphere.atLevel.T(1:ln);
        % d.doublelinear.([vars{i},'vmr']) = d.doublelinear.dayAverage.(vars{i}).*inputs.k.*1e6./((atmosphere.atLevel.P(1:ln)).*100).*(atmosphere.atLevel.T(1:ln));
        % d.doublelinear2.([vars{i},'vmr']) = d.doublelinear2.dayAverage.(vars{i}).*inputs.k.*1e6./((atmosphere.atLevel.P(1:ln)).*100).*(atmosphere.atLevel.T(1:ln));
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
    NOX = 0;
    if NOX
        oldmodel.NOX = oldmodel.NO2 + oldmodel.NO;
        coldmodel.NOX = coldmodel.NO2 + coldmodel.NO;
        noldmodel.NOX = noldmodel.NO2 + noldmodel.NO;
        for i = 1:length(boxfields)
            d.(boxfields{i}).dayAverage.NOX = d.(boxfields{i}).dayAverage.NO2 + d.(boxfields{i}).dayAverage.NO;
        end
        % d.doublelinear.dayAverage.NOX = d.doublelinear.dayAverage.NO2 + d.doublelinear.dayAverage.NO;
        % d.doublelinear2.dayAverage.NOX = d.doublelinear2.dayAverage.NO2 + d.doublelinear2.dayAverage.NO;
        % %d.doublelinear3.dayAverage.NOX = d.doublelinear3.dayAverage.NO2 + d.doublelinear3.dayAverage.NO;
        % d.doublelinear4.dayAverage.NOX = d.doublelinear4.dayAverage.NO2 + d.doublelinear4.dayAverage.NO;
        % d.doublelinear5.dayAverage.NOX = d.doublelinear5.dayAverage.NO2 + d.doublelinear5.dayAverage.NO;
    end
    %%
    
    vars2 = {'HCL','HOCL','CLONO2','CLO','O3'};
    cbrew = cbrewer('qual','Set1',10);
    for i = 1:length(vars2)
        createfig('medium','on')
        oldtick = [1:53]./53*12-1/53*12;
        
        lwidth = 3;
        
        ph1 = plot(oldtick,coldmodel.(vars2{i})(1:53),'LineWidth',lwidth,'color','k','LineStyle','--');
        hold on
        ph2 = plot(oldtick,oldmodel.(vars2{i})(1:53),'LineWidth',lwidth,'color','k');
        ph3 = plot(oldtick,noldmodel.(vars2{i})(1:53),'LineWidth',lwidth,'color',[.7  .7 .7],'LineStyle','--');
        for j = 1:length(boxfields)
            ln = length(d.(boxfields{j}).dayAverage.(vars{i}));
            newtick = [1:ln]./365*12;
            phb(j) = plot(newtick,d.(boxfields{j}).dayAverage.([vars2{i}]),'LineWidth',lwidth,'color',cbrew(j,:),'LineStyle','-');
        end
        % ph5 = plot(newtick,d.doublelinear.dayAverage.([vars2{i}]),'LineWidth',lwidth,'color',cbrew(2,:));
        % ph6 = plot(newtick,d.doublelinear2.dayAverage.([vars2{i}]),'LineWidth',lwidth,'color',cbrew(8,:));
        % %ph7 = plot(newtick,d.doublelinear3.dayAverage.([vars2{i}])(1:ln),'LineWidth',lwidth,'color',cbrew(9,:));
        % ph7 = plot(newtick,d.doublelinear4.dayAverage.([vars2{i}]),'LineWidth',lwidth,'color',cbrew(10,:));
        % ph8 = plot(newtick,d.doublelinear5.dayAverage.([vars2{i}])(1:ln),'LineWidth',lwidth,'color',cbrew(7,:));
        %ylim([.1e-10 1.5e-10]);

        fsize = 18;
        tickout = monthtick('short',0);
        set(gca,'xtick',tickout.tick./365*12,'xticklabels',tickout.monthnames,'fontsize',fsize);
        xlabel('Month','fontsize',fsize+2);
        ylabel('ND','fontsize',fsize+2);
        title(['Comparison with CARMA',', ',vars2{i},', ','45S and 19 km'],'fontsize',fsize+4);    
        lh = legend([ph1,ph2,ph3,phb],'CARMA control','CARMA solubility',...
            'CARMA N2O5 only','Box model control','Box model double linear',...
            'Box model double linear 2x organics',...                    
            'Box model double linear 2x organics ah effects all',...                    
            'Box model double linear 4x organics ah effects all',...                    
            'location','north','box','off');
            %'Box model double linear 4xMhcl and ah,aw change for reactions',...        
            %'Box model double linear 4xMhcl and ah change for reactions',...        
            

    end
    
        %'Box model double linear (no n2o5 hydrolysis x3 aerosol)',...
        
    savefigure([inputs.outputdir,'figures/'],[vars2{1},'_CARMA_reactions_ahaffectsall_2xorganics_comparison'],1,0,0,0);
    a = 1;
    %set(gca,'Yscale','log')

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
vars = {'NO2'};
for i = 1:length(vars)
    createfig('medium','on')
    for j = 1:length(df)
        
        ph(j) = plot(1:length(d.(df{j}).dayAverage.(vars{i})),d.(df{j}).dayAverage.(vars{i}),'LineWidth',2);
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