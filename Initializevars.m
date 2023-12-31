function [atmosphere,variables] = Initializevars(inputs,vars)


%% read in ancil files

controlancil = load([inputs.ancildir,'variables/','climInControl.mat']);

switch inputs.runtype
    case 'solubility'
        solancil = load([inputs.ancildir,'variables/','climInSolubility.mat']);        
    otherwise
end

% extract temperature, pressure, and density
atmosphere.T = controlancil.ancil.T;
atmosphere.P = controlancil.ancil.P;
atmosphere.M = controlancil.ancil.M;
atmosphere.V = controlancil.ancil.V.vmr;
atmosphere.O3 = controlancil.ancil.O3.nd;
atmosphere.altitude = 0:90;

% remove temperature, pressure , and density from ancil fieldnames
controlancil = rmfield(controlancil.ancil,{'T','P','M','altitude'});

%% extract variables
fieldnames = fields(controlancil);

for i = 1:length(fieldnames)
    atmosphere.atLevel.(fieldnames{i}).nd = controlancil.(fieldnames{i}).nd(inputs.altitude+1,:);
    atmosphere.atLevel.(fieldnames{i}).vmr = controlancil.(fieldnames{i}).vmr(inputs.altitude+1,:);    
end

atmosphere.atLevel.T = atmosphere.T(inputs.altitude+1,:);
atmosphere.atLevel.P = atmosphere.P(inputs.altitude+1,:);
atmosphere.atLevel.M = atmosphere.M(inputs.altitude+1,:);
atmosphere.atLevel.V = atmosphere.V(inputs.altitude+1,:);

atmosphere.atLevel.O2.nd = atmosphere.atLevel.M.*.21;
atmosphere.atLevel.N2.nd = atmosphere.atLevel.M.*.78;

variables.O3 = atmosphere.atLevel.O3.nd(1);
variables.O1D = atmosphere.atLevel.O1D.nd(1);
variables.CLO = 1;
variables.CLONO2 = atmosphere.atLevel.CLONO2.nd(1).*2;
variables.HCL = atmosphere.atLevel.HCL.nd(1);
variables.HOCL = atmosphere.atLevel.HOCL.nd(1);
variables.OCLO = 1e4;
variables.BRCL = 1e1;
variables.O = 1e1;
variables.CL = atmosphere.atLevel.CL.nd(1);
variables.CL2 = atmosphere.atLevel.CL2.nd(1);
variables.CL2O2 = atmosphere.atLevel.CL2O2.nd(1);
variables.NO = 1e1;
variables.NO2 = 1.4e9;
variables.NO3 = atmosphere.atLevel.NO3.nd(1);
variables.N2O5 = atmosphere.atLevel.N2O5.nd(1);
variables.HNO3 = atmosphere.atLevel.HNO3.nd(1);
variables.OH = atmosphere.atLevel.OH.nd(1);
variables.HO2 = atmosphere.atLevel.HO2.nd(1);
variables.H2O2 = atmosphere.atLevel.H2O2.nd(1);
variables.HO2NO2 = atmosphere.atLevel.HO2NO2.nd(1);
variables.BRO = 1e1;%atmosphere.atLevel.BRO.nd(1);
variables.HBR = atmosphere.atLevel.HBR.nd(1);
variables.HOBR = atmosphere.atLevel.HOBR.nd(1);
variables.BRONO2 = atmosphere.atLevel.BRONO2.nd(1);
variables.BR = atmosphere.atLevel.BR.nd(1);

%% creating dummy variables for flux correction
O3ini = variables.O3;
%atmosphere.dummyozone = O3ini+.45e12 + O3ini./5.*sin(2*pi./inputs.timesteps.*(1:inputs.timesteps) + 3.6*pi/3);
atmosphere.dummyO3 = O3ini+.45e12 + O3ini./5.*sin(2*pi./365.*(1:365) + 3.6*pi/3);

NO2ini = variables.NO2;
%atmosphere.dummyNO2 = NO2ini-.5e9 + NO2ini./2.8.*sin(2*pi./inputs.timesteps.*(1:inputs.timesteps) + pi/2);
atmosphere.dummyNO2 = NO2ini-.5e9 + NO2ini./2.8.*sin(2*pi./365.*(1:365) + pi/2);

HNO3ini = variables.HNO3;
%atmosphere.dummyHNO3 = HNO3ini-.5e9 + HNO3ini./2.8.*sin(2*pi./inputs.timesteps.*(1:inputs.timesteps) + pi/2);
atmosphere.dummyHNO3 = HNO3ini+.8e9 + HNO3ini./5.8.*sin(2*pi./365.*(1:365) + 3*pi/2);

N2O5ini = variables.N2O5;
%atmosphere.dummyHNO3 = HNO3ini-.5e9 + HNO3ini./2.8.*sin(2*pi./inputs.timesteps.*(1:inputs.timesteps) + pi/2);
atmosphere.dummyN2O5 = N2O5ini + N2O5ini./5.8.*sin(4*pi./365.*(1:365) + 3*pi/2);

CLONO2ini = variables.CLONO2;
%atmosphere.dummyNO2 = NO2ini-.5e9 + NO2ini./2.8.*sin(2*pi./inputs.timesteps.*(1:inputs.timesteps) + pi/2);
atmosphere.dummyCLONO2 = CLONO2ini+.15e9 + CLONO2ini./2.5.*sin(2*pi./365.*(1:365) + 3.6.*pi/3);

HCLini = variables.HCL;
%atmosphere.dummyNO2 = NO2ini-.5e9 + NO2ini./2.8.*sin(2*pi./inputs.timesteps.*(1:inputs.timesteps) + pi/2);
atmosphere.dummyHCL = HCLini+.05e9 + HCLini./15.*sin(2*pi./365.*(1:365) + 3.6.*pi/3);

% Surface area density
SADini = 1e-8;
atmosphere.dummySAD = SADini+1e-9 + SADini./40.*sin(2*pi./365.*(1:365)+pi.*1.1);
%atmosphere.dummySAD(1:150) = atmosphere.dummySAD(1:150) + abs((atmosphere.dummySAD(1:150)-atmosphere.dummySAD(150)))./1.7;

% Surface area density
atmosphere.dummyV = -.05 + .03.*sin(2*pi./365.*(1:365)+pi./2);
%atmosphere.dummySAD(1:150) = atmosphere.dummySAD(1:150) + abs((atmosphere.dummySAD(1:150)-atmosphere.dummySAD(150)))./1.7;

switch inputs.runtype        
    case 'solubility'
        
    atmosphere.dummySAD(11:end) = atmosphere.dummySAD(11:end) + solancil.ancil.SAD_SULFC.vmr(inputs.altitude+1,11:365)+.5e-8;    
    atmosphere.dummySAD(10:18) = interp1([10,18],atmosphere.dummySAD([10,18]),10:18);
    atmosphere.dummySAD(235:250) = interp1([235,250],atmosphere.dummySAD([235,250]),235:250);
    
    atmosphere.aoc_aso4_ratio = solancil.ancil.aoc.vmr(inputs.altitude+1,:)./solancil.ancil.aso4.vmr(inputs.altitude+1,:);
    %atmosphere.aoc_aso4_ratio(:) = .1;
    
end
% smooth temperature
tempsmooth = movmean([atmosphere.atLevel.T(end-19:end),atmosphere.atLevel.T,atmosphere.atLevel.T(1:20)],20);
atmosphere.atLevel.T = tempsmooth(21:end-20);

if strcmp(inputs.radius,'ancil')
    atmosphere.radius = mean(controlancil.SULFRE.vmr(inputs.altitude+1,:),2).*1e-4; % cm; 
else
    atmosphere.radius = inputs.radius;
end

% initialize to fluxvars
variables.O3 = atmosphere.dummyO3(1);
variables.CLONO2 = atmosphere.dummyCLONO2(1);
variables.HCL = atmosphere.dummyHCL(1);
variables.HNO3 = atmosphere.dummyHNO3(1);

end
