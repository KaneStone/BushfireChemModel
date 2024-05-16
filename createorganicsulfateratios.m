% create time series averaged over level and latitudes from model data
clear variables

runcase = 'control';
%vars = {'O3','HCL','CLONO2','CLO','CL2O2','HOCL','HNO3','O'};
%vars = {'H2', 'H2O2', 'HO2','CHO2','CL','OH','CH4','CLO','HOCL','CH3CL','CH3BR','CH2BR2','CHBR3'};
vars = {'T','SOAB','SOAI','SOAM','SOAT','SOAX','CRMIX01','CRMIX02','CRMIX03','CRMIX04','CRMIX05',...
    'CRMIX06','CRMIX07','CRMIX08','CRMIX09','CRMIX10','CRMIX11','CRMIX12','CRMIX13','CRMIX14','CRMIX15',...
    'CRMIX16','CRMIX17','CRMIX18','CRMIX19','CRMIX20','CROC01','CROC02','CROC03','CROC04','CROC05',...
    'CROC06','CROC07','CROC08','CROC09','CROC10','CROC11','CROC12','CROC13','CROC14','CROC15',...
    'CROC16','CROC17','CROC18','CROC19','CROC20','PPOA01','PPOA02','PPOA03','PPOA04','PPOA05',...
    'PPOA06','PPOA07','PPOA08','PPOA09','PPOA10','PPOA11','PPOA12','PPOA13','PPOA14','PPOA15',...
    'PPOA16','PPOA17','PPOA18','PPOA19','PPOA20','SULF01','SULF02','SULF03','SULF04','SULF05',...
    'SULF06','SULF07','SULF08','SULF09','SULF10','SULF11','SULF12','SULF13','SULF14','SULF15',...
    'SULF16','SULF17','SULF18','SULF19','SULF20','CRBC01','CRBC02','CRBC03','CRBC04','CRBC05',...
    'CRBC06','CRBC07','CRBC08','CRBC09','CRBC10','CRBC11','CRBC12','CRBC13','CRBC14','CRBC15',...
    'CRBC16','CRBC17','CRBC18','CRBC19','CRBC20','SAD_SULFC','SULFRE','aoc','aso4'};
tic;
switch runcase
    case 'Solubility'
        data = readinBfolder(['/Users/kanestone/work/data/Bushfire/'],'*out_SD_solubility.nc',1); 
    otherwise
        data = readinBfolder(['/Users/kanestone/work/data/Bushfire/control/'],'*control.nc',1); 
end
%data.data.T2 = data.data.T;
toc;

TUV = 0;

%% fix bad data points
temp = squeeze(data.data.T(9,20,:));
diff1 = diff(temp);
badind = find(diff1 < -15)+1;

lats = [-50 -45];
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
%SOAI*136./29+SOAM*200./29+SOAX*155./29+SOAT*141./29+SOAB*127./29
SOA = zonalmean.SOAI.vmrregrid.*136./29 + zonalmean.SOAM.vmrregrid.*200./29 + zonalmean.SOAB.vmrregrid.*127./29 + ...
    zonalmean.SOAX.vmrregrid.*155/29 + zonalmean.SOAT.vmrregrid.*141./29;

OCMIX = zonalmean.CROC01.vmrregrid + zonalmean.CROC02.vmrregrid + zonalmean.CROC03.vmrregrid + zonalmean.CROC04.vmrregrid +...
    zonalmean.CROC05.vmrregrid + zonalmean.CROC06.vmrregrid + zonalmean.CROC07.vmrregrid + zonalmean.CROC08.vmrregrid +...
    zonalmean.CROC09.vmrregrid + zonalmean.CROC10.vmrregrid + zonalmean.CROC11.vmrregrid + zonalmean.CROC12.vmrregrid +...
    zonalmean.CROC13.vmrregrid + zonalmean.CROC14.vmrregrid + zonalmean.CROC15.vmrregrid + zonalmean.CROC16.vmrregrid +...
    zonalmean.CROC17.vmrregrid + zonalmean.CROC18.vmrregrid + zonalmean.CROC19.vmrregrid + zonalmean.CROC20.vmrregrid;

