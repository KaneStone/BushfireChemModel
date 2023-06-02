function out = gasphaserates(inputs)

%% HCL need H2, H2O2, HO2,CHO2,CL,OH,CH4,CLO,HOCL,CH3CL,CH3Br,CH2Br2,CHBr3
rates.HCL.pCL_H2 = 3.05e-11*exp(-2270/tempin).*conc.CL.*conc.H2;
rates.HCL.pCL_H2O2 = 1.1e-11*exp(-980/tempin).*conc.CL.*conc.H2O2;
rates.HCL.pCL_HO2 = 3.6e-11*exp(270/tempin).*conc.CL.*conc.HO2;
rates.HCL.pCL_HO2 = 3.6e-11*exp(270/tempin).*conc.CL.*conc.HO2;
rates.HCL.pCL_CH2O = 8.6e-11*exp(-30/tempin).*conc.CL.*conc.CHO2;
rates.HCL.pCL_CH4 = 7.3e-12.*exp(-1280./level.T).*conc.CH4.*conc.CL;
rates.HCL.pCLO_OH = 6e-13.*exp(230./level.T).*conc.CLO.*conc.OH;
rates.HCL.pCL_HOCL = 3.4e-12*exp(-130./T).*conc.HOCL.*conc.CL;
rates.HCL.pCL_CH3CL = 2.17e-11*exp(-1130./T).*conc.CH3CL.*conc.CL;
rates.HCL.pCL_CH3Br = 1.4e-11*exp(-1030./T).*conc.CH3Br.*conc.CL;
rates.HCL.pCL_CH2Br2 = 6.3e-11*exp(-800./T).*conc.CH2Br2.*conc.CL;
rates.HCL.pCL_CHBr3 = 4.85e-11*exp(-850./T).*conc.CHBr3.*conc.CL;

% HCL destuction
rates.HCL.dOH = 1.80e-12.*exp(-250./T).*conc.HCL.*conc.OH;
rates.HCL.dO1D = 1.5e-10.*conc.O1D.*conc.HCL;
rates.HCL.dO = 1e-11*exp(-3300./T).*conc.O.*conc.HCL;

%% CLONO2
% production

% termolecular
% second order termolecular rate constant from JPL: takes into account air density M
M = 1./inputs.k*1e-6.*rpres(lev)./level.T;

k0=1.80e-31.*(300./(T)).^3.40; % low pressure limit
ki=1.50e-11.*(300./(T)).^1.90; % high pressure limit
x = .6;

xpo = k0.*M./ki;
rate = k0./(1+xpo);
xpo = log10(xpo);
xpo = 1./(1+xpo.^2);
k2 = rate.*x.^xpo;

rates.CLONO2.pCLO_NO2_M = k2.*conc.CLO.*conc.NO2;

% gas phase
% destruction 
rates.CLONO2.dO = 3.6e-12.*exp(-840./T).*conc.CLONO2.*conc.O;
rates.CLONO2.dOH = 1.2e-12.*exp(-330./T).*conc.CLONO2.*conc.OH;
rates.CLONO2.dCL = 6.5e-12.*exp(135./T).*conc.CLONO2.*conc.CL;

%% O3
%production
%termolecular (Look in model how this is done
rates.O3.pO2_O_M = 6e-34.*(T/300).^-2.4.*conc.O2.*conc.O.*density; % this does not include M
% loss rates
rates.O3.dO_O3 = 8e-12.*exp(-2060/T).*conc.O3.*conc.O;
rates.O3.dO1D_O3 = 1e-10;
rates.O3.dH_O3 = 1.40e-10.*exp(-470./T).*conc.O3.*conc.H;
rates.O3.dOH_O3 = 1.70e-12.*exp(-940./T).*conc.O3.*conc.OH;
rates.O3.dHO2_O3 = 1.0e-14.*exp(-490./T).*conc.O3.*conc.HO2;
rates.O3.dNO_O3 = 3e-12.*exp(-1500./T).*conc.O3.*conc.NO;
rates.O3.dNO2_O3 = 1.2e-13.*exp(-2450./T).*conc.O3.*conc.NO2;
rates.O3.dCL_O3 = 2.30e-11.*exp(-200./T).*conc.O3.*conc.CL;
rates.O3.dBR_O3 = 1.6e-11.*exp(-780./T).*conc.O3.*conc.BR;

%% HOCL

%% CLO


end