function rates = gasphaserates(inputs,step,variables,atmosphere,i,rates)

    
%   first need to calculate atomic oxygen
%    rates.O.production
% 2*j1*O2  + j3*O3  + j5*NO  + j6*NO2  + j8*N2O5  + j10*NO3  + j19*H2O  + j22*CLO  + j23*OCLO  + j30*BRO
%                + j53*CO2  + .18*j55*CH4  + j83*SO2  + j84*SO3  + j86*SO  + r4*N2*O1D  + r5*O2*O1D  + r52*O2*N
%                + r277*O2*S  + r280*O2*SO  + r37*H*HO2  + r41*OH*OH  + r53*N*NO  + r54*N*NO2
%                - r1*O2*M*O  - r2*O3*O  - 2*r3*M*O*O  - r38*OH*O  - r45*H2*O  - r46*HO2*O  - r49*H2O2*O  - r57*M*NO*O
%                - r60*NO2*O  - r61*M*NO2*O  - r68*NO3*O  - r81*CLO*O  - r94*HCL*O  - r95*HOCL*O  - r98*CLONO2*O
%                - r104*BRO*O  - r114*HBR*O  - r115*HOBR*O  - r116*BRONO2*O  - r134*CH2O*O  - r274*OCS*O

% O RATES
%     rates.O.destruction(1) = 6e-34.*(atmosphere.atLevel.T(step.doy)./300).^-2.4.*...
%         atmosphere.atLevel.O2.nd(step.doy).*variables.O(i).*atmosphere.atLevel.M(step.doy); %O2_O_M 
%     test1 = 6e-34.*(atmosphere.atLevel.T(step.doy)./300).^-2.4.*...
%         atmosphere.atLevel.O2.nd(step.doy).*sum(rates.O.production).*atmosphere.atLevel.M(step.doy);
%     rates.O.destruction(2) = 8.00e-12.*exp(-2060./atmosphere.atLevel.T(step.doy)).*variables.O(i).*variables.O3(i);
%     test = 8.00e-12.*exp(-2060./atmosphere.atLevel.T(step.doy)).*sum(rates.O.production).*variables.O3(i)
%     
%     sum(rates.O.production)
    
    
%% O3 RATES
    rates.O3.production(1)= 6e-34.*(atmosphere.atLevel.T(step.doy)./300).^-2.4.*...
        atmosphere.atLevel.O2.nd(step.doy).*atmosphere.atLevel.O.nd(step.doy).*atmosphere.atLevel.M(step.doy); %O2_O_M 
% loss rates
%     if step.hour > 6 && step.hour < 18
%         rates.O3.destruction(2) = 0;
%     else
        rates.O3.destruction(2) = 8e-12.*exp(-2060./atmosphere.atLevel.T(step.doy)).*variables.O3(i).*atmosphere.atLevel.O.nd(step.doy); %O_O3 
%     end
    rates.O3.destruction(3) = 1e-10.*variables.O3(i).*atmosphere.atLevel.O1D.nd(step.doy);%O1D_O3 
    %rates.O3.destruction = 1.40e-10.*exp(-470./atmosphere.atLevel.atLevel.T).*O3test(step.doy).*conc.H;  %dH_O3 
    rates.O3.destruction(4) = 1.70e-12.*exp(-940./atmosphere.atLevel.T(step.doy)).*variables.O3(i).*atmosphere.atLevel.OH.nd(step.doy); %OH_O3 
    rates.O3.destruction(5) = 1.0e-14.*exp(-490./atmosphere.atLevel.T(step.doy)).*variables.O3(i).*atmosphere.atLevel.HO2.nd(step.doy); %HO2_O3 
    rates.O3.destruction(6) = 3e-12.*exp(-1500./atmosphere.atLevel.T(step.doy)).*variables.O3(i).*atmosphere.atLevel.NO.nd(step.doy); %NO_O3 
    rates.O3.destruction(7) = 1.2e-13.*exp(-2450./atmosphere.atLevel.T(step.doy)).*variables.O3(i).*atmosphere.atLevel.NO2.nd(step.doy); %NO2_O3 
    rates.O3.destruction(8) = 2.30e-11.*exp(-200./atmosphere.atLevel.T(step.doy)).*variables.O3(i).*atmosphere.atLevel.CL.nd(step.doy); %CL_O3
    rates.O3.destruction(9) = 1.6e-11.*exp(-780./atmosphere.atLevel.T(step.doy)).*variables.O3(i).*atmosphere.atLevel.BR.nd(step.doy); %BR_O3
    %O3diff = sum(rates.O3.production).*60*60*24 - sum(rates.O3.destruction).*60*60*24;
    %O3test(i) = O3test(step.doy) + O3diff;


