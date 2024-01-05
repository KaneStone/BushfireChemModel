function [atmosphere,variables] = Initializevars(inputs,vars)


%% read in ancil files

controlancil = load([inputs.ancildir,'variables/','climInControl.mat']);

switch inputs.runtype
    case {'solubility','doublelinear'}
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
variables.BRO = 1;
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
variables.NO3 = 1e6;
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
O3ini = atmosphere.atLevel.O3.nd(1);
%atmosphere.dummyozone = O3ini+.45e12 + O3ini./5.*sin(2*pi./inputs.timesteps.*(1:inputs.timesteps) + 3.6*pi/3);
atmosphere.dummyO3 = O3ini+.45e12 + O3ini./5.*sin(2*pi./365.*(1:365) + 3.6*pi/3);

% CH2O
CH2Oini = atmosphere.atLevel.CH2O.nd(1);
CH2Omin = min(atmosphere.atLevel.CH2O.nd);
atmosphere.dummyCH2O = CH2Oini + (CH2Oini-CH2Omin)./2.*sin(2*pi./365.*(1:365) + pi/2);
CH2Ostartdiff = (atmosphere.dummyCH2O(1) - CH2Oini);
atmosphere.dummyCH2O = atmosphere.dummyCH2O - CH2Ostartdiff;

% CH3O2

wts = ones(1,366); wts(2:end-1) = .001;
f=fit([1:366]',[atmosphere.atLevel.CH3O2.nd(1:end-1),atmosphere.atLevel.CH3O2.nd(1)]','poly3','Weights',wts);
atmosphere.dummyCH3O2 = f(1:366);

%M

wts = ones(1,366); wts(2:end-1) = .1;
f=fit([1:366]',[atmosphere.atLevel.M(1:end-1),atmosphere.atLevel.M(1)]','poly3','Weights',wts);
atmosphere.dummyM = f(1:366);

atmosphere.dummyO2 = atmosphere.dummyM.*21;
atmosphere.dummyN2 = atmosphere.dummyM.*78;

% H
Hini = atmosphere.atLevel.H.nd(1);
Hmin = min(atmosphere.atLevel.H.nd);
atmosphere.dummyH = Hini + (Hini-Hmin)./2.*sin(2*pi./365.*(1:365) + pi/2);
Hstartdiff = (atmosphere.dummyH(1) - Hini);
atmosphere.dummyH = atmosphere.dummyH - Hstartdiff;

% H2
wts = ones(1,366); wts(2:end-1) = .001;
f=fit([1:366]',[atmosphere.atLevel.H2.nd(1:end-1),atmosphere.atLevel.H2.nd(1)]','poly3','Weights',wts);
atmosphere.dummyH2 = f(1:366);

% These two won't work for other levels or locations.
% N2O
N2Omin = min(atmosphere.atLevel.N2O.nd);
N2Omax = max(atmosphere.atLevel.N2O.nd);

atmosphere.dummyN2O = atmosphere.dummyM./(max(atmosphere.dummyM)./((N2Omin+N2Omax)./2));

% CH4
CH4min = min(atmosphere.atLevel.CH4.nd);
CH4max = max(atmosphere.atLevel.CH4.nd);

atmosphere.dummyCH4 = atmosphere.dummyM./(max(atmosphere.dummyM)./((CH4min+CH4max)./2));

% CO
wts = ones(1,366); wts(2:end-1) = .001;
f=fit([1:366]',[atmosphere.atLevel.CO.nd(1:end-1),atmosphere.atLevel.CO.nd(1)]','poly3','Weights',wts);
atmosphere.dummyCO = f(1:366);

%% NO2
NO2ini = 2.5e9;
%atmosphere.dummyNO2 = NO2ini-.5e9 + NO2ini./2.8.*sin(2*pi./inputs.timesteps.*(1:inputs.timesteps) + pi/2);
atmosphere.dummyNO2 = NO2ini-.5e9 + NO2ini./2.8.*sin(2*pi./365.*(1:365) + pi/2);

HNO3ini = atmosphere.atLevel.HNO3.nd(1);
%atmosphere.dummyHNO3 = HNO3ini-.5e9 + HNO3ini./2.8.*sin(2*pi./inputs.timesteps.*(1:inputs.timesteps) + pi/2);
atmosphere.dummyHNO3 = HNO3ini+.8e9 + HNO3ini./5.8.*sin(2*pi./365.*(1:365) + 3*pi/2);

N2O5ini = atmosphere.atLevel.N2O5.nd(1);
%atmosphere.dummyHNO3 = HNO3ini-.5e9 + HNO3ini./2.8.*sin(2*pi./inputs.timesteps.*(1:inputs.timesteps) + pi/2);
atmosphere.dummyN2O5 = N2O5ini + N2O5ini./5.8.*sin(4*pi./365.*(1:365) + 3*pi/2);

CLONO2ini = atmosphere.atLevel.CLONO2.nd(1);
%atmosphere.dummyNO2 = NO2ini-.5e9 + NO2ini./2.8.*sin(2*pi./inputs.timesteps.*(1:inputs.timesteps) + pi/2);
atmosphere.dummyCLONO2 = CLONO2ini+.8e8 + CLONO2ini./3.*sin(2*pi./365.*(1:365) + 3.6.*pi/3);

