% O3 only test

% Read in data
load('/Volumes/ExternalOne/work/data/BushfireChemModel/ancil/climIn.mat')

%%
alt = 20;
fieldnames = fields(ancil);
for i = 1:length(fieldnames)
    
    switch fieldnames{i}
        case {'T','P'}
            conc.(fieldnames{i}) = ancil.(fieldnames{i})(alt,:);
        otherwise
            conc.(fieldnames{i}) = ancil.(fieldnames{i}).nd(alt,:);
    end
end

T = conc.T;

%%

rates.O3.production(1,:)= 6e-34.*(T./300).^-2.4.*conc.O2.*conc.O.*(conc.O2+conc.N2); %O2_O_M 
% loss rates
rates.O3.destruction(1,:) = 8e-12.*exp(-2060./T).*conc.O3.*conc.O; %O_O3 
rates.O3.destruction(2,:) = 1e-10;%O1D_O3 
%rates.O3.destruction = 1.40e-10.*exp(-470./T).*conc.O3.*conc.H;  %dH_O3 
rates.O3.destruction(3,:) = 1.70e-12.*exp(-940./T).*conc.O3.*conc.OH; %OH_O3 
rates.O3.destruction(4,:) = 1.0e-14.*exp(-490./T).*conc.O3.*conc.HO2; %HO2_O3 
rates.O3.destruction(5,:) = 3e-12.*exp(-1500./T).*conc.O3.*conc.NO; %NO_O3 
rates.O3.destruction(6,:) = 1.2e-13.*exp(-2450./T).*conc.O3.*conc.NO2; %NO2_O3 
rates.O3.destruction(7,:) = 2.30e-11.*exp(-200./T).*conc.O3.*conc.CL; %CL_O3
rates.O3.destruction(8,:) = 1.6e-11.*exp(-780./T).*conc.O3.*conc.BR; %BR_O3

%% need to add photolysis here
O3test = conc.O3;
O3diff = sum(rates.O3.production) - sum(rates.O3.destruction);

for i = 2:367
    
    rates2.O3.production(1)= 6e-34.*(T(i-1)./300).^-2.4.*conc.O2(i-1).*conc.O(i-1).*(conc.O2(i-1)+conc.N2(i-1)); %O2_O_M 
% loss rates
    rates2.O3.destruction(1) = 8e-12.*exp(-2060./T(i-1)).*O3test(i-1).*conc.O(i-1); %O_O3 
    rates2.O3.destruction(2) = 1e-10;%O1D_O3 
    %rates2.O3.destruction = 1.40e-10.*exp(-470./T).*O3test(i-1).*conc.H;  %dH_O3 
    rates2.O3.destruction(3) = 1.70e-12.*exp(-940./T(i-1)).*O3test(i-1).*conc.OH(i-1); %OH_O3 
    rates2.O3.destruction(4) = 1.0e-14.*exp(-490./T(i-1)).*O3test(i-1).*conc.HO2(i-1); %HO2_O3 
    rates2.O3.destruction(5) = 3e-12.*exp(-1500./T(i-1)).*O3test(i-1).*conc.NO(i-1); %NO_O3 
    rates2.O3.destruction(6) = 1.2e-13.*exp(-2450./T(i-1)).*O3test(i-1).*conc.NO2(i-1); %NO2_O3 
    rates2.O3.destruction(7) = 2.30e-11.*exp(-200./T(i-1)).*O3test(i-1).*conc.CL(i-1); %CL_O3
    rates2.O3.destruction(8) = 1.6e-11.*exp(-780./T(i-1)).*O3test(i-1).*conc.BR(i-1); %BR_O3
    O3diff = sum(rates2.O3.production).*60*60*24 - sum(rates2.O3.destruction).*60*60*24;
    O3test(i) = O3test(i-1) + O3diff;
end
