% create time series averaged over level and latitudes from model data
clear variables

runcase = 'control';
%vars = {'O3','HCL','CLONO2','CLO','CL2O2','HOCL','HNO3','O'};
%vars = {'H2', 'H2O2', 'HO2','CHO2','CL','OH','CH4','CLO','HOCL','CH3CL','CH3BR','CH2BR2','CHBR3'};
vars = {'T','O','N2O','OH','HO2','CL','BR','NO','NO2','O1D','H','NO3','N2O5','CLO','CLONO2','HCL','HOCL','CL2','H2','CH3CL','CH4','H2O2','OCLO','CL2O2',...
    'CH3O2','BRO','BRCL','CH2O','HNO3','HO2NO2','H2O','HBR',...
    'BRONO2','HOBR','CO','SULFRE','aoc','aso4','SO2','SO3','HSO3','H2SO4','SO','S','OCS','CH3OH','CH3OOH','SAD_SULFC'};
tic;
switch runcase
    case 'Solubility'
        data = readinBfolder(['/Volumes/ExternalOne/work/data/Bushfire/CESM/finalensembles/','SD/','raw','/'],'*hexanoic_nowt.nc',1); 
    otherwise
        data = readinBfolder(['/Volumes/ExternalOne/work/data/Bushfire/CESM/finalensembles/','SD/','raw','/'],'*control.nc',1); 
end
%data.data.T2 = data.data.T;
toc;

TUV = 0;

%% fix bad data points
temp = squeeze(data.data.T(9,20,:));
diff1 = diff(temp);
badind = find(diff1 < -15)+1;

lats = [-50 -40];
latind = data.data.lat >= lats(1) & data.data.lat <= lats(2);
latextract = data.data.lat(latind);

altgrid = [0:1:90];

for i = 1:length(vars)
    for l = 1:length(badind)
        data.data.(vars{i})(:,:,badind(l)) = nanmean(cat(3,data.data.(vars{i})(:,:,badind(l)-1),data.data.(vars{i})(:,:,badind(l)+1)),3);        
    end
    vartemp = vars{i};
    [vertical.(vars{i}),altgrid,rpres] = calculatePressureAltitudeSE(vartemp,data,altgrid);  
    
    for j = 1:size(vertical.(vars{i}).concregrid,2)
        zonalmean.(vars{i}).concregrid(j,:) = weightedaverage(squeeze(vertical.(vars{i}).concregrid(latind,j,:)),latextract,1);
        zonalmean.(vars{i}).vmrregrid(j,:) = weightedaverage(squeeze(vertical.(vars{i}).regrid(latind,j,:)),latextract,1);
        switch vars{i}
            case 'T'
                zonalmean.P.vmrregrid(j,:) = weightedaverage(squeeze(vertical.T.pressureregrid(latind,j,:)),latextract,1);
                zonalmean.P.concregrid(j,:) = weightedaverage(squeeze(vertical.T.pressureregrid(latind,j,:)),latextract,1);
        end
    end
    
    % for some reason I need to fix the SAD_SULFC again. I don't know why;
    switch vars{i}
        case 'SAD_SULFC'
        
%             temp = squeeze(zonalmean.SAD_SULFC.vmrregrid(20,:));
%             diff1 = diff(temp);
%             badind = find(abs(diff1) > .5e-8)+1;
%             badind(1:20) = 0;
%             for i = 1:length(badind)
%                 zonalmean.SAD_SULFC.vmrregrid(:,badind(i)) = mean([zonalmean.SAD_SULFC.vmrregrid(:,badind(i)-1),zonalmean.SAD_SULFC.vmrregrid(:,badind(i)+1)],2,'omitnan');
%             end
%             zonalmean.SAD_SULFC.vmrregrid(:,1) = zonalmean.SAD_SULFC.vmrregrid(:,3);
%             zonalmean.SAD_SULFC.vmrregrid(:,2) = zonalmean.SAD_SULFC.vmrregrid(:,3);
%             badind = find(diff1 > -.2e-8)+1;

    end
    
end