MIX = zonalmean.CRMIX01.vmrregrid + zonalmean.CRMIX02.vmrregrid + zonalmean.CRMIX03.vmrregrid + zonalmean.CRMIX04.vmrregrid +...
    zonalmean.CRMIX05.vmrregrid + zonalmean.CRMIX06.vmrregrid + zonalmean.CRMIX07.vmrregrid + zonalmean.CRMIX08.vmrregrid +...
    zonalmean.CRMIX09.vmrregrid + zonalmean.CRMIX10.vmrregrid + zonalmean.CRMIX11.vmrregrid + zonalmean.CRMIX12.vmrregrid +...
    zonalmean.CRMIX13.vmrregrid + zonalmean.CRMIX14.vmrregrid + zonalmean.CRMIX15.vmrregrid + zonalmean.CRMIX16.vmrregrid +...
    zonalmean.CRMIX17.vmrregrid + zonalmean.CRMIX18.vmrregrid + zonalmean.CRMIX19.vmrregrid + zonalmean.CRMIX20.vmrregrid;

PURESULF = zonalmean.SULF01.vmrregrid + zonalmean.SULF02.vmrregrid + zonalmean.SULF03.vmrregrid + zonalmean.SULF04.vmrregrid +...
    zonalmean.SULF05.vmrregrid + zonalmean.SULF06.vmrregrid + zonalmean.SULF07.vmrregrid + zonalmean.SULF08.vmrregrid +...
    zonalmean.SULF09.vmrregrid + zonalmean.SULF10.vmrregrid + zonalmean.SULF11.vmrregrid + zonalmean.SULF12.vmrregrid +...
    zonalmean.SULF13.vmrregrid + zonalmean.SULF14.vmrregrid + zonalmean.SULF15.vmrregrid + zonalmean.SULF16.vmrregrid +...
    zonalmean.SULF17.vmrregrid + zonalmean.SULF18.vmrregrid + zonalmean.SULF19.vmrregrid + zonalmean.SULF20.vmrregrid;

PUREORGANICS = zonalmean.PPOA01.vmrregrid + zonalmean.PPOA02.vmrregrid + zonalmean.PPOA03.vmrregrid + zonalmean.PPOA04.vmrregrid +...
    zonalmean.PPOA05.vmrregrid + zonalmean.PPOA06.vmrregrid + zonalmean.PPOA07.vmrregrid + zonalmean.PPOA08.vmrregrid +...
    zonalmean.PPOA09.vmrregrid + zonalmean.PPOA10.vmrregrid + zonalmean.PPOA11.vmrregrid + zonalmean.PPOA12.vmrregrid +...
    zonalmean.PPOA13.vmrregrid + zonalmean.PPOA14.vmrregrid + zonalmean.PPOA15.vmrregrid + zonalmean.PPOA16.vmrregrid +...
    zonalmean.PPOA17.vmrregrid + zonalmean.PPOA18.vmrregrid + zonalmean.PPOA19.vmrregrid + zonalmean.PPOA20.vmrregrid;

MIXBC = zonalmean.CRBC01.vmrregrid + zonalmean.CRBC02.vmrregrid + zonalmean.CRBC03.vmrregrid + zonalmean.CRBC04.vmrregrid +...
    zonalmean.CRBC05.vmrregrid + zonalmean.CRBC06.vmrregrid + zonalmean.CRBC07.vmrregrid + zonalmean.CRBC08.vmrregrid +...
    zonalmean.CRBC09.vmrregrid + zonalmean.CRBC10.vmrregrid + zonalmean.CRBC11.vmrregrid + zonalmean.CRBC12.vmrregrid +...
    zonalmean.CRBC13.vmrregrid + zonalmean.CRBC14.vmrregrid + zonalmean.CRBC15.vmrregrid + zonalmean.CRBC16.vmrregrid +...
    zonalmean.CRBC17.vmrregrid + zonalmean.CRBC18.vmrregrid + zonalmean.CRBC19.vmrregrid + zonalmean.CRBC20.vmrregrid;
%%
% zm.so4pure = PURESULF./(MIX + SOA + PURESULF + PUREORGANICS);
% so4mix = MIX - OCMIX - MIXBC; % - black carbon
% zm.mixsulffrac = so4mix./(MIX + SOA + PUREORGANICS); % because assuming pure organics are in mixed particles


zm.so4pure = PURESULF./(MIX + PURESULF + PUREORGANICS);
so4mix = MIX - OCMIX - MIXBC; % - black carbon
zm.mixsulffrac = so4mix./(MIX + PUREORGANICS); % because assuming pure organics are in mixed particles

% interpolate so4pure, mixsulffrac, SAD_SULFC, SULFRE

zm.SAD_SULFC = zonalmean.SAD_SULFC.vmrregrid;
xt = [5,10,36];
for i = 1:length(xt)
    zm.SAD_SULFC(:,xt) = (zm.SAD_SULFC(:,xt-1) + zm.SAD_SULFC(:,xt+1))./2;
end
zm.SULFRE = zonalmean.SULFRE.vmrregrid;
zm.aso4 = zonalmean.aso4.vmrregrid;
zm.aoc = zonalmean.aoc.vmrregrid;
vars2 = {'so4pure','mixsulffrac','SAD_SULFC','SULFRE','aso4','aoc'};


vars = fields(zonalmean);
%interpolate onto daily
timeout = 1:366*2;
timein = -3:7:363*2;
for j = 1:length(vars2)    
    dtemp = zm.(vars2{j});    
    
%     % removing 0s in SAD_SULFC.
%     if strcmp(vars{j},'SAD_SULFC')
%         for i = 1:size(dtemp,1)        
%             for k = 1:size(dtemp,2)
%                 if dtemp(i,k) == 0 && k == 1
%                     dtemp(i,k) = dtemp(i,k+1);
%                 elseif dtemp(i,k) == 0 && k == size(dtemp,2)
%                     dtemp(i,k) = dtemp(i,k-1);
%                 elseif dtemp(i,k) == 0
%                     dtemp(i,k) = (dtemp(i,k+1) + dtemp(i,k-1))./2;
%                 end
%             end
%         end
%     end

    %
    dtemp (dtemp == 0) = NaN;
    dtempout = dtemp;
    dtempout = fillmissing(dtempout','previous')';
    dtempout2 = NaN(81,366*2);
    for i = 1:42
        dtempout2(i,:) = interp1(timein,dtemp(i,1:105),timeout,'linear','extrap');
    end
    
    
    ancil.(vars2{j}).vmr = dtempout2;    
    
   
    ancil.(vars2{j}).vmr = double(fillmissing(ancil.(vars2{j}).vmr','previous')');
       
end

ancil.SAD_SULFC.vmr(:,1) = ancil.SAD_SULFC.vmr(:,4);
ancil.SAD_SULFC.vmr(:,2) = ancil.SAD_SULFC.vmr(:,4);
ancil.SAD_SULFC.vmr(:,3) = ancil.SAD_SULFC.vmr(:,4);

test = movmean(ancil.SAD_SULFC.vmr,30,2,'omitnan');
for i = 1:11
    test(:,i) = ancil.SAD_SULFC.vmr(:,1);
end
% test(:,2) = ancil.SAD_SULFC.vmr(:,1);
% test(:,3) = ancil.SAD_SULFC.vmr(:,1);
% test(:,4) = ancil.SAD_SULFC.vmr(:,1);
for i = 1:size(test,1)   
    test(i,12:34) = interp1(1:2,test(i,[11 34]),1:1/22:2);
end

ancil.SAD_SULFC.vmr = test;
    %% output temperature and density data for TUV code

save(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushChemModel/Ancil/variables/','climIn',runcase,'nosoa.mat'],'ancil');
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