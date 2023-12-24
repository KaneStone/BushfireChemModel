function [atmosphere,variables] = Initializevars(inputs,vars)


%% read in ancil files

load([inputs.ancildir,'variables/','climIn.mat']);

% extract temperature, pressure, and density
atmosphere.T = ancil.T;
atmosphere.P = ancil.P;
atmosphere.M = ancil.M;
atmosphere.O3 = ancil.O3.nd;
atmosphere.altitude = 0:90;

% remove temperature, pressure , and density from ancil fieldnames
ancil = rmfield(ancil,{'T','P','M','altitude'});

%% extract variables
fieldnames = fields(ancil);

for i = 1:length(fieldnames)
    atmosphere.atLevel.(fieldnames{i}).nd = ancil.(fieldnames{i}).nd(inputs.altitude+1,:);
    atmosphere.atLevel.(fieldnames{i}).vmr = ancil.(fieldnames{i}).vmr(inputs.altitude+1,:);    
end

atmosphere.atLevel.T = atmosphere.T(inputs.altitude+1,:);
atmosphere.atLevel.P = atmosphere.P(inputs.altitude+1,:);
atmosphere.atLevel.M = atmosphere.M(inputs.altitude+1,:);

atmosphere.atLevel.O2.nd = atmosphere.atLevel.M.*.21;
atmosphere.atLevel.N2.nd = atmosphere.atLevel.M.*.78;

variables.O3 = atmosphere.atLevel.O3.nd(1);
variables.CLO = atmosphere.atLevel.CLO.nd(1);
variables.CLONO2 = atmosphere.atLevel.CLONO2.nd(1);
variables.HCL = atmosphere.atLevel.HCL.nd(1);
variables.HOCL = atmosphere.atLevel.HOCL.nd(1);
variables.O3 = atmosphere.atLevel.O3.nd(1);
variables.OCLO = atmosphere.atLevel.OCLO.nd(1);
variables.BRCL = atmosphere.atLevel.BRCL.nd(1);
variables.O = 1e1;
variables.CL = atmosphere.atLevel.CL.nd(1);
variables.CL2 = atmosphere.atLevel.CL2.nd(1);
variables.CL2O2 = atmosphere.atLevel.CL2O2.nd(1);
variables.NO = 1e1;
variables.NO2 = atmosphere.atLevel.NO2.nd(1);
variables.NO3 = atmosphere.atLevel.NO3.nd(1);
variables.N2O5 = atmosphere.atLevel.N2O5.nd(1);
variables.HNO3 = atmosphere.atLevel.HNO3.nd(1);
variables.OH = atmosphere.atLevel.OH.nd(1);
variables.HO2 = atmosphere.atLevel.HO2.nd(1);
variables.HO2NO2 = atmosphere.atLevel.HO2NO2.nd(1);
variables.BRO = atmosphere.atLevel.BRO.nd(1);
variables.HBR = atmosphere.atLevel.HBR.nd(1);
variables.HOBR = atmosphere.atLevel.HOBR.nd(1);
variables.BRONO2 = atmosphere.atLevel.BRONO2.nd(1);
variables.BR = atmosphere.atLevel.BR.nd(1);

%% for O3 and NO2, I need to account for transport. Create a dummy variable!
O3ini = variables.O3;
%atmosphere.dummyozone = O3ini+.45e12 + O3ini./5.*sin(2*pi./inputs.timesteps.*(1:inputs.timesteps) + 3.6*pi/3);
atmosphere.dummyozone = O3ini+.45e12 + O3ini./5.*sin(2*pi./365.*(1:365) + 3.6*pi/3);

NO2ini = variables.NO2;
%atmosphere.dummyNO2 = NO2ini-.5e9 + NO2ini./2.8.*sin(2*pi./inputs.timesteps.*(1:inputs.timesteps) + pi/2);
atmosphere.dummyNO2 = NO2ini-.5e9 + NO2ini./2.8.*sin(2*pi./365.*(1:365) + pi/2);

CLONO2ini = variables.CLONO2;
%atmosphere.dummyNO2 = NO2ini-.5e9 + NO2ini./2.8.*sin(2*pi./inputs.timesteps.*(1:inputs.timesteps) + pi/2);
atmosphere.dummyCLONO2 = CLONO2ini+.15e9 + CLONO2ini./2.5.*sin(2*pi./365.*(1:365) + 3.6.*pi/3);

HCLini = variables.HCL;
%atmosphere.dummyNO2 = NO2ini-.5e9 + NO2ini./2.8.*sin(2*pi./inputs.timesteps.*(1:inputs.timesteps) + pi/2);
atmosphere.dummyHCL = HCLini+.05e9 + HCLini./15.*sin(2*pi./365.*(1:365) + 3.6.*pi/3);

%atmosphere.dummySAD = 
SADini = 1e-8;
atmosphere.dummySAD = SADini+1e-9 + SADini./10.*sin(2*pi./365.*(1:365) + 3.0*pi/3);
% smooth temperature
tempsmooth = movmean([atmosphere.atLevel.T(end-19:end),atmosphere.atLevel.T,atmosphere.atLevel.T(1:20)],20);
atmosphere.atLevel.T = tempsmooth(21:end-20);

% createdummy SAD_SSULFC
if strcmp(inputs.radius,'ancil')
    atmosphere.radius = mean(ancil.SULFRE.vmr(inputs.altitude+1,:),2).*1e-4; % cm; 
else
    atmosphere.radius = inputs.radius;
end
%atmosphere.atLevel.SAD_SULFC

% figure; plot(atmosphere.dummyNO2')
% xlim([0 26280])
% ylim([.3e9 1.6e9]);
% hold on
% ax2 = axes;
% plot(atmosphere.atLevel.NO2.nd)
% ax2.XAxisLocation = 'top';
% ax2.Color = 'none';
% xlim([0 366])
% ylim([.3e9 1.6e9]);
% 
% %% fft test
% %fft(atmosphere.atLevel.O3.nd)
% 
% Fs = 1000;                    % Sampling frequency
% T = 1/Fs;                     % Sampling period
% L = 1000;                     % Length of signal
% t = (0:L-1)*T;

end
