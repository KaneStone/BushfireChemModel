function [rate] = gasphaserates_opt(atmosphere,step)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    % O1D + N2 -> O + N2 --------------------------------------------------
    rate.N2_O1D = 2.15e-11.*exp(110./atmosphere.atLevel.T(step.doy));           
    
    % O1D + O2 -> O + O2 --------------------------------------------------
    rate.O2_O1D = 3.30e-11.*exp(55./atmosphere.atLevel.T(step.doy));                
    
    %variables.O1D(timeind)-eqvars.O1D;
    
    % O + O2 + M -> O3 + M ------------------------------------------------
    rate.O_O2_M = 6e-34.*(atmosphere.atLevel.T(step.doy)./300).^-2.4...
        .*atmosphere.atLevel.M(step.doy);         
     
    % O3 + O -> 2*O2 ------------------------------------------------------    
    rate.O3_O = 8e-12.*exp(-2060./atmosphere.atLevel.T(step.doy));
    
    % O1D + O3 -> O2 + O2 -------------------------------------------------
    rate.O1D_O3 = 1.2e-10;
    
    %O + O + M ->  O2 + M -------------------------------------------------
    rate.O_O_M = 2.76e-34*exp(720./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.M(step.doy);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOx
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % binary              
    % NO + HO2 ->  NO2 + OH         
    rate.NO_HO2 = 3.30e-12*exp(270./atmosphere.atLevel.T(step.doy));       
    
    % NO + O3 ->  NO2 + O2     
    rate.NO_O3 = 3.00e-12*exp(-1500./atmosphere.atLevel.T(step.doy));                       
    
     % NO2 + O ->  NO + O2    
    rate.NO2_O = 5.10e-12*exp(210./atmosphere.atLevel.T(step.doy));
                                            
    % NO2 + O3 ->  NO3 + O2 
    rate.NO2_O3 = 1.20e-13*exp(-2450./atmosphere.atLevel.T(step.doy));
        
    
    % NO3 + NO ->  2*NO2 
    rate.NO3_NO = 1.50e-11*exp(170./atmosphere.atLevel.T(step.doy));
        
    
    % NO3 + O ->  NO2 + O2  
    rate.NO3_O = 1.00e-11;
    
    % NO3 + OH ->  HO2 + NO2  
    rate.NO3_OH = 2.20e-11;
    
    % NO3 + HO2 ->  OH + NO2 + O2  
    rate.NO3_HO2 = 3.50e-12;
    
    % O1D + N2O ->  2*NO
    rate.O1D_N2Oa = 7.25E-11*exp(20./atmosphere.atLevel.T(step.doy));
    
    % O1D + N2O ->  N2+O2
    rate.O1D_N2Ob = 4.63E-11*exp(110./atmosphere.atLevel.T(step.doy));
    
    % CH3O2 + NO ->  CH3O + NO2
    rate.CH3O2_NO = 2.80e-12*exp(300./atmosphere.atLevel.T(step.doy));
    
    % CH2O + NO3 ->  CO + HO2 + HNO3
    rate.NO3_CH2O = 6.00e-13*exp(-2058./atmosphere.atLevel.T(step.doy));
    
    % HNO3 + OH ->  NO3 + H2O 
    k0 = 2.4e-14.*exp(460./atmosphere.atLevel.T(step.doy));
    k2 = 2.7e-17.*exp(2199./atmosphere.atLevel.T(step.doy));
    k3 = 6.5e-34.*exp(1335./atmosphere.atLevel.T(step.doy));
    rate.HNO3_OH = k0 + k3.*atmosphere.atLevel.M(step.doy)./...
        (1 + k3.*atmosphere.atLevel.M(step.doy)./k2);        
    
    %ternary
    %NO2 + HO2 + M ->  HO2NO2 + M  
%     k0 = 2.00e-31*(300./atmosphere.atLevel.T(step.doy)).^3.40;           
%     ki = 2.90e-12*(300./atmosphere.atLevel.T(step.doy)).^1.10;  
    k0 = 1.90e-31*(300./atmosphere.atLevel.T(step.doy)).^3.40;           
    ki = 4e-12*(300./atmosphere.atLevel.T(step.doy)).^.3;  
    kNO2HO2 = termolecular(k0,ki,atmosphere,step);
    rate.NO2_HO2_M = kNO2HO2;

    % NO + O + M ->  NO2 + M  
    k0 = 9.00e-32*(300./atmosphere.atLevel.T(step.doy)).^1.50;                 
    ki = 3.00e-11;                                                                 
    rate.NO_O_M = termolecular(k0,ki,atmosphere,step);
    
     % NO2 + NO3 + M ->  N2O5 + M 
    k0 = 2.0e-30*(300./atmosphere.atLevel.T(step.doy)).^4.4;             
    ki = 1.40e-12*(300./atmosphere.atLevel.T(step.doy)).^0.7;   
%     k0 = 2.4e-30*(300./atmosphere.atLevel.T(step.doy)).^3;             
%     ki = 1.60e-12*(300./atmosphere.atLevel.T(step.doy)).^-.1;   
    kNO2NO3 = termolecular(k0,ki,atmosphere,step);
    rate.NO2_NO3_M = kNO2NO3;
    
    % NO2 + O + M ->  NO3 + M  
    k0 = 2.50e-31*(300./atmosphere.atLevel.T(step.doy)).^1.80;                
    ki = 2.20e-11*(300./atmosphere.atLevel.T(step.doy)).^0.70;                           
    rate.NO2_O_M = termolecular(k0,ki,atmosphere,step);
    
    % NO2 + OH + M ->  HNO3 + M  
    k0 = 1.80e-30*(300./atmosphere.atLevel.T(step.doy)).^3.00;              
    ki = 2.80e-11;  
    rate.NO2_OH_M = termolecular(k0,ki,atmosphere,step);
        
    % N2O5 + M ->  NO2 + NO3 + M  
    N2O5_KO = (5.8e-27.*exp(10840./atmosphere.atLevel.T(step.doy)));
    rate.N2O5_M = kNO2NO3./N2O5_KO;
    
% NOx unused:

%     % NO + SO -> SO2 + N
%     rate.NO2_SO = 1.40E-11.*atmosphere.atLevel.SO.nd(step.doy).*variables.NO2(timeind); 

%     % N + O2 ->  NO + O    
%     rate.N_O2 = 1.50e-11*exp(-3600./atmosphere.atLevel.T(step.doy))... 
%         .*atmosphere.atLevel.N.nd(step.doy).*atmosphere.atLevel.O2.nd(step.doy);                              

%     % N + NO ->  N2 + O     
%     rate.N_NO = 2.10e-11*exp(100./atmosphere.atLevel.T(step.doy)...
%         .*atmosphere.atLevel.N.nd(step.doy).*variables.NO(timeind);                     

%     % N + NO2 ->  N2O + O           
%     rate.N_NO2a = 2.90e-12*exp(220./atmosphere.atLevel.T(step.doy)...
%         .*atmosphere.atLevel.N.nd(step.doy).*variables.NO2(timeind);    

%     % N + NO2 ->  2*NO   
%     rate.N_NO2b = 1.45e-12*exp(220./atmosphere.atLevel.T(step.doy))...
%         .*atmosphere.atLevel.N.nd(step.doy).*variables.NO2(timeind);   

%      % N + NO2 ->  N2 + O2    
%     rate.N_NO2c = 1.45e-12*exp(220./atmosphere.atLevel.T(step.doy)...
%         .*atmosphere.atLevel.N.nd(step.doy).*variables.NO2(timeind);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HOx
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
   
    % H + O3 ->  OH + O2      
    rate.H_O3 = 1.40e-10*exp(-470./atmosphere.atLevel.T(step.doy));
    
     % OH + O ->  H + O2 
    rate.OH_O = 1.80e-11*exp(180./atmosphere.atLevel.T(step.doy));
    
     % OH + O3 ->  HO2 + O2
    rate.OH_O3 = 1.70e-12*exp(-940./atmosphere.atLevel.T(step.doy));
    
    % OH + HO2 ->  H2O + O2
    rate.OH_HO2 = 4.80e-11*exp(250./atmosphere.atLevel.T(step.doy));
    
    % OH + OH ->  H2O + O 
    rate.OH_OH = 1.80e-12;
    
    % OH + H2 ->  H2O + H
    rate.OH_H2 = 2.80e-12*exp(-1800./atmosphere.atLevel.T(step.doy));
    
    % OH + H2O2 ->  H2O + HO2  
    rate.OH_H2O2 = 1.80e-12;
    
    % OH + CH2O ->  CO + H2O + H 
    rate.OH_CH2O = 5.5e-12*exp(125./atmosphere.atLevel.T(step.doy));
    
    % HO2 + CH2O ->  HOCH2OO
    rate.HO2_CH2O = 9.7e-15*exp(625./atmosphere.atLevel.T(step.doy));
    
    % HO2 + O ->  OH + O2
    rate.HO2_O = 3.00e-11*exp(200./atmosphere.atLevel.T(step.doy));
    
    % HO2 + O3 ->  OH + 2*O2  
    rate.HO2_O3 = 1.00e-14*exp(-490./atmosphere.atLevel.T(step.doy));
    
    %O1D + H2O ->  2*OH 
    rate.H2O_O1D = 1.63e-10.*exp(60./atmosphere.atLevel.T(step.doy));
    
    %O1D + H2 ->  H + OH
    rate.H2_O1D = 1.2e-10;        
    
    %O1D + CH4 ->  CH3O2 + OH
    rate.CH4_O1D = 1.31e-10;
    
    % HO2 + HO2 ->  H2O2 + O2 
    ko = 3e-13.*exp(460./atmosphere.atLevel.T(step.doy));
    kinf = 2.1e-33.*atmosphere.atLevel.M(step.doy).*...
        exp(920./atmosphere.atLevel.T(step.doy));
    fc = 1 + 1.4e-21.*atmosphere.dummyH2Ovmr(step.doy).*...
        exp(2200./atmosphere.atLevel.T(step.doy));        
    rate.HO2_HO2 = (ko + kinf).*fc;
    
    % HO2NO2 + OH ->  H2O + NO2 + O2
    rate.HO2NO2_OH = 1.30e-12*exp(380./atmosphere.atLevel.T(step.doy));
                         
    % HO2NO2 + M ->  HO2 + NO2 + M    
    HO2NO2_KO = 2.1e-27.*exp(10900./atmosphere.atLevel.T(step.doy));
    rate.HO2NO2_M = kNO2HO2./HO2NO2_KO;            
         
    % CH4 + OH ->  CH3O2 + H2O
    rate.CH4_OH = 2.45e-12*exp(-1775./atmosphere.atLevel.T(step.doy));
    
    % H2O2 + O ->  OH + HO2
    rate.H2O2_O = 1.40e-12*exp(-2000./atmosphere.atLevel.T(step.doy));
    
    %ternary        
    % H + O2 + M ->  HO2 + M 
    k0 = 4.40e-32*(300./atmosphere.atLevel.T(step.doy)).^1.30;                
    ki = 7.50e-11*(300./atmosphere.atLevel.T(step.doy)).^-0.20;                             
    rate.H_O2_M = termolecular(k0,ki,atmosphere,step);
    
    % OH + OH + M ->  H2O2 + M
    k0 = 6.90e-31*(300./atmosphere.atLevel.T(step.doy)).^1.00;            
    ki = 2.60e-11;      
    rate.OH_OH_M = termolecular(k0,ki,atmosphere,step);
    
    % OH + CO + M ->  CO2 + HO2
    k0=5.90e-33*(300./atmosphere.atLevel.T(step.doy)).^1.4;            
    ki=1.10e-12*(300./atmosphere.atLevel.T(step.doy)).^1.3;  %                                                         
    rate.OH_CO_Ma = termolecular(k0,ki,atmosphere,step);
    
    % OH + CO + M ->  H + CO2 + M
    k0=1.50e-13*(300./atmosphere.atLevel.T(step.doy)).^0;           
    ki=2.10e9*(300./atmosphere.atLevel.T(step.doy)).^6.1;  %            
    rate.OH_CO_Mb = chemicalactivation(k0,ki,atmosphere,step);
    
    % OH + SO2 + M -> HSO3 + M
    k0=3.30e-31*(300./atmosphere.atLevel.T(step.doy)).^4.3;            
    ki=1.6e-12;  %                                                         
    rate.SO2_OH_M = termolecular(k0,ki,atmosphere,step);
%     % OH + CO = M -> HO2 + CO2 (combined branches)
%     rate.OH_CO_M = 1.5e-13.*(1+6e-8.*1e7.*1.38e-23.*atmosphere.atLevel.M(step.doy)).*...
%         atmosphere.atLevel.T(step.doy);        
    
% HOx unused
        
%     % H + HO2 ->  2*OH 
%     rate.H_HO2a = 7.20e-11.*...
%     atmosphere.atLevel.H.nd(step.doy).*variables.HO2(timeind);    
% 
%     % H + HO2 ->  H2 + O2
%     rate.H_HO2b = 6.90e-12.*...
%     atmosphere.atLevel.H.nd(step.doy).*variables.HO2(timeind);  
% 
%     %  H + HO2 ->  H2O + O
%     rate.H_HO2c = 1.60e-12.*...
%     atmosphere.atLevel.H.nd(step.doy).*variables.HO2(timeind);

%     % H2 + O ->  OH + H
%     rate.H2_O = 1.60e-11*exp(-4570./atmosphere.atLevel.T(step.doy)...
%         .*atmosphere.atLevel.H2.nd(step.doy).*variables.O(timeind);        

%     % HCN + OH + M ->  HO2 + M
%     k0 = 4.28e-33;                                                       
%     ki = 9.30e-15*(300./atmosphere.atLevel.T(step.doy).^-4.42;                             
%     rate.HCN_OH_M = termolecular(k0,ki).*...
%         atmosphere.atLevel.HCN.nd(step.doy).*variables.OH(timeind);

% % CH3CN + OH ->  HO2 
%     rate.CH3CN_OH = 7.80e-13*exp(-1050./atmosphere.atLevel.T(step.doy)...
%         .*atmosphere.atLevel.CH3CN.nd(step.doy).*variables.OH(timeind);                       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLOx/BROx
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    % CL + O3 ->  CLO + O2
    rate.CL_O3 = 2.30e-11*exp(-200./(atmosphere.atLevel.T(step.doy)));
     
    % CL + H2 ->  HCL + H
    rate.CL_H2 = 3.05e-11*exp(-2270./atmosphere.atLevel.T(step.doy));
    
    % CL + H2O2 ->  HCL + HO2
    rate.CL_H2O2 = 1.10e-11*exp(-980./atmosphere.atLevel.T(step.doy));
    
    % CL + HO2 ->  HCL + O2
    rate.CL_HO2a = 1.40e-11*exp(270./atmosphere.atLevel.T(step.doy));
    
    % CL + HO2 ->  OH + CLO
    rate.CL_HO2b = 3.60e-11*exp(-375./atmosphere.atLevel.T(step.doy));
    
    % CL + CH2O ->  HCL + HO2 + CO
    rate.CL_CH2O = 8.10e-11*exp(-30./atmosphere.atLevel.T(step.doy));
    
     % CL + CH4 ->  CH3O2 + HCL
    rate.CL_CH4 = 7.30e-12*exp(-1280./atmosphere.atLevel.T(step.doy));
    
    % CLO + O ->  CL + O2
    rate.CLO_O = 2.80e-11*exp(85./atmosphere.atLevel.T(step.doy));
    
    % CLO + OH ->  CL + HO2
    rate.CLO_OHa = 7.40e-12*exp(270./atmosphere.atLevel.T(step.doy));
    
    % CLO + OH ->  HCL + O2
    rate.CLO_OHb = 6.00e-13*exp(230./atmosphere.atLevel.T(step.doy));
    
    % CLO + HO2 ->  O2 + HOCL
    rate.CLO_HO2 = 2.60e-12*exp(290./atmosphere.atLevel.T(step.doy));
    
    % CLO + CH3O2 ->  CL + HO2 + CH2O
    rate.CLO_CH3O2 = 3.30e-12*exp(-115./atmosphere.atLevel.T(step.doy));
    
    % CLO + NO ->  NO2 + CL
    rate.CLO_NO = 6.40e-12*exp(290./atmosphere.atLevel.T(step.doy));
    
    % CLO + CLO ->  2*CL + O2 
    rate.CLO_CLOa = 3.00e-11*exp(-2450./atmosphere.atLevel.T(step.doy));
    
    % CLO + CLO ->  CL2 + O2 
    rate.CLO_CLOb = 1.00e-12*exp(-1590./atmosphere.atLevel.T(step.doy));
    
    % CLO + CLO ->  CL + OCLO
    rate.CLO_CLOc = 3.50e-13*exp(-1370./atmosphere.atLevel.T(step.doy));
    
    % HCL + OH ->  H2O + CL
    rate.HCL_OH = 1.80e-12*exp(-250./atmosphere.atLevel.T(step.doy));
    
    % HCL + O1D -> CL + OH
    rate.HCL_O1D = 1.5e-10;
    
    % HCL + O ->  CL + OH 
    rate.HCL_O = 1.00e-11*exp(-3300./atmosphere.atLevel.T(step.doy));
    
    % HOCL + O ->  CLO + OH
    rate.HOCL_O = 1.70e-13;
    
    % HOCL + CL ->  HCL + CLO 
    rate.HOCL_CL = 3.40e-12*exp(-130./atmosphere.atLevel.T(step.doy));
    
    % HOCL + OH ->  H2O + CLO 
    rate.HOCL_OH = 3.00e-12*exp(-500./atmosphere.atLevel.T(step.doy));
    
    % CLONO2 + O ->  CLO + NO3
    rate.CLONO2_O = 3.60e-12*exp(-840./atmosphere.atLevel.T(step.doy));
    
    % CLONO2 + OH ->  HOCL + NO3
    rate.CLONO2_OH = 1.20e-12*exp(-330./atmosphere.atLevel.T(step.doy));
    
    % CLONO2 + CL ->  CL2 + NO3
    rate.CLONO2_CL = 6.50e-12*exp(135./atmosphere.atLevel.T(step.doy));
    
    % BR + O3 ->  BRO + O2                                    
    rate.BR_O3 = 1.60e-11*exp(-780./atmosphere.atLevel.T(step.doy));
    
    % BR + HO2 ->  HBR + O2
    rate.BR_HO2 = 4.80e-12*exp(-310./atmosphere.atLevel.T(step.doy));
    
    % BR + CH2O ->  HBR + HO2 + CO
    rate.BR_CH2O = 1.70e-11*exp(-800./atmosphere.atLevel.T(step.doy));
    
    % BRO + O ->  BR + O2
    rate.BRO_O = 1.90e-11*exp(230./atmosphere.atLevel.T(step.doy));
    
    % BRO + OH ->  BR + HO2
    rate.BRO_OH = 1.70e-11*exp(250./atmosphere.atLevel.T(step.doy));
    
    % BRO + HO2 ->  HOBR + O2
    rate.BRO_HO2 = 4.50e-12*exp(460./atmosphere.atLevel.T(step.doy));
    
    % BRO + NO ->  BR + NO2  
    rate.BRO_NO = 8.80e-12*exp(260./atmosphere.atLevel.T(step.doy));
    
    % BRO + CLO ->  BR + OCLO
    rate.BRO_CLOa = 9.50e-13*exp(550./atmosphere.atLevel.T(step.doy));
    
    % BRO + CLO ->  BR + CL + O2
    rate.BRO_CLOb = 2.30e-12*exp(260./atmosphere.atLevel.T(step.doy));
    
    % BRO + CLO ->  BRCL + O2 
    rate.BRO_CLOc = 4.10e-13*exp(290./atmosphere.atLevel.T(step.doy));
    
     % BRO + BRO ->  2*BR + O2
    rate.BRO_BRO = 1.50e-12*exp(230./atmosphere.atLevel.T(step.doy));
    
     % HBR + OH ->  BR + H2O 
    rate.HBR_OH = 5.50e-12*exp(200./atmosphere.atLevel.T(step.doy));
    
    % HBR + O1D ->  BR + OH
    rate.HBR_O1D = 1.2e-10;
    
     % HOBR + O ->  BRO + OH   
    rate.HOBR_O = 1.20e-10*exp(-430./atmosphere.atLevel.T(step.doy));
    
    % BRONO2 + O ->  BRO + NO3 
    rate.BRONO2_O = 1.90e-11*exp(215./atmosphere.atLevel.T(step.doy));
    
    % BR + OCLO ->  BRO + CLO 
    rate.BR_OCLO = 2.6e-11*exp(-1300./atmosphere.atLevel.T(step.doy));
    
    %ternary
    % CLO + NO2 + M ->  CLONO2 + M
    k0 = 1.80e-31*(300./atmosphere.atLevel.T(step.doy)).^3.40;                                           
    ki = 1.50e-11*(300./atmosphere.atLevel.T(step.doy)).^1.90;  %                                                            
    kCLO_NO2_M = termolecular(k0,ki,atmosphere,step);
    rate.CLO_NO2_M = kCLO_NO2_M;
    
    % CLO + CLO + M ->  CL2O2 + M 
    k0 = 1.60e-32*(300./atmosphere.atLevel.T(step.doy)).^4.50;                                           
    ki = 3.00e-12*(300./atmosphere.atLevel.T(step.doy)).^2.00;  %                                                         
    rate.CLO_CLO_M = termolecular(k0,ki,atmosphere,step);
    
    % CL2O2 + M ->  CLO + CLO + M
    CL2O2_KO = 2.16e-27.*exp(8537./atmosphere.atLevel.T(step.doy));
    rate.CL2O2_M = kCLO_NO2_M./CL2O2_KO;
       
    % BRO + NO2 + M ->  BRONO2 + M 
    k0=5.20e-31*(300./atmosphere.atLevel.T(step.doy)).^3.10;                                            
    ki=6.50e-12*(300./atmosphere.atLevel.T(step.doy)).^2.90;                                                          
    rate.BRO_NO2_M = termolecular(k0,ki,atmosphere,step);
    
%     % CL + O2 + M ->  CLOO  
%     k0 = 2.2e-33*(300./atmosphere.atLevel.T(step.doy).^3.1;                    
%     ki = 1.8e-10;  
%     rate.CL_O2_M = k0...
%         .*variables.CL(timeind).*atmosphere.atLevel.O2.nd(step.doy)...
%         .*atmosphere.atLevel.M(step.doy);
%     
%     % CL + NO2 + M ->  CLONO
%     k0 = 1.3e-30*(300./atmosphere.atLevel.T(step.doy).^2;              
%     ki = 1e-10*(300./atmosphere.atLevel.T(step.doy).^1;                
%     rate.CL_NO2_M = termolecular(k0,ki)...
%         .*variables.CL(timeind).*variables.NO2(timeind);
%     
%     % CL + NO + M ->  CLNO
%     rate.CL_NO_M = 7.6e-32*(300./atmosphere.atLevel.T(step.doy).^1.8...
%         .*variables.CL(timeind).*variables.NO(timeind).*atmosphere.atLevel.M(step.doy); %ko              
% %     ki = 1e-10*(300./atmosphere.atLevel.T(step.doy).^1;                
% %     rate.CL_NO2_M = termolecular(k0,ki)...
% 
%  % CL + CO + M ->  CLCO
%     rate.CL_CO_M = 1.3e-33*(300./atmosphere.atLevel.T(step.doy).^1.8...
%         .*variables.CL(timeind).*atmosphere.atLevel.CO.nd(step.doy).*atmosphere.atLevel.M(step.doy); %ko              
% %     ki = 1e-10*(300./atmosphere.atLevel.T(step.doy).^1;                
%     rate.CL_NO2_M = termolecular(k0,ki)...
        
    
% CLOx/BROx unused
%     % CLO + SO -> SO2 + CL 
%     rate.CLO_SO = 2.80e-11.*variables.CLO(timeind).*atmosphere.atLevel.SO.nd(step.doy); 

%     % CH3CL + CL ->  HO2 + CO + 2*HCL
%     rate.CH3CL_CL = 2.17e-11*exp(-1130./atmosphere.atLevel.T(step.doy)...
%         .*atmosphere.atLevel.CH3CL.nd(step.doy).*variables.CL(timeind);    

%     % CH3CL + OH ->  CL + H2O + HO2
%     rate.CH3CL_OH = 2.40e-12*exp(-1250./atmosphere.atLevel.T(step.doy)...
%         .*atmosphere.atLevel.CH3CL.nd(step.doy).*variables.OH(timeind);    

%     % CH3CCL3 + OH ->  H2O + 3*CL
%     rate.CH3CCL3_OH = 1.64e-12*exp(-1520./atmosphere.atLevel.T(step.doy)...
%          .*atmosphere.atLevel.CH3CCL3.nd(step.doy).*variables.OH(timeind);         
          
%     % CH3BR + O1D ->  BR 
%     rate.CH3BR_O1D = 1.67e-10...
%         .*atmosphere.atLevel.CH3BR.nd(step.doy).*O1D;           

%     % CH3BR + OH ->  BR + H2O + HO2
%     rate.CH3BR_OH = 2.35e-12*exp(-1300./atmosphere.atLevel.T(step.doy)...
%         .*variables.OH(timeind).*atmosphere.atLevel.CH3BR.nd(step.doy);   

%     % CH3BR + CL ->  HCL + HO2 + BR 
%     rate.CH3BR_CL = 1.40e-11*exp(-1030./atmosphere.atLevel.T(step.doy)...
%         .*atmosphere.atLevel.CH3BR.nd(step.doy).*variables.CL(timeind);    

%     % CHBR3 + O1D ->  3BR
%     rate.CHBR3_O1D = 4.49e-10...
%         .*atmosphere.atLevel.CHBR3.nd(step.doy).*O1D;   

%     % HBR + O1D ->  2BR
%     rate.CH2BR2_O1D = 2.57e-10...
%         .*atmosphere.atLevel.CH2BR2.nd(step.doy).*O1D;        

%     % CHBR3 + CL ->  3*BR + HCL
%     rate.CHBR3_CL = 4.85e-12*exp(-850./atmosphere.atLevel.T(step.doy)...
%         .*atmosphere.atLevel.CHBR3.nd(step.doy).*variables.CL(timeind);      

%     % CH2BR2 + OH ->  2*BR + H2O 
%     rate.CH2BR2_OH = 2.00e-12*exp(-840./atmosphere.atLevel.T(step.doy)...
%         .*variables.OH(timeind).*atmosphere.atLevel.CH2BR2.nd(step.doy);    

%     % CHBR3 + OH ->  3*BR
%     rate.CHBR3_OH = 1.35e-12*exp(-600./atmosphere.atLevel.T(step.doy)...
%         .*variables.OH(timeind).*atmosphere.atLevel.CHBR3.nd(step.doy);    


%     % HBR + O ->  BR + OH       
%     rate.HBR_O = 5.80e-12*exp(-1500./atmosphere.atLevel.T(step.doy)...
%          .*variables.HBR(timeind).*variables.O(timeind);     

%     % CH2BR2 + CL ->  2*BR + HCL
%     rate.CH2BR2_CL = 6.30e-12*exp(-800./atmosphere.atLevel.T(step.doy)...
%         .*atmosphere.atLevel.CH2BR2.nd(step.doy).*variables.CL(timeind);  

%     % C2H6 + CL ->  HCL + C2H5O2
%     rate.C2H6_CL = 7.20e-11*exp(-70./atmosphere.atLevel.T(step.doy)...
%         .*atmosphere.atLevel.C2H6.nd(step.doy).*variables.CL(timeind);   

    function kout = termolecular(k0,ki,atmosphere,step)                
        x = .6;
        xpo = k0.*atmosphere.atLevel.M(step.doy)./ki;
        rate1 = k0.*atmosphere.atLevel.M(step.doy)./(1+xpo);
        xpo = log10(xpo);
        xpo = 1./(1+xpo.^2);
        kout = rate1.*x.^xpo;                     
    end

    function kout = chemicalactivation(k0,ki,atmosphere,step)
        x = .6;
        xpo = k0./(ki./atmosphere.atLevel.M(step.doy));
        rate1 = k0./(1+xpo);
        xpo = log10(xpo);
        xpo = 1./(1+xpo.^2);
        kout = rate1.*x.^xpo;     
    end

end