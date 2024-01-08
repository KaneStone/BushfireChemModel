function [atmosphere,variables] = Initializevars(inputs)


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

%% creating dummy variables for flux correction and input climatology species
% WILL NOT WORK IF YOU GO ABOVE 25 KM or for NH, polar regions. Will need to
% estimate a phase variable from climatology to be more consistent.
% H2O

atmosphere.dummyO3 = createdummyvariables(atmosphere.atLevel.O3.nd,3.6.*pi/3);
atmosphere.dummyCLONO2 = createdummyvariables(atmosphere.atLevel.CLONO2.nd,3.6.*pi/3);
atmosphere.dummyHCL = createdummyvariables(atmosphere.atLevel.HCL.nd,3.6.*pi/3);
atmosphere.dummyHNO3 = createdummyvariables(atmosphere.atLevel.HNO3.nd,3.*pi/2);
atmosphere.dummyN2O5 = createdummyvariables(atmosphere.atLevel.N2O5.nd,3.*pi/2);
atmosphere.dummyCH2O = createdummyvariables(atmosphere.atLevel.CH2O.nd,pi/2);
atmosphere.dummyH = createdummyvariables(atmosphere.atLevel.H.nd,pi/2);
atmosphere.dummyH2O = createdummyvariables(atmosphere.atLevel.H2O.nd,3.*pi/2);
atmosphere.dummyH2Ovmr = atmosphere.dummyH2O.*inputs.k.*1e6./(atmosphere.atLevel.P(1:365).*100).*atmosphere.atLevel.T(1:365);
atmosphere.dummyH2Ovmr = atmosphere.dummyH2Ovmr - (atmosphere.dummyH2Ovmr(1) - atmosphere.atLevel.H2O.vmr(1));      

atmosphere.dummyCH3O2 = fitancil(atmosphere.atLevel.CH3O2.nd,.001);
atmosphere.dummyM = fitancil(atmosphere.atLevel.M,.1);
atmosphere.dummyH2 = fitancil(atmosphere.atLevel.H2.nd,.001);
atmosphere.dummyCO = fitancil(atmosphere.atLevel.CO.nd,.001);
atmosphere.dummyO2 = atmosphere.dummyM.*.21;
atmosphere.dummyN2 = atmosphere.dummyM.*.78;

% For N2O I am trying to maintain a seasonal cycle only (this shouldn't
% cause any problems as I am only using N2O to calculate O1D, but should be
% careful if trying to run at high altitude.
N2Omin = min(atmosphere.atLevel.N2O.nd);
N2Omax = max(atmosphere.atLevel.N2O.nd);
atmosphere.dummyN2O = atmosphere.dummyM./(max(atmosphere.dummyM)./((N2Omin+N2Omax)./2));

% CH4 may be better to use sine.
CH4min = min(atmosphere.atLevel.CH4.nd);
CH4max = max(atmosphere.atLevel.CH4.nd);
atmosphere.dummyCH4 = atmosphere.dummyM./(max(atmosphere.dummyM)./((CH4min+CH4max)./2));

% smooth temperature
tempsmooth = movmean([atmosphere.atLevel.T(end-19:end),atmosphere.atLevel.T,atmosphere.atLevel.T(1:20)],20);
atmosphere.atLevel.T = tempsmooth(21:end-20);

% smooth pressure
psmooth = movmean([atmosphere.atLevel.P(end-19:end),atmosphere.atLevel.P,atmosphere.atLevel.P(1:20)],20);
atmosphere.atLevel.P = psmooth(21:end-20);

% H2Oini = atmosphere.atLevel.H2O.nd(1);
% H2Omax = max(atmosphere.atLevel.H2O.nd);
% atmosphere.dummyH2O = H2Oini + (H2Omax - H2Oini)./2.*sin(2*pi./365.*(1:365) + 3.*pi/2);
% H2Ostartdiff = (atmosphere.dummyH2O(1) - H2Oini);
% atmosphere.dummyH2O = atmosphere.dummyH2O - H2Ostartdiff;

% There is a difference here becuase when I created the ancillary files I
% did it for each latitude separately. Now doing it for the latitude
% average causes problems as temperature and pressure dont scale linearly.
% (I think)

% O3ini = atmosphere.atLevel.O3.nd(1);
% atmosphere.dummyO3 = O3ini+.45e12 + O3ini./5.*sin(2*pi./365.*(1:365) + 3.6*pi/3);
% O3ini = atmosphere.atLevel.O3.nd(1);
% O3amp = max(atmosphere.atLevel.O3.nd) - min(atmosphere.atLevel.O3.nd);
% atmosphere.dummyO3 = O3ini + O3amp./2.*sin(2*pi./365.*(1:365) + 3.6.*pi/3);
% O3startdiff = (atmosphere.dummyO3(1) - O3ini);
% atmosphere.dummyO3 = atmosphere.dummyO3 - O3startdiff;

% % H
% Hini = atmosphere.atLevel.H.nd(1);
% Hmin = min(atmosphere.atLevel.H.nd);
% atmosphere.dummyH = Hini + (Hini-Hmin)./2.*sin(2*pi./365.*(1:365) + pi/2);
% Hstartdiff = (atmosphere.dummyH(1) - Hini);
% atmosphere.dummyH = atmosphere.dummyH - Hstartdiff;

% % CLONO2
% %atmosphere.dummyCLONO2 = CLONO2ini+2e8 + CLONO2ini./3.*sin(2*pi./365.*(1:365) + 3.6.*pi/3);
% CLONO2ini = atmosphere.atLevel.CLONO2.nd(1);
% CLONO2amp = max(atmosphere.atLevel.CLONO2.nd) - min(atmosphere.atLevel.CLONO2.nd);
% atmosphere.dummyCLONO2 = CLONO2ini + CLONO2amp./2.*sin(2*pi./365.*(1:365) + 3.6.*pi/3);
% CLONO2startdiff = (atmosphere.dummyCLONO2(1) - CLONO2ini);
% atmosphere.dummyCLONO2 = atmosphere.dummyCLONO2 - CLONO2startdiff;
% 
% % HNO3
% HNO3ini = atmosphere.atLevel.HNO3.nd(1);
% HNO3amp = max(atmosphere.atLevel.HNO3.nd) - min(atmosphere.atLevel.HNO3.nd);
% atmosphere.dummyHNO3 = HNO3ini + HNO3amp./2.*sin(2*pi./365.*(1:365) + 3*pi/2);
% HNO3startdiff = (atmosphere.dummyHNO3(1) - HNO3ini);
% atmosphere.dummyHNO3 = atmosphere.dummyHNO3 - HNO3startdiff;
% 
% % N2O5
% N2O5ini = atmosphere.atLevel.N2O5.nd(1);
% N2O5amp = max(atmosphere.atLevel.N2O5.nd) - min(atmosphere.atLevel.N2O5.nd);
% atmosphere.dummyN2O5 = N2O5ini + N2O5amp./2.*sin(2*pi./365.*(1:365) + 3*pi/2);
% N2O5startdiff = (atmosphere.dummyN2O5(1) - N2O5ini);
% atmosphere.dummyN2O5 = atmosphere.dummyN2O5 - N2O5startdiff;
% 
% % HCL
% HCLini = atmosphere.atLevel.HCL.nd(1);
% HCLamp = max(atmosphere.atLevel.HCL.nd) - min(atmosphere.atLevel.HCL.nd);
% atmosphere.dummyHCL = HCLini + HCLamp./2.*sin(2*pi./365.*(1:365) + 3.6.*pi/3);
% HCLstartdiff = (atmosphere.dummyHCL(1) - HCLini);
% atmosphere.dummyHCL = atmosphere.dummyHCL - HCLstartdiff;
% 
% % CH2O
% CH2Oini = atmosphere.atLevel.CH2O.nd(1);
% CH2Omin = min(atmosphere.atLevel.CH2O.nd);
% atmosphere.dummyCH2O = CH2Oini + (CH2Oini-CH2Omin)./2.*sin(2*pi./365.*(1:365) + pi/2);
% CH2Ostartdiff = (atmosphere.dummyCH2O(1) - CH2Oini);
% atmosphere.dummyCH2O = atmosphere.dummyCH2O - CH2Ostartdiff;

% CH3O2
% wts = ones(1,366); wts(2:end-1) = .001;
% f=fit([1:366]',[atmosphere.atLevel.CH3O2.nd(1:end-1),atmosphere.atLevel.CH3O2.nd(1)]','poly3','Weights',wts);
% atmosphere.dummyCH3O2 = f(1:366);


% %M
% wts = ones(1,366); wts(2:end-1) = .1;
% f=fit([1:366]',[atmosphere.atLevel.M(1:end-1),atmosphere.atLevel.M(1)]','poly3','Weights',wts);
% atmosphere.dummyM = f(1:366);
% 
% 
% 
% 
% 
% % H2
% wts = ones(1,366); wts(2:end-1) = .001;
% f=fit([1:366]',[atmosphere.atLevel.H2.nd(1:end-1),atmosphere.atLevel.H2.nd(1)]','poly3','Weights',wts);
% atmosphere.dummyH2 = f(1:366);



% % CO
% wts = ones(1,366); wts(2:end-1) = .001;
% f=fit([1:366]',[atmosphere.atLevel.CO.nd(1:end-1),atmosphere.atLevel.CO.nd(1)]','poly3','Weights',wts);
% atmosphere.dummyCO = f(1:366);

switch inputs.runtype        
    case 'solubility'
        
        atmosphere.dummySAD = solancil.ancil.SAD_SULFC.vmr(inputs.altitude+1,1:inputs.days);   % 1.5 is arbitrary 
        atmosphere.aoc_aso4_ratio = solancil.ancil.aoc.vmr(inputs.altitude+1,1:inputs.days)./solancil.ancil.aso4.vmr(inputs.altitude+1,1:inputs.days);        
        atmosphere.radius = solancil.ancil.SULFRE.vmr(inputs.altitude+1,1:inputs.days).*1e-4;
        
    %atmosphere.aoc_aso4_ratio(:) = .1;
    case 'doublelinear'
        atmosphere.dummySAD = solancil.ancil.SAD_SULFC.vmr(inputs.altitude+1,1:inputs.days);   % 1.5 is arbitrary 
                
        atmosphere.mixsulffrac = solancil.ancil.mixsulffrac.vmr(inputs.altitude+1,1:inputs.days);
        atmosphere.so4pure = solancil.ancil.so4pure.vmr(inputs.altitude+1,1:inputs.days);
        
        atmosphere.radius = solancil.ancil.SULFRE.vmr(inputs.altitude+1,1:inputs.days).*1e-4;
        
    case 'control'
        
        SADini = .7e-8;
        atmosphere.dummySAD = SADini+1e-9 + SADini./40.*sin(2*pi./365.*(1:365)+pi.*1.1);
        
        if strcmp(inputs.radius,'ancil')
            atmosphere.radius = controlancil.SULFRE.vmr(inputs.altitude+1,:).*1e-4; % cm; 
        else
            atmosphere.radius = inputs.radius;
        end
    
end    
%% initialize variables

% variables.O3 = atmosphere.dummyO3(1);
% variables.CLONO2 = atmosphere.dummyCLONO2(1);
% variables.HCL = atmosphere.dummyHCL(1);
% variables.HNO3 = atmosphere.dummyHNO3(1);
% variables.O1D = atmosphere.atLevel.O1D.nd(1);
% variables.CLO = 1e5;
% variables.HOCL = atmosphere.atLevel.HOCL.nd(1);
% variables.OCLO = 1e4;
% variables.BRCL = 1e4;
% variables.O = 1e1;
% variables.CL = atmosphere.atLevel.CL.nd(1);
% variables.CL2 = atmosphere.atLevel.CL2.nd(1);
% variables.CL2O2 = atmosphere.atLevel.CL2O2.nd(1);
% variables.NO = 1e1;
% variables.NO2 = 1e9;
% variables.NO3 = 1e6;
% variables.N2O5 = atmosphere.atLevel.N2O5.nd(1)+6e8;
% variables.OH = atmosphere.atLevel.OH.nd(1);
% variables.HO2 = atmosphere.atLevel.HO2.nd(1);
% variables.H2O2 = atmosphere.atLevel.H2O2.nd(1);
% variables.HO2NO2 = atmosphere.atLevel.HO2NO2.nd(1);
% variables.BRO = 1e7;
% variables.HBR = atmosphere.atLevel.HBR.nd(1);
% variables.HOBR = atmosphere.atLevel.HOBR.nd(1);
% variables.BRONO2 = atmosphere.atLevel.BRONO2.nd(1)-.8e6;
% variables.BR = atmosphere.atLevel.BR.nd(1);

% initializing vars to input ancil data will ensure CLY, BRY etc will start
% with appropriate number densities
variables.O3 = atmosphere.dummyO3(1);
variables.CLONO2 = atmosphere.dummyCLONO2(1);
variables.HCL = atmosphere.dummyHCL(1);
variables.HNO3 = atmosphere.dummyHNO3(1);
variables.O1D = atmosphere.atLevel.O1D.nd(1);
variables.CLO = atmosphere.atLevel.CLO.nd(1);
variables.HOCL = atmosphere.atLevel.HOCL.nd(1);
variables.OCLO = atmosphere.atLevel.OCLO.nd(1);
variables.BRCL = atmosphere.atLevel.BRCL.nd(1);
variables.O = atmosphere.atLevel.O.nd(1);
variables.CL = atmosphere.atLevel.CL.nd(1);
variables.CL2 = atmosphere.atLevel.CL2.nd(1);
variables.CL2O2 = atmosphere.atLevel.CL2O2.nd(1);
variables.NO = atmosphere.atLevel.NO.nd(1);
variables.NO2 = atmosphere.atLevel.NO2.nd(1);
variables.NO3 = atmosphere.atLevel.NO3.nd(1);
variables.N2O5 = atmosphere.atLevel.N2O5.nd(1);
variables.OH = atmosphere.atLevel.OH.nd(1);
variables.HO2 = atmosphere.atLevel.HO2.nd(1);
variables.H2O2 = atmosphere.atLevel.H2O2.nd(1);
variables.HO2NO2 = atmosphere.atLevel.HO2NO2.nd(1);
variables.BRO = atmosphere.atLevel.BRO.nd(1);
variables.HBR = atmosphere.atLevel.HBR.nd(1);
variables.HOBR = atmosphere.atLevel.HOBR.nd(1);
variables.BRONO2 = atmosphere.atLevel.BRONO2.nd(1);
variables.BR = atmosphere.atLevel.BR.nd(1);

% diagnostics
ancilCLY =  atmosphere.atLevel.CL.nd(1) + atmosphere.atLevel.CL2.nd(1).*2 + ...
    atmosphere.atLevel.CLONO2.nd(1) + atmosphere.atLevel.HOCL.nd(1) + atmosphere.atLevel.CLO.nd(1) + ...
    atmosphere.atLevel.HCL.nd(1) + atmosphere.atLevel.OCLO.nd(1) + atmosphere.atLevel.BRCL.nd(1) + atmosphere.atLevel.CL2O2.nd(1).*2;

initCLY = variables.CL(1) + variables.CL2(1).*2 + ...
    variables.CLONO2(1) + variables.HOCL(1) + variables.CLO(1) + ...
    variables.HCL(1) + variables.OCLO(1) + variables.BRCL(1) + variables.CL2O2(1).*2;

ancilNO2 =  atmosphere.atLevel.BRONO2.nd(1) + atmosphere.atLevel.CLONO2.nd(1) + atmosphere.atLevel.HO2NO2.nd(1) +...
        atmosphere.atLevel.NO3.nd(1) + atmosphere.atLevel.NO.nd(1) + atmosphere.atLevel.NO2.nd(1) + atmosphere.atLevel.HNO3.nd(1) + atmosphere.atLevel.N2O5.nd(1).*2;

initNO2 = variables.BRONO2(1) + variables.CLONO2(1) + variables.HO2NO2(1) +...
        variables.NO3(1) + variables.NO(1) + variables.NO2(1) + variables.HNO3(1) + variables.N2O5(1).*2;
    
ancilHOY = atmosphere.atLevel.HO2.nd(1) + atmosphere.atLevel.OH.nd(1) + atmosphere.atLevel.H2O2.nd(1).*2 +...
        atmosphere.atLevel.HO2NO2.nd(1) + atmosphere.atLevel.HNO3.nd(1) + atmosphere.atLevel.HOBR.nd(1) + atmosphere.atLevel.HOCL.nd(1) + atmosphere.atLevel.HCL.nd(1) + atmosphere.atLevel.HBR.nd(1);        
    
initHOY = variables.HO2(1) + variables.OH(1) + variables.H2O2(1).*2 +...
        variables.HO2NO2(1) + variables.HNO3(1) + variables.HOBR(1) + variables.HOCL(1) + variables.HCL(1) + variables.HBR(1);    
    
ancilBRY = atmosphere.atLevel.BRONO2.nd(1) + atmosphere.atLevel.HBR.nd(1) + atmosphere.atLevel.BR.nd(1) +...
        atmosphere.atLevel.BRCL.nd(1) + atmosphere.atLevel.HOBR.nd(1) + atmosphere.atLevel.BRO.nd(1);    
    
initBRY = variables.BRONO2(1) + variables.HBR(1) + variables.BR(1) +...
        variables.BRCL(1) + variables.HOBR(1) + variables.BRO(1);

    function out = createdummyvariables(varin,phasein)
        ini = varin(1);
        amp = max(varin) - min(varin);
        dummyvar = ini + amp./2.*sin(2*pi./365.*(1:365) + phasein);
        startdiff = (dummyvar(1) - ini);
        out = dummyvar - startdiff;
    end

    function out = fitancil(varin,weight)
        wts = ones(1,365); wts(2:end-1) = weight;
        f=fit([1:365]',[varin(1:364),varin(1)]','poly3','Weights',wts);
        out = f(1:366);
    end

end
