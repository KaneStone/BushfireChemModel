% plot lat pres

[~,SD.data,~] = Read_in_netcdf('/Users/kanestone/work/data/Bushfire/2023/SDCARMA_pyrocb_derecho_2020-2021.cam.h0.nc');
[~,control.data,~] = Read_in_netcdf('/Users/kanestone/work/data/Bushfire/control/out_SD_control.nc');

%% remove bad data points

temp = squeeze(SD.data.T(9,20,:));
temp2 = squeeze(control.data.T(9,20,:));
diff1 = diff(temp);
diff2 = diff(temp2);
badind = find(diff1 < -15)+1;
badind2 = find(diff2 < -15)+1;
vars = {'HCL','CLO','CLONO2','T'};
for i = 1:length(vars)
    for l = 1:length(badind)
        SD.data.(vars{i})(:,:,badind(l)) = nanmean(cat(3,SD.data.(vars{i})(:,:,badind(l)-1),SD.data.(vars{i})(:,:,badind(l)+1)),3);                
        %olddata.data.(vars{i})(:,:,badind(l)) = nanmean(cat(3,olddata.data.(vars{i})(:,:,badind(l)-1),olddata.data.(vars{i})(:,:,badind(l)+1)),3);        
    end   
    for l = 1:length(badind2)
        control.data.(vars{i})(:,:,badind2(l)) = nanmean(cat(3,control.data.(vars{i})(:,:,badind2(l)-1),control.data.(vars{i})(:,:,badind2(l)+1)),3);        
    end
end

%%

for i = 1:length(vars)
    [verticalSD.(vars{i}),altgrid,rpres] = calculatePressureAltitudeSE(vars{i},SD,1:40);  
    [verticalControl.(vars{i}),altgrid,rpres] = calculatePressureAltitudeSE(vars{i},control,1:40);  
end

%% take monthly average
% month start and end dates\
year = 2022;
tick = monthtick('short',1);
mon = 7;
if year == 2020
    yearname = '2020';
else
    yearname = '2021';
    mlstick.tick = tick.tick;
    tick.tick = tick.tick+365;
    
end
monname = monthnames(mon,'standard','long');
Mayse = [tick.tick(mon),tick.tick(mon+1)-1]+7;
[~,ind1] = min(abs(control.data.time - Mayse(1)));
[~,ind2] = min(abs(control.data.time - Mayse(2)));

%calculate difference between SD and control
scale = 1e9;
for i = 1:length(vars)
    anomaly.(vars{i}) = mean(verticalSD.(vars{i}).regPresregrid(:,:,ind1:ind2) - ...
        verticalControl.(vars{i}).regPresregrid(:,:,ind1:ind2),3,'omitnan').*scale;

    
end

%% read in MLS
lats = [-50 -40];
mlstype = 'PressureZM';
mlsvar = 'HCL';
switch mlsvar
    case 'N2O'
        climsmls = -.05:.005:.05;
        scalemls = 1e6;
        clabel = 'ppm anomaly';
    otherwise
        climsmls = -.5:.05:.5;
        scalemls = 1e9;
        clabel = 'ppb anomaly';
end
mls = readinMLS(lats,mlstype,'work');
Maysemls = [mlstick.tick(mon),mlstick.tick(mon+1)-1];
mls2020 = mls.(mlsvar)(:,:,:,end-1);
mls2021 = mls.(mlsvar)(:,:,:,end);
mlsclim = mean(mls.(mlsvar)(:,:,:,1:end-2),4,'omitnan');
if year == 2020
    mlsanomaly = mean(mls2020(:,:,Maysemls(1):Maysemls(2)) - mlsclim(:,:,Maysemls(1):Maysemls(2)),3,'omitnan').*scalemls;
else
    mlsanomaly = mean(mls2021(:,:,Maysemls(1):Maysemls(2)) - mlsclim(:,:,Maysemls(1):Maysemls(2)),3,'omitnan').*scalemls;
end

datatoplot.values = mlsanomaly;
datatoplot.latitude = mls.lat;
datatoplot.pressure = mls.lev2;

plotlatpres(datatoplot,climsmls,['MLS ', mlsvar, ', ',monname,' ',num2str(year),' anomaly'],clabel);
outdir = '/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushfireChemistry/2023update/DiagnosticPlots/';
filename = ['MLS_HCL','_LatPres_anomaly_',monname,'_',yearname];
savefigure(outdir,filename,1,0,0,0);

%% MLS line plots
% mls N2O anomaly
% daily anomalies
% dailyclim = squeeze(mean(mls.N2O(10,8,:,:),4,'omitnan'));
% allextract = squeeze(mls.N2O(10,8,:,:));
% allanomaly = allextract - dailyclim;
% 
% dailyclim2 = squeeze(mean(mls.HCL(10,8,:,:),4,'omitnan'));
% allextract2 = squeeze(mls.HCL(10,8,:,:));
% allanomaly2 = allextract2 - dailyclim2;

% take monthly average of MLS data
mlstick2 = mlstick.tick;
mlstick2(end+1) = 366;
for i = 1:12
    mlsmonthlyHCL(:,:,i,:) = mean(mls.HCL(:,:,mlstick.tick(i):mlstick.tick(i)+1,:),3,'omitnan');
    mlsmonthlyN2O(:,:,i,:) = mean(mls.N2O(:,:,mlstick.tick(i):mlstick.tick(i)+1,:),3,'omitnan');
end
dailyclim = squeeze(mean(mlsmonthlyN2O(20,15,:,:),4,'omitnan'));
allextract = squeeze(mlsmonthlyN2O(20,15,:,:));
allanomaly = allextract - dailyclim;

dailyclim2 = squeeze(mean(mlsmonthlyHCL(20,15,:,:),4,'omitnan'));
allextract2 = squeeze(mlsmonthlyHCL(20,15,:,:));
allanomaly2 = allextract2 - dailyclim2;
createfig('medium','on');
plot(allanomaly(:))
%ylim([-4e-8 4e-8])
hold on
yyaxis right
plot(allanomaly2(:))
%ylim([-6e-10 6e-10])
%% plotting
clims.HCL = -.5:.05:.5;
clims.CLONO2 = -.5:.05:.5;
clims.CLO = -.05:.005:.05;
outdir = '/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushfireChemistry/2023update/DiagnosticPlots/';
for i = 1:length(vars)
    datatoplot.values = anomaly.(vars{i});
    datatoplot.latitude = control.data.lat;
    datatoplot.pressure = rpres./100;
    plotlatpres(datatoplot,clims.(vars{i}),[vars{i}, ', ',monname,' ',yearname,' anomaly'],'ppb anomaly');
    filename = [vars{i},'_LatPres_anomaly_',monname,'_',yearname];
    savefigure(outdir,filename,1,0,0,0);
end