HCLini = atmosphere.atLevel.HCL.nd(1);
%atmosphere.dummyNO2 = NO2ini-.5e9 + NO2ini./2.8.*sin(2*pi./inputs.timesteps.*(1:inputs.timesteps) + pi/2);
atmosphere.dummyHCL = HCLini-.025e9 + HCLini./40.*sin(2*pi./365.*(1:365) + 3.6.*pi/3);

% Surface area density
SADini = .7e-8;
atmosphere.dummySAD = SADini+1e-9 + SADini./40.*sin(2*pi./365.*(1:365)+pi.*1.1);
%atmosphere.dummySAD(1:150) = atmosphere.dummySAD(1:150) + abs((atmosphere.dummySAD(1:150)-atmosphere.dummySAD(150)))./1.7;

% Surface area density
atmosphere.dummyV = -.05 + .03.*sin(2*pi./365.*(1:365)+pi./2);
%atmosphere.dummySAD(1:150) = atmosphere.dummySAD(1:150) + abs((atmosphere.dummySAD(1:150)-atmosphere.dummySAD(150)))./1.7;

switch inputs.runtype        
    case 'solubility'
        
        atmosphere.dummySAD = solancil.ancil.SAD_SULFC.vmr(inputs.altitude+1,1:inputs.days);   % 1.5 is arbitrary 
%         atmosphere.dummySAD(11:end) = solancil.ancil.SAD_SULFC.vmr(inputs.altitude+1,11:inputs.days)./1.5;   % 1.5 is arbitrary 
%         atmosphere.dummySAD(10:18) = interp1([10,18],atmosphere.dummySAD([10,18]),10:18);
%         atmosphere.dummySAD(235:250) = interp1([235,250],atmosphere.dummySAD([235,250]),235:250);

        atmosphere.aoc_aso4_ratio = solancil.ancil.aoc.vmr(inputs.altitude+1,1:inputs.days)./solancil.ancil.aso4.vmr(inputs.altitude+1,1:inputs.days);
        
        atmosphere.radius = solancil.ancil.SULFRE.vmr(inputs.altitude+1,1:inputs.days).*1e-4;
        
    %atmosphere.aoc_aso4_ratio(:) = .1;
    case 'doublelinear'
        atmosphere.dummySAD = solancil.ancil.SAD_SULFC.vmr(inputs.altitude+1,1:inputs.days).*5;   % 1.5 is arbitrary 
                
        atmosphere.mixsulffrac = solancil.ancil.mixsulffrac.vmr(inputs.altitude+1,1:inputs.days);
        atmosphere.so4pure = solancil.ancil.so4pure.vmr(inputs.altitude+1,1:inputs.days);
        
        atmosphere.radius = solancil.ancil.SULFRE.vmr(inputs.altitude+1,1:inputs.days).*1e-4;
        
    case 'control'
        if strcmp(inputs.radius,'ancil')
            atmosphere.radius = controlancil.SULFRE.vmr(inputs.altitude+1,:).*1e-4; % cm; 
        else
            atmosphere.radius = inputs.radius;
        end
    
end
% smooth temperature
tempsmooth = movmean([atmosphere.atLevel.T(end-19:end),atmosphere.atLevel.T,atmosphere.atLevel.T(1:20)],20);
atmosphere.atLevel.T = tempsmooth(21:end-20);

% smooth pressure
psmooth = movmean([atmosphere.atLevel.P(end-19:end),atmosphere.atLevel.P,atmosphere.atLevel.P(1:20)],20);
atmosphere.atLevel.P = psmooth(21:end-20);

% H2O
H2Oini = atmosphere.atLevel.H2O.nd(1);
H2Omax = max(atmosphere.atLevel.H2O.nd);
atmosphere.dummyH2O = H2Oini + (H2Omax - H2Oini)./2.*sin(2*pi./365.*(1:365) + 3.*pi/2);
H2Ostartdiff = (atmosphere.dummyH2O(1) - H2Oini);
atmosphere.dummyH2O = atmosphere.dummyH2O - H2Ostartdiff;

atmosphere.dummyH2Ovmr = atmosphere.dummyH2O.*inputs.k.*1e6./(atmosphere.atLevel.P(1:365).*100).*atmosphere.atLevel.T(1:365);
% initialize to fluxvars
variables.O3 = atmosphere.dummyO3(1);
variables.CLONO2 = atmosphere.dummyCLONO2(1);
variables.HCL = atmosphere.dummyHCL(1);
variables.HNO3 = atmosphere.dummyHNO3(1);


%% initialize to end of control run
% variables.O3 = atmosphere.dummyO3(1);
% variables.CLONO2 = atmosphere.dummyCLONO2(1);
% variables.HCL = 2.02e9;
% variables.O1D = 1e-10;
% variables.CLO = 6.5e4;
% variables.BRO = 212;
% variables.HOCL = 3.06e6;
% variables.OCLO = 5.65e3;
% variables.BRCL = 7.4e3;
% variables.O = 1e-5;
% variables.CL = 4;
% variables.CL2 = 4e2;
% variables.CL2O2 = .1;
% variables.NO = .005;
% variables.NO2 = 2.5e9;
% variables.NO3 = 6.47e6;
% variables.N2O5 = 2.74e8;
% variables.HNO3 = 1e10;
% variables.OH = 1.2e5;
% variables.HO2 = 3.38e6;
% variables.H2O2 = 1.2e7;
% variables.HO2NO2 = 3.17e8;
% variables.HBR = 5.5e5;
% variables.HOBR = 5.34e6;
% variables.BRONO2 = 1.62e6;
% variables.BR = .5;



end