%% calculate O2 and N2
% zonalmean.O2.concregrid = 1./1.38066e-23*1e-6.*zonalmean.P.vmrregrid./zonalmean.T.vmrregrid.*.21;
% zonalmean.O2.vmrregrid = ones(size(zonalmean.O2.concregrid)).*.21;
% zonalmean.N2.concregrid = 1./1.38066e-23*1e-6.*zonalmean.P.vmrregrid./zonalmean.T.vmrregrid.*.78;
% zonalmean.N2.vmrregrid = ones(size(zonalmean.O2.concregrid)).*.78;

%% interpolate model variables that only go to 45 km or so.
vars = fields(zonalmean);
%interpolate onto daily
timeout = 1:366;
timein = -3:7:366;
for j = 1:length(vars)    
    dtemp = zonalmean.(vars{j}).vmrregrid;
    dtemp_conc = zonalmean.(vars{j}).concregrid;
    
    % removing 0s in SAD_SULFC.
    if strcmp(vars{j},'SAD_SULFC')
        for i = 1:size(dtemp,1)        
            for k = 1:size(dtemp,2)
                if dtemp(i,k) == 0 && k == 1
                    dtemp(i,k) = dtemp(i,k+1);
                elseif dtemp(i,k) == 0 && k == size(dtemp,2)
                    dtemp(i,k) = dtemp(i,k-1);
                elseif dtemp(i,k) == 0
                    dtemp(i,k) = (dtemp(i,k+1) + dtemp(i,k-1))./2;
                end
            end
        end
    end

    %
    dtemp (dtemp == 0) = NaN;
    dtempout = dtemp;
    dtempout = fillmissing(dtempout','previous')';
    dtempout2 = NaN(81,366);
    for i = 1:42
        dtempout2(i,:) = interp1(timein,dtemp(i,1:53),timeout,'linear','extrap');
    end
    
    dtemp_conc (dtemp_conc == 0) = NaN;
    dtemp_concout = dtemp_conc;
    dtemp_concout = fillmissing(dtemp_concout','previous')';
    dtemp_concout2 = NaN(81,366);
    for i = 1:42
        dtemp_concout2(i,:) = interp1(timein,dtemp_conc(i,1:53),timeout,'linear','extrap');
    end
    
    ancil.(vars{j}).vmr = dtempout2;
    ancil.(vars{j}).nd = dtemp_concout2;
    
    switch vars{j}
        case 'P'
            ancil.P = dtempout2;
        case 'T'
            ancil.T = dtempout2;
        otherwise
            ancil.(vars{j}).vmr = double(fillmissing(ancil.(vars{j}).vmr','previous')');
            ancil.(vars{j}).nd = double(fillmissing(ancil.(vars{j}).nd','previous')');
    end
    
    
    
end

%%
TUV = 1;
if TUV
    %% Read in MLS data (temperature and ozone) convert
    mlstype = 'PressureZM';
    out = readinMLS(lats,mlstype,'home');
    modellats = data.data.lat;

    % convert to altitude and compare with model
    % hypsometric
    %         data(i).altitude = (287.*squeeze(dataT(i).data.T)./9.81).*log(permute(repmat(data(i).data.PS,1,1,sz(2)),[1,3,2])./squeeze(data(i).pressure));
    %         controldata(i).altitude = (287.*squeeze(controldataT(i).data.T)./9.81).*log(permute(repmat(controldata(i).data.PS,1,1,sz(2)),[1,3,2])./squeeze(controldata(i).pressure));

    %% Read in ERA5

    ERATdir = '/Volumes/ExternalOne/work/data/ERA5/forChemModel/';
    ERAT = ncread([ERATdir,'Temperature_2010_hourly.nc'],'t');
    ERAO3 = ncread([ERATdir,'Ozone_2010_hourly.nc'],'o3');
    ERA_latitude = ncread([ERATdir,'Temperature_2010_hourly.nc'],'latitude');
    ERA_level = double(ncread([ERATdir,'Temperature_2010_hourly.nc'],'level'));

    %
    ERA5T_zonalmean = squeeze(mean(ERAT,1,'omitnan'));
    ERA5O3_zonalmean = squeeze(mean(ERAO3,1,'omitnan'));

    for i = 1:size(ERA5T_zonalmean,2)
        ERA5T_wm(i,:) = weightedaverage(squeeze(ERA5T_zonalmean(:,i,:)),ERA_latitude,1);
        ERA5O3_wm(i,:) = weightedaverage(squeeze(ERA5O3_zonalmean(:,i,:)),ERA_latitude,1);
    end

    ERA5T_day = squeeze(mean(reshape(ERA5T_wm,[5,4,365]),2));
    ERA5O3_day = squeeze(mean(reshape(ERA5O3_wm,[5,4,365]),2));

    %%

    ERA5T_day = [ERA5T_day,ERA5T_day(:,end)];
    ERA5O3_day = [ERA5O3_day,ERA5O3_day(:,end)];

    %%
    ERA5O3_day_nd = 1./1.38066e-23.*repmat(ERA_level,[1,366])./ERA5T_day.*ERA5O3_day.*1e-6;
    %%
    % adding in ERA5 to missing MLS data for TUV mainly

    mls_level_new = [flipud(ERA_level);out.lev(8:end)];
    mls_temp_new = [flipud(ERA5T_day);out.Temperatureclim(8:end,:)];
    mls_ozone_new = [flipud(ERA5O3_day);out.O3clim(8:end,:)];

    mls_ozone_new_nd = 1./1.38066e-23.*repmat(mls_level_new.*100,[1,366])./mls_temp_new.*mls_ozone_new.*1e-6;
    %%
    for k = 1:size(mls_level_new)-1                  
        if k == 1    
            altitude(k,:) = 287.*mean([repmat(273.15,[1,366]);mls_temp_new(k,:)],1,'omitnan')./9.81.*log(1013.25./mls_level_new(k));    
            altitude(k+1,:) = 287.*mean(mls_temp_new(k:k+1,:),1,'omitnan')./9.81.*log(mls_level_new(k)./mls_level_new(k+1));
        else                
            altitude(k+1,:) = 287.*mean(mls_temp_new(k:k+1,:),1,'omitnan')./9.81.*log(mls_level_new(k)./mls_level_new(k+1));
        end
    end

%             % hypsometric
%         for k = 1:size(data2(i).pressure,2)-1              
%             if k == size(data2(i).pressure,2)-1                
%                 data(i).alt2(:,sz(2),:) = (287.*273./9.81).*log(101325./squeeze(data2(i).pressure(:,k,:)));    
%                 data(i).alt2(:,k,:) = (287.*squeeze(data(i).data.T(:,k,:))./9.81).*log(squeeze(data2(i).pressure(:,k+1,:))./squeeze(data2(i).pressure(:,k,:)));
%             else                
%                 data(i).alt2(:,k,:) = (287.*squeeze(data(i).data.T(:,k,:)./9.81)).*log(squeeze(data2(i).pressure(:,k+1,:))./squeeze(data2(i).pressure(:,k,:)));
%             end
%         end
    
    
    %density = mls_level_new.*100./287.053./mls_temp_new.*1000./1e6./28.9647.*6.022e23;
    density = 1./1.38066e-23.*mls_level_new.*100./mls_temp_new.*1e-6;

    altout  = cumsum(altitude);
    altout = altout(1:48,:);


    %% now interplate everything onto regular altitude grid.    
    for i = 1:size(altitude,2)
       tempout(:,i) =  interp1(altout(:,i)./1000,squeeze(mls_temp_new(1:48,i)),altgrid,'linear','extrap');
       ozoneout(:,i) =  interp1(altout(:,i)./1000,squeeze(mls_ozone_new(1:48,i)),altgrid,'linear','extrap');
       ozoneout_nd(:,i) =  interp1(altout(:,i)./1000,squeeze(mls_ozone_new_nd(1:48,i)),altgrid,'linear','extrap');
       densityout(:,i) =  exp(interp1(altout(:,i)./1000,log(squeeze(density(1:48,i))),altgrid,'linear','extrap'));
       pressureout(:,i) =  exp(interp1(altout(:,i)./1000,log(squeeze(mls_level_new(1:48))),altgrid,'linear','extrap'));
    end

end

%%
ancil.T = double(tempout);
ancil.P = double(pressureout);
ancil.M = double(densityout);
ancil.O3.nd = double(ozoneout_nd);
ancil.O3.vmr = double(ozoneout);
ancil.altitude = double(0:90);
    %% output temperature and density data for TUV code

save(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushChemModel/Ancil/variables/','climIn',runcase,'.mat'],'ancil');
    %% smooth data



    %% save as

%     %% save TUV data
% 
%     % geotime
%     dayend = cumsum([31,29,31,30,31,30,31,31,30,31,30,31]);
%     month = 1;
%     day = 1;
%     count = 1;
%     for i = 1:366
% 
%         for j = 1:8
%             fid = fopen(['/Volumes/ExternalOne/work/data/BushfireChemModel/TUVinput/','geotime/',sprintf('%03d',i),'.',sprintf('%01d',j),'.geotime'], 'w');
%             fprintf(fid, '%.3f\n', -45);
%             fprintf(fid, '%.3f\n', 0);            
%             a = str2double('2020');            
%             fprintf(fid, '%.0f\n', a);
%             fprintf(fid, '%.0f\n', month);
%             fprintf(fid, '%.0f\n', day);      
%             fclose(fid);
% 
%             % ozone
%             fid = fopen(['/Volumes/ExternalOne/work/data/BushfireChemModel/TUVinput/','ozone/',sprintf('%03d',i),'.',sprintf('%01d',j),'.ozone'], 'w');
%             fprintf(fid, '# values from 2-74 km are from US Standard Atmosphere, 1976, for 45N, annual\n');
%             fprintf(fid, '# means.\n');
%             fprintf(fid, '# values at 0 and 1 km are filled in assuming a typical surface mixing ratio\n');
%             fprintf(fid, '# of 40 ppb\n');
%             fprintf(fid, '# total ozone (assuming linear behavior between altitude points): 349.82 DU\n');
%             fprintf(fid, '# 1st column:  Geometric Altitude (km)\n');
%             fprintf(fid, '# 2nd column:  Ozone number density (n(O3) cm-3)\n');
%             fprintf(fid, '%.0f %.3g\n', [altgrid;ozoneout_nd(:,i)']);
%             fclose(fid);
% 
%             % density
%             fid = fopen(['/Volumes/ExternalOne/work/data/BushfireChemModel/TUVinput/','density/',sprintf('%03d',i),'.',sprintf('%01d',j),'.density'], 'w');
%             fprintf(fid, '# values are from US Standard Atmosphere, 1976, for 45N, annual means\n');
%             fprintf(fid, '# 1st column:  Geometric Altitude (km)\n');
%             fprintf(fid, '# 2nd column:  Number density n (cm-3)\n');
%             fprintf(fid, '%.0f %.3g\n', [altgrid;densityout(:,i)']);
%             fclose(fid);
% 
%             % temperature
%             fid = fopen(['/Volumes/ExternalOne/work/data/BushfireChemModel/TUVinput/','temp/',sprintf('%03d',i),'.',sprintf('%01d',j),'.temperature'], 'w');
%             fprintf(fid, '# vaules are from US Standard Atmosphere, 1976, for 45N, annual means\n');
%             fprintf(fid, '# 1st column:  Geometric Altitude (km)\n');
%             fprintf(fid, '# 2nd column:  Temperature (deg K)\n');
%             fprintf(fid, '%.0f %.3f\n', [altgrid;tempout(:,i)']);
%             fclose(fid);
%         end
% 
% 
%         if i == dayend(count)
%             count = count+1;
%             month = month+1;
%             day = 1;
%         else
%             day = day+1;
%         end
%     end
% end


% take zonal mean between 30 and 60S


%convert to altitude perhaps
% also need to create temperatre and density ancillary for TUV code