% %% HCL need H2, H2O2, HO2,CHO2,CL,OH,CH4,CLO,HOCL,CH3CL,CH3Br,CH2Br2,CHBr3
% rates.HCL.pCL_H2 = 3.05e-11*exp(-2270/tempin).*conc.CL.*conc.H2;
% rates.HCL.pCL_H2O2 = 1.1e-11*exp(-980/tempin).*conc.CL.*conc.H2O2;
% rates.HCL.pCL_HO2 = 3.6e-11*exp(270/tempin).*conc.CL.*conc.HO2;
% rates.HCL.pCL_HO2 = 3.6e-11*exp(270/tempin).*conc.CL.*conc.HO2;
% rates.HCL.pCL_CH2O = 8.6e-11*exp(-30/tempin).*conc.CL.*conc.CHO2;
% rates.HCL.pCL_CH4 = 7.3e-12.*exp(-1280./level.T).*conc.CH4.*conc.CL;
% rates.HCL.pCLO_OH = 6e-13.*exp(230./level.T).*conc.CLO.*conc.OH;
% rates.HCL.pCL_HOCL = 3.4e-12*exp(-130./T).*conc.HOCL.*conc.CL;
% rates.HCL.pCL_CH3CL = 2.17e-11*exp(-1130./T).*conc.CH3CL.*conc.CL;
% rates.HCL.pCL_CH3Br = 1.4e-11*exp(-1030./T).*conc.CH3Br.*conc.CL;
% rates.HCL.pCL_CH2Br2 = 6.3e-11*exp(-800./T).*conc.CH2Br2.*conc.CL;
% rates.HCL.pCL_CHBr3 = 4.85e-11*exp(-850./T).*conc.CHBr3.*conc.CL;
% 
% % HCL destuction
% rates.HCL.dOH = 1.80e-12.*exp(-250./T).*conc.HCL.*conc.OH;
% rates.HCL.dO1D = 1.5e-10.*conc.O1D.*conc.HCL;
% rates.HCL.dO = 1e-11*exp(-3300./T).*conc.O.*conc.HCL;
% 
% %% CLONO2
% % production
% 
% % termolecular
% % second order termolecular rate constant from JPL: takes into account air density M
% M = 1./inputs.k*1e-6.*rpres(lev)./level.T;
% 
% k0=1.80e-31.*(300./(T)).^3.40; % low pressure limit
% ki=1.50e-11.*(300./(T)).^1.90; % high pressure limit
% x = .6;
% 
% xpo = k0.*M./ki;
% rate = k0./(1+xpo);
% xpo = log10(xpo);
% xpo = 1./(1+xpo.^2);
% k2 = rate.*x.^xpo;
% 
% rates.CLONO2.pCLO_NO2_M = k2.*conc.CLO.*conc.NO2;
% 
% % gas phase
% % destruction 
% rates.CLONO2.dO = 3.6e-12.*exp(-840./T).*conc.CLONO2.*conc.O;
% rates.CLONO2.dOH = 1.2e-12.*exp(-330./T).*conc.CLONO2.*conc.OH;
% rates.CLONO2.dCL = 6.5e-12.*exp(135./T).*conc.CLONO2.*conc.CL;
% 
% %% O3
% %production
% %termolecular (Look in model how this is done
% rates.O3.pO2_O_M = 6e-34.*(T/300).^-2.4.*conc.O2.*conc.O.*density; % this does not include M
% % loss rates
% rates.O3.dO_O3 = 8e-12.*exp(-2060/T).*conc.O3.*conc.O;
% rates.O3.dO1D_O3 = 1e-10;
% rates.O3.dH_O3 = 1.40e-10.*exp(-470./T).*conc.O3.*conc.H;
% rates.O3.dOH_O3 = 1.70e-12.*exp(-940./T).*conc.O3.*conc.OH;
% rates.O3.dHO2_O3 = 1.0e-14.*exp(-490./T).*conc.O3.*conc.HO2;
% rates.O3.dNO_O3 = 3e-12.*exp(-1500./T).*conc.O3.*conc.NO;
% rates.O3.dNO2_O3 = 1.2e-13.*exp(-2450./T).*conc.O3.*conc.NO2;
% rates.O3.dCL_O3 = 2.30e-11.*exp(-200./T).*conc.O3.*conc.CL;
% rates.O3.dBR_O3 = 1.6e-11.*exp(-780./T).*conc.O3.*conc.BR;
% 
% %% HOCL

%% CLO


end