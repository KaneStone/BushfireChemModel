% testing daytime NO2 and NO ratios

clear all
inputs = runinputs;
inputs.fluxcorrections = 0;
inputs.altitude = 19;
% Read in profiles then select by layer
[atmosphere,variables] = initializevars(inputs);


d.pyrocb = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours.mat']);

d.pyrocb2 = load([inputs.outputdir,'runoutput/','doublelinearnomix','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_nosoa_inmixed.mat']);

d.control = load([inputs.outputdir,'runoutput/','control','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_2years.mat']);

d.summerday = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_NOY_SummerDayLength.mat']);

d.summerintensity = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_NOY_SummerIntensity.mat']);

d.winterday = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_ALL_WinterDayLength.mat']);

d.winterintensity = load([inputs.outputdir,'runoutput/','constantdoublelinear','_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours_NOY_WinterIntensity.mat']);

%% find daytime
[photoout,photoload,photolength] = loadphoto(inputs);
pnames = TUVnamelist;
% for i = 1:35040
%     step = initializestep(inputs,i,photolength);
%     SZA(i) = calcSZA(inputs,step);
%     %step.stephour = step.stephour+.25;
%     if i == 96
%         a = 1
%     end
% end
secondyear = 0;%365*96;
%count = 1;
runcase = {'pyrocb','control'};
for j = 1:length(runcase)
    count = 1;
    for i = 1:365
        if i == 16
            a = 1;
        end
        photoday = photoload.pout(count:count+95,7);
        photodayinterp = interp1(1:96,photoday,1:.01:97,'cubic');
        dawn = 500+find(photodayinterp(1:4900) <= 1e-3,1,'last'); 
        dusk = -500+4800+find(photodayinterp(4800:9600) <= 1e-3,1,'first'); 
        NOinterp = interp1(1:96,d.(runcase{j}).variables.NO(secondyear+(i-1)*96+1:secondyear+(i-1)*96+96),1:.01:97,'cubic');
        NO2interp = interp1(1:96,d.(runcase{j}).variables.NO2(secondyear+(i-1)*96+1:secondyear+(i-1)*96+96),1:.01:97,'cubic');
        CLOinterp = interp1(1:96,d.(runcase{j}).variables.CLO(secondyear+(i-1)*96+1:secondyear+(i-1)*96+96),1:.01:97,'cubic');
        d.(runcase{j}).daytimeAverage.NO(i) = mean(NOinterp(dawn:dusk));
        d.(runcase{j}).daytimeAverage.NO2(i) = mean(NO2interp(dawn:dusk));
        d.(runcase{j}).daytimeAverage.CLO(i) = mean(NO2interp(dawn:dusk));
        d.(runcase{j}).nighttimeAverage.CLO(i) = mean(CLOinterp(dawn:dusk));
        % dawn = 5+find(photoload.pout(count:count+48,7) <= 1e-5,1,'last'); 
        % dusk = -5+48+find(photoload.pout(count+48:count+95,7) <= 1e-5,1,'first'); 
        
        % d.(runcase{j}).daytimeAverage.NO(i) = mean(d.(runcase{j}).variables.NO(secondyear+(i-1)*96+dawn:secondyear+(i-1)*96+dusk));
        % d.(runcase{j}).daytimeAverage.NO2(i) = mean(d.(runcase{j}).variables.NO2(secondyear+(i-1)*96+dawn:secondyear+(i-1)*96+dusk));
        count = count+96;

        
    end
end

%% try interpolating

test = smooth(d.control.daytimeAverage.NO,14,'rloess');
test2 = smooth(d.control.daytimeAverage.NO2,14,'rloess');
% 
% for i = 1:365
%     %fixing low temporal res issues
%     if i > 3 && i < 180
%         if d.(runcase{j}).daytimeAverage.NO(i) < mean(d.(runcase{j}).daytimeAverage.NO([i-3:i-1,i+1:i+3]))
%             d.(runcase{j}).daytimeAverage.NO(i) = mean(d.(runcase{j}).daytimeAverage.NO([i-1,i+1:i+2]));
%         end
%         if d.(runcase{j}).daytimeAverage.NO2(i) > mean(d.(runcase{j}).daytimeAverage.NO2([i-3:i-1,i+1:i+3]))
%             d.(runcase{j}).daytimeAverage.NO2(i) = mean([d.(runcase{j}).daytimeAverage.NO2(i-1),d.(runcase{j}).daytimeAverage.NO2(i+1)]);
%         end
%     end
% 
%     if i > 180 && i < 360
%         if d.(runcase{j}).daytimeAverage.NO(i) > mean(d.(runcase{j}).daytimeAverage.NO([i-3:i-1,i+1:i+3]))
%             d.(runcase{j}).daytimeAverage.NO(i) = mean(d.(runcase{j}).daytimeAverage.NO([i-2:i-1,i+1]));
%         end
%         if d.(runcase{j}).daytimeAverage.NO2(i) < mean(d.(runcase{j}).daytimeAverage.NO2([i-3:i-1,i+1:i+3]))
%             d.(runcase{j}).daytimeAverage.NO2(i) = mean([d.(runcase{j}).daytimeAverage.NO2(i-1),d.(runcase{j}).daytimeAverage.NO2(i+1)]);
%         end
%     end
% end

figure;
plot(diff(d.(runcase{2}).daytimeAverage.NO2))
hold on
plot(diff(d.(runcase{2}).daytimeAverage.NO))
legend('NO2','NO')


% figure; plot(d.(runcase).daytimeAverage.NO./d.(runcase).daytimeAverage.NO2)
% figure; plot(d.(runcase).dayAverage.NO./d.(runcase).dayAverage.NO2); xlim([1,365])
% figure; plot(d.(runcase).dayAverage.O);
% figure; plot(d.(runcase).daytimeAverage.NO2);

%%
cbrew = cbrewer('qual','Set1',10);
tickout = monthtick('short',0);    
createfig('medium','on')
tiledlayout(2,2)
nexttile;
plot(d.control.dayAverage.CL,'LineWidth',2,'color',cbrew(1,:))
hold on
plot(d.pyrocb.dayAverage.CL,'LineWidth',2,'color',cbrew(2,:));
set(gca,'xtick',tickout.tick,'xticklabel',tickout.monthnames)
addLabels(18,'CL','Month','molec./cm^3')
xlim([0 366]);
legend('control','pyrocb','fontsize',18,'location','north','box','off')
nexttile;
plot(d.control.dayAverage.CLO,'LineWidth',2,'color',cbrew(1,:))
hold on
plot(d.pyrocb.dayAverage.CLO,'LineWidth',2,'color',cbrew(2,:));
set(gca,'xtick',tickout.tick,'xticklabel',tickout.monthnames)
addLabels(18,'CLO','Month','molec./cm^3')
xlim([0 366]);

nexttile;
% plot(d.control.daytimeAverage.NO2,'LineWidth',2,'color',cbrew(1,:))
% hold on
% plot(d.control.daytimeAverage.NO,'LineWidth',2,'color',cbrew(1,:),'LineStyle','--');
plot(d.pyrocb.daytimeAverage.NO2,'LineWidth',2,'color',cbrew(2,:));
hold on;
plot(d.pyrocb.daytimeAverage.NO,'LineWidth',2,'color',cbrew(2,:),'LineStyle','--');
set(gca,'xtick',tickout.tick,'xticklabel',tickout.monthnames)
addLabels(18,'Daytime NO and NO2','Month','molec./cm^3')
xlim([0 366]);
legend('NO2','NO','fontsize',18,'location','north','box','off')

nexttile;
% plot(d.control.daytimeAverage.NO2,'LineWidth',2,'color',cbrew(1,:))
% hold on
% plot(d.control.daytimeAverage.NO,'LineWidth',2,'color',cbrew(1,:),'LineStyle','--');
plot(d.pyrocb.dayAverage.HCL - d.control.dayAverage.HCL,'LineWidth',2,'color',cbrew(2,:));
hold on;
plot(d.pyrocb.dayAverage.CLONO2 - d.control.dayAverage.CLONO2,'LineWidth',2,'color',cbrew(2,:),'LineStyle','--');
plot(abs(d.pyrocb.dayAverage.HCL - d.control.dayAverage.HCL) - (d.pyrocb.dayAverage.CLONO2 - d.control.dayAverage.CLONO2),'color',cbrew(1,:),'LineWidth',2)
plot([0 365],[0 0],'--k','LineWidth',1.5)
set(gca,'xtick',tickout.tick,'xticklabel',tickout.monthnames)
addLabels(18,'HCL and CLONO2','Month','molec./cm^3')
xlim([0 366]);
legend('HCL','CLONO2','excess CL','fontsize',18,'location','northwest','box','off')
savefigure(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushfireChemistry/BoxModelOutput/seasonality/'],['seasonality_reasoning'],1,0,0,0);

%% 
fig = figure;
set(fig,'color','white','position',[100 100 1400 700]);
tiledlayout(1,2)
nexttile;
plot(d.control.variables.NO2(97:97+95),'LineWidth',2);
hold on
plot(d.control.variables.NO(97:97+95),'LineWidth',2);
%plot([0 365],[0 0],'--k','LineWidth',1.5)
set(gca,'xtick',1:12:96,'xticklabel',[0:3:24])
legend('NO2','NO','fontsize',18,'location','northwest','box','off')
addLabels(18,'NOx diurnal cycle winter 45S','Hour','molec./cm^3')

nexttile;
plot(d.control.variables.NO2(180*96+1:180*96+96),'LineWidth',2);
hold on
plot(d.control.variables.NO(180*96+1:180*96+96),'LineWidth',2);
%plot([0 365],[0 0],'--k','LineWidth',1.5)
set(gca,'xtick',1:12:96,'xticklabel',[0:3:24])
addLabels(18,'NOx diurnal cycle summer 45S','Hour','molec./cm^3')
savefigure(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushfireChemistry/BoxModelOutput/seasonality/'],['NOx_diurnal'],1,0,0,0);
% 
% 
% plot(d.control.variables.N2O5(97:97+95));
% yyaxis right
% hold on
% plot(d.control.variables.NO3(97:97+95));


%%
figure; plot(d.control.ratesDayAverage.HCL_OH);
hold on; plot(d.control.ratesDayAverage.CL_CH4)

figure; plot(d.pyrocb.ratesDayAverage.HCL_OH);
hold on; plot(d.pyrocb.ratesDayAverage.CL_CH4);


%%

figure;
plot(d.(runcase{2}).daytimeAverage.NO2)
hold on
plot(d.(runcase{2}).daytimeAverage.NO)
legend('NO2','NO')

figure;
plot(diff(d.(runcase{2}).daytimeAverage.NO2))
hold on
plot(diff(d.(runcase{2}).daytimeAverage.NO))
legend('NO2','NO')

%% plot normalized rates
tm = 366:366+364;
figure; plot(d.control.ratesDayAverage.CLO_NO(tm)./max(d.control.ratesDayAverage.CLO_NO(tm)));
hold on
plot(d.control.ratesDayAverage.CLO_NO2_M(tm)./max(d.control.ratesDayAverage.CLO_NO2_M(tm)));
plot(d.control.ratesDayAverage.CL_CH4(tm)./max(d.control.ratesDayAverage.CL_CH4(tm)));


figure; plot(d.control.ratesDayAverage.CLO_NO2_M(tm)./max(d.control.ratesDayAverage.CLO_NO2_M(tm)));
hold on
plot(d.control.ratesDayAverage.CL_CH4(tm)./max(d.control.ratesDayAverage.CL_CH4(tm)));

figure; plot(d.control.ratesDayAverage.HCL_OH(tm)./max(d.control.ratesDayAverage.HCL_OH(tm)));
hold on
plot(d.control.ratesDayAverage.CLO_NO(tm)./max(d.control.ratesDayAverage.CLO_NO(tm)));

%%
figure;
plot(diff(d.(runcase{1}).dayAverage.CL./d.(runcase{1}).dayAverage.CLO))


legend('NO2','NO')


figure;
plot(d.control.ratesDayAverage.CLO_NO(366:end))
hold on
yyaxis right
plot(d.control.ratesDayAverage.CLO_NO2_M(366:end))
ylim([.3e4 1.2e4])
legend('CLO+NO','CLO+NO2')

figure;
plot(diff(d.(runcase{2}).ratesDayAverage.CLO_NO(366:end)))
hold on
yyaxis right
plot(diff(d.(runcase{2}).ratesDayAverage.CLO_NO2_M(366:end)))
legend('CLO+NO','CLO+NO2')

figure;
plot(diff(d.(runcase{1}).ratesDayAverage.CL_CH4(366:end)))
hold on
plot(diff(d.(runcase{1}).ratesDayAverage.HCL_OH(366:end)))
legend('CL_CH4','CLO+NO2')
