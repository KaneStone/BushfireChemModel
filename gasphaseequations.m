function rate = gasphaseequations(atmosphere,variables,photo,timeind,step,day)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    kO1D_N2 = 2.15e-11.*exp(110./atmosphere.atLevel.T(step.doy));           % O1D_N2 O1D + N2 -> O + N2
    kO1D_O2 = 3.30e-11.*exp(55./atmosphere.atLevel.T(step.doy));            % O1D + O2 -> O + O2  
    O1D = photo(2).*variables.O3(timeind)./...
        (kO1D_N2.*atmosphere.atLevel.N2.nd(step.doy) + kO1D_O2.*atmosphere.atLevel.O2.nd(step.doy));
    
    rate.O_O2_M = 6e-34.*(atmosphere.atLevel.T(step.doy)./300).^-2.4...
         .*atmosphere.atLevel.O2.nd(step.doy)...
         .*variables.O(timeind)...
         .*atmosphere.atLevel.M(step.doy);                             % O + O2 + M -> O3 + M
     
    rate.O3_O = 8e-12.*exp(-2060./atmosphere.atLevel.T(step.doy))...
        .*variables.O3(timeind).*variables.O(timeind);    % O3 + O -> 2*O2    
    
    rate.O1D_O3 = 1.2e-10.*O1D.*variables.O3(timeind);                      % O1D + O3 -> O2 + O2           
    
    rate.O_O_M = 2.76e-34*exp(720./atmosphere.atLevel.T(step.doy))...
         .*(variables.O(timeind).^2)...         
         .*atmosphere.atLevel.M(step.doy);                             %O + O + M ->  O2 + M 
    
    rate.N2_O1D = kO1D_N2.*atmosphere.atLevel.N2.nd(step.doy).*O1D;
    rate.O2_O1D = kO1D_O2.*atmosphere.atLevel.O2.nd(step.doy).*O1D;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOx
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % binary
    rate.N_O2 = 1.50e-11*exp(-3600./atmosphere.atLevel.T(step.doy))... 
        .*atmosphere.atLevel.N.nd(timeind).*variables.NO2(timeind);                     % N + O2 ->  NO + O             
    rate.N_NO = 2.10e-11*exp(100./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.N.nd(timeind).*variables.NO(timeind);                      % N + NO ->  N2 + O             
    
    rate.N_NO2a = 2.90e-12*exp(220./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.N.nd(timeind).*variables.NO2(timeind);                     % N + NO2 ->  N2O + O           
    rate.N_NO2b = 1.45e-12*exp(220./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.N.nd(timeind).*variables.NO2(timeind);                     % N + NO2 ->  2*NO              
    rate.N_NO2c = 1.45e-12*exp(220./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.N.nd(step.doy).*variables.NO2(timeind);                     % N + NO2 ->  N2 + O2                  
    rate.NO_HO2 = 3.30e-12*exp(270./atmosphere.atLevel.T(step.doy))...
        .*variables.NO(timeind).*atmosphere.atLevel.HO2.nd(step.doy).*day;                    % NO + HO2 ->  NO2 + OH         
    rate.NO_O3 = 3.00e-12*exp(-1500./atmosphere.atLevel.T(step.doy))...
        .*variables.NO(timeind).*variables.O3(timeind);                     % NO + O3 ->  NO2 + O2          
    rate.NO2_O = 5.10e-12*exp(210./atmosphere.atLevel.T(step.doy))...
        .*variables.NO2(timeind).*variables.O(timeind);                     % NO2 + O ->  NO + O2                       
    rate.NO2_O3 = 1.20e-13*exp(-2450./atmosphere.atLevel.T(step.doy))...
        .*variables.NO2(timeind).*variables.O3(timeind);                    % NO2 + O3 ->  NO3 + O2                             
    rate.NO3_NO = 1.50e-11*exp(170./atmosphere.atLevel.T(step.doy))...
        .*variables.NO3(timeind).*variables.NO(timeind);                    % NO3 + NO ->  2*NO2            
    rate.NO3_O = 1.00e-11.*variables.NO3(timeind).*variables.O(timeind);    % NO3 + O ->  NO2 + O2          
    rate.NO3_OH = 2.20e-11.*variables.NO3(timeind).*atmosphere.atLevel.OH.nd(step.doy).*day;  % NO3 + OH ->  HO2 + NO2        
    rate.NO3_HO2 = 3.50e-12.*variables.NO3(timeind).*atmosphere.atLevel.HO2.nd(step.doy).*day;% NO3 + HO2 ->  OH + NO2 + O2   
    rate.O1D_N2Oa = 7.25E-11*exp(20./atmosphere.atLevel.T(step.doy))...
        .*O1D.*variables.NO2(timeind);                                      % O1D + N2O ->  2*NO
    rate.O1D_N2Ob = 4.63E-11*exp(110./atmosphere.atLevel.T(step.doy))...
        .*O1D.*variables.NO2(timeind);                                      % O1D + N2O ->  N2+O2
    
    rate.CH3O2_NO = 2.80e-12*exp(300./atmosphere.atLevel.T(step.doy))...
        .*variables.NO(timeind).*atmosphere.atLevel.CH3O2.nd(step.doy);           % CH3O2 + NO ->  CH2O + NO2 + HO2                              
    
    rate.NO2_SO = 1.40E-11.*atmosphere.atLevel.SO.nd(step.doy).*variables.NO2(timeind); % NO + SO -> SO2 + N
    
    rate.NO3_CH2O = 6.00e-13*exp(-2058./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.CH2O.nd(step.doy).*variables.NO3(timeind);      % CH2O + NO3 ->  CO + HO2 + HNO3                               
    
    k0 = 2.4e-14.*exp(460./atmosphere.atLevel.T(step.doy));
    k2 = 2.7e-17.*exp(2199./atmosphere.atLevel.T(step.doy));
    k3 = 6.5e-34.*exp(1335./atmosphere.atLevel.T(step.doy));
    rate.HNO3_OH = k0 + k3.*atmosphere.atLevel.M(step.doy)./...
        (1 + k3.*atmosphere.atLevel.M(step.doy)./k2)...
        .*atmosphere.atLevel.HNO3.nd(step.doy).*atmosphere.atLevel.OH.nd(step.doy);                   % HNO3 + OH ->  NO3 + H2O       
    
    %ternary
    k0 = 2.00e-31*(300./atmosphere.atLevel.T(step.doy)).^3.40;           %NO2 + HO2 + M ->  HO2NO2 + M  
    ki = 2.90e-12*(300./atmosphere.atLevel.T(step.doy)).^1.10;  
    kNO2HO2 = termolecular(k0,ki);
    rate.NO2_HO2_M = kNO2HO2...
        .*variables.NO2(timeind).*atmosphere.atLevel.HO2.nd(step.doy).*day;

    k0 = 9.00e-32*(300./atmosphere.atLevel.T(step.doy)).^1.50;           % NO + O + M ->  NO2 + M        
    ki = 3.00e-11;                                                                 
    rate.NO_O_M = termolecular(k0,ki)...
        .*variables.NO(timeind).*variables.O(timeind);
    
    k0 = 2.00e-30*(300./atmosphere.atLevel.T(step.doy)).^4.40;           % NO2 + NO3 + M ->  N2O5 + M    
    ki = 1.40e-12*(300./atmosphere.atLevel.T(step.doy)).^0.70;   
    kNO2NO3 = termolecular(k0,ki);
    rate.NO2_NO3_M = kNO2NO3...
        .*variables.NO2(timeind).*variables.NO3(timeind);
    
    k0 = 2.50e-31*(300./atmosphere.atLevel.T(step.doy)).^1.80;           % NO2 + O + M ->  NO3 + M       
    ki = 2.20e-11*(300./atmosphere.atLevel.T(step.doy)).^0.70;                           
    rate.NO2_O_M = termolecular(k0,ki)...
        .*variables.NO2(timeind).*variables.O(timeind);
    
    k0 = 1.80e-30*(300./atmosphere.atLevel.T(step.doy)).^3.00;           % NO2 + OH + M ->  HNO3 + M     
    ki = 2.80e-11;  
    rate.NO2_OH_M = termolecular(k0,ki)...
        .*variables.NO2(timeind).*atmosphere.atLevel.OH.nd(step.doy).*day;
    
    %rate.N2O5_M = kNO2NO3.*1.724138e26.*exp(-10840./atmosphere.atLevel.T(step.doy));          
    N2O5_KO = (5.8e-27.*exp(10840./atmosphere.atLevel.T(step.doy)));
    rate.N2O5_M = kNO2NO3./N2O5_KO...
        .*variables.N2O5(timeind);                                          % N2O5 + M ->  NO2 + NO3 + M                                                                              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HOx
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
   
          
    rate.H_O3 = 1.40e-10*exp(-470./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.H.nd(step.doy).*variables.O3(timeind);                       % H + O3 ->  OH + O2       
    rate.H_HO2a = 7.20e-11.*atmosphere.atLevel.H.nd(step.doy).*atmosphere.atLevel.HO2.nd(step.doy);    % H + HO2 ->  2*OH         
    rate.H_HO2b = 6.90e-12.*atmosphere.atLevel.H.nd(step.doy).*atmosphere.atLevel.HO2.nd(step.doy);    % H + HO2 ->  H2 + O2      
    rate.H_HO2c = 1.60e-12.*atmosphere.atLevel.H.nd(step.doy).*atmosphere.atLevel.HO2.nd(step.doy);    % H + HO2 ->  H2O + O      
    rate.OH_O = 1.80e-11*exp(180./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.OH.nd(step.doy).*atmosphere.atLevel.H.nd(step.doy);                      % OH + O ->  H + O2        
    rate.OH_O3 = 1.70e-12*exp(-940./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.OH.nd(step.doy).*variables.O3(timeind);                     % OH + O3 ->  HO2 + O2     
    rate.OH_HO2 = 4.80e-11*exp(250./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.OH.nd(step.doy).*atmosphere.atLevel.HO2.nd(step.doy);                    % OH + HO2 ->  H2O + O2    
    rate.OH_OH = 1.80e-12.*atmosphere.atLevel.OH.nd(step.doy).^2;                        % OH + OH ->  H2O + O                                            
    rate.OH_H2 = 2.80e-12*exp(-1800./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.OH.nd(step.doy).*atmosphere.atLevel.H2.nd(step.doy);                     % OH + H2 ->  H2O + H      
    rate.OH_H2O2 = 1.80e-12.*atmosphere.atLevel.OH.nd(step.doy).*atmosphere.atLevel.H2O2.nd(step.doy);% OH + H2O2 ->  H2O + HO2  
    rate.H2_O = 1.60e-11*exp(-4570./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.H2.nd(step.doy).*variables.O(timeind);                      % H2 + O ->  OH + H        
    rate.HO2_O = 3.00e-11*exp(200./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.HO2.nd(step.doy).*variables.O(timeind);                     % HO2 + O ->  OH + O2      
    rate.HO2_O3 = 1.00e-14*exp(-490./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.HO2.nd(step.doy).*variables.O3(timeind);                    % HO2 + O3 ->  OH + 2*O2       
    rate.H2O2_O = 1.40e-12*exp(-2000./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.H2O2.nd(step.doy).*variables.O(timeind);                    % H2O2 + O ->  OH + HO2    
    rate.CH3CN_OH = 7.80e-13*exp(-1050./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.CH3CN.nd(step.doy).*atmosphere.atLevel.OH.nd(step.doy);                  % CH3CN + OH ->  HO2       
    
    ko = 3e-13.*exp(460./atmosphere.atLevel.T(step.doy));
    kinf = 2.1e-33.*atmosphere.atLevel.M(step.doy).*...
        exp(920./atmosphere.atLevel.T(step.doy));
    fc = 1 + 1.4e-21.*atmosphere.atLevel.H2O.vmr(step.doy).*...
        exp(2200./atmosphere.atLevel.T(step.doy));
    
    rate.HO2_HO2 = (ko + kinf).*fc.*atmosphere.atLevel.HO2.nd(step.doy).^2;              % HO2 + HO2 ->  H2O2 + O2  
    
    rate.HO2NO2_OH = 1.30e-12*exp(380./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.HO2NO2.nd(step.doy).*atmosphere.atLevel.OH.nd(step.doy);                 % HO2NO2 + OH ->  H2O + NO2 + O2                               
                                               
    HO2NO2_KO = 2.1e-27.*exp(10135./atmosphere.atLevel.T(step.doy));
    rate.HO2NO2_M = kNO2HO2./HO2NO2_KO.*atmosphere.atLevel.HO2NO2.nd(step.doy);          % HO2NO2 + M ->  HO2 + NO2 + M      
    
    k0 = 4.28e-33;                                                      % HCN + OH + M ->  HO2 + M 
    ki = 9.30e-15*(300./atmosphere.atLevel.T(step.doy)).^-4.42;                             
    rate.HCN_OH_M = termolecular(k0,ki).*...
        atmosphere.atLevel.HCN.nd(step.doy).*atmosphere.atLevel.OH.nd(step.doy);
    
    k0=4.40e-32*(300./atmosphere.atLevel.T(step.doy)).^1.30;             % H + O2 + M ->  HO2 + M    
    ki = 7.50e-11*(300./atmosphere.atLevel.T(step.doy)).^-0.20;                             
    rate.H_O2_M = termolecular(k0,ki)...
        .*atmosphere.atLevel.H.nd(step.doy).*atmosphere.atLevel.O2.nd(timeind);
    
    k0 = 6.90e-31*(300./atmosphere.atLevel.T(step.doy)).^1.00;           % OH + OH + M ->  H2O2 + M 
    ki = 2.60e-11;      
    rate.OH_OH_M = termolecular(k0,ki)...
        .*atmosphere.atLevel.OH.nd(step.doy).^2;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLOx
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    
    rate.CL_O3 = 2.30e-11*exp(-200./atmosphere.atLevel.T(step.doy))...
         .*variables.CL(timeind).*variables.O3(timeind);          % CL + O3 ->  CLO + O2 %%% *1.015 is to make stable has no physical basisN                                         
    rate.CL_H2 = 3.05e-11*exp(-2270./atmosphere.atLevel.T(step.doy))...
        .*variables.CL(timeind).*atmosphere.atLevel.H2.nd(step.doy);         % CL + H2 ->  HCL + H                                          
    rate.CL_H2O2 = 1.10e-11*exp(-980./atmosphere.atLevel.T(step.doy))...
        .*variables.CL(timeind).*atmosphere.atLevel.H2O2.nd(step.doy);             % CL + H2O2 ->  HCL + HO2                                      
    rate.CL_HO2a = 1.40e-11*exp(270./atmosphere.atLevel.T(step.doy))...
        .*variables.CL(timeind).*atmosphere.atLevel.HO2.nd(step.doy);                % CL + HO2 ->  HCL + O2                                        
    rate.CL_HO2b = 3.60e-11*exp(-375./atmosphere.atLevel.T(step.doy))...
        .*variables.CL(timeind).*atmosphere.atLevel.HO2.nd(step.doy);                      % CL + HO2 ->  OH + CLO                                        
    rate.CL_CH2O = 8.10e-11*exp(-30./atmosphere.atLevel.T(step.doy))...
        .*variables.CL(timeind).*atmosphere.atLevel.CH2O.nd(timeind);                    % CL + CH2O ->  HCL + HO2 + CO                                 
    rate.CL_CH4 = 7.30e-12*exp(-1280./atmosphere.atLevel.T(step.doy))...
        .*variables.CL(timeind).*atmosphere.atLevel.CH4.nd(timeind);         % CL + CH4 ->  CH3O2 + HCL                                     
    rate.CLO_O = 2.80e-11*exp(85./atmosphere.atLevel.T(step.doy))...
        .*variables.CLO(timeind).*variables.O(timeind);            % CLO + O ->  CL + O2                                          
    rate.CLO_OHa = 7.40e-12*exp(270./atmosphere.atLevel.T(step.doy))...
        .*variables.CLO(timeind).*atmosphere.atLevel.OH.nd(step.doy);           % CLO + OH ->  CL + HO2                                        
    rate.CLO_OHb = 6.00e-13*exp(230./atmosphere.atLevel.T(step.doy))...
        .*variables.CLO(timeind).*atmosphere.atLevel.OH.nd(step.doy);           % CLO + OH ->  HCL + O2                                        
    rate.CLO_HO2 = 2.60e-12*exp(290./atmosphere.atLevel.T(step.doy))...
        .*variables.CLO(timeind).*atmosphere.atLevel.HO2.nd(step.doy);           % CLO + HO2 ->  O2 + HOCL                                      
    rate.CLO_CH3O2 = 3.30e-12*exp(-115./atmosphere.atLevel.T(step.doy))...
        .*variables.CL(timeind).*atmosphere.atLevel.CH3O2.nd(timeind);          % CLO + CH3O2 ->  CL + HO2 + CH2O                              
    rate.CLO_NO = 6.40e-12*exp(290./atmosphere.atLevel.T(step.doy))...
        .*variables.CLO(timeind).*variables.NO(timeind);           % CLO + NO ->  NO2 + CL                                        
    
    k0 = 1.80e-31*(300./atmosphere.atLevel.T(step.doy)).^3.40;          % CLO + NO2 + M ->  CLONO2 + M                                 
    ki = 1.50e-11*(300./atmosphere.atLevel.T(step.doy)).^1.90;  %                                                            
    kCLO_NO2_M = termolecular(k0,ki);
    rate.CLO_NO2_M = kCLO_NO2_M.*variables.CLO(timeind).*variables.NO2(timeind);
    
    rate.CLO_SO = 2.80e-11.*variables.CLO(timeind).*atmosphere.atLevel.SO.nd(step.doy); %CLO + SO -> SO2 + CL 
    
    rate.CLO_CLOa = 3.00e-11*exp(-2450./atmosphere.atLevel.T(step.doy))...
        .*variables.CLO(timeind).^2;         % CLO + CLO ->  2*CL + O2                                      
    rate.CLO_CLOb = 1.00e-12*exp(-1590./atmosphere.atLevel.T(step.doy))...
        .*variables.CLO(timeind).^2;         % CLO + CLO ->  CL2 + O2                                       
    rate.CLO_CLOc = 3.50e-13*exp(-1370./atmosphere.atLevel.T(step.doy))...
        .*variables.CLO(timeind).^2;         % CLO + CLO ->  CL + OCLO                                      
    
    k0 = 1.60e-32*(300./atmosphere.atLevel.T(step.doy)).^4.50;          % CLO + CLO + M ->  CL2O2 + M                                  
    ki = 3.00e-12*(300./atmosphere.atLevel.T(step.doy)).^2.00;  %                                                         
    rate.CLO_CLO_M = termolecular(k0,ki).*variables.CLO(timeind).^2;
    
    CL2O2_KO = 2.16e-27.*exp(8537./atmosphere.atLevel.T(step.doy));
    rate.CL2O2_M = kCLO_NO2_M./CL2O2_KO.*variables.CL2O2(timeind);                                 % CL2O2 + M ->  CLO + CLO + M                                  
    
    rate.HCL_OH = 1.80e-12*exp(-250./atmosphere.atLevel.T(step.doy))...
        .*variables.HCL(timeind).*atmosphere.atLevel.OH.nd(step.doy);          % HCL + OH ->  H2O + CL                                        
    rate.HCL_O = 1.00e-11*exp(-3300./atmosphere.atLevel.T(step.doy))...
        .*variables.HCL(timeind).*variables.O(timeind);         % HCL + O ->  CL + OH                                          
    rate.HCL_O1D = 1.5e-10.*variables.HCL(timeind).*O1D;                    % HCL + O1D -> CL + OH
    rate.HOCL_O = 1.70e-13.*variables.HOCL(timeind).*variables.O(timeind);                                                    % HOCL + O ->  CLO + OH                                        
    rate.HOCL_CL = 3.40e-12*exp(-130./atmosphere.atLevel.T(step.doy))...
        .*variables.HOCL(timeind).*variables.CL(timeind);          % HOCL + CL ->  HCL + CLO                                      
    rate.HOCL_OH = 3.00e-12*exp(-500./atmosphere.atLevel.T(step.doy))...
        .*variables.HOCL(timeind).*atmosphere.atLevel.OH.nd(step.doy);          % HOCL + OH ->  H2O + CLO                                      
    rate.CLONO2_O = 3.60e-12*exp(-840./atmosphere.atLevel.T(step.doy))...
        .*variables.CLONO2(timeind).*variables.O(timeind);          % CLONO2 + O ->  CLO + NO3                                     
    rate.CLONO2_OH = 1.20e-12*exp(-330./atmosphere.atLevel.T(step.doy))...
        .*variables.CLONO2(timeind).*atmosphere.atLevel.OH.nd(step.doy);          % CLONO2 + OH ->  HOCL + NO3                                   
    rate.CLONO2_CL = 6.50e-12*exp(135./atmosphere.atLevel.T(step.doy))...
        .*variables.CLONO2(timeind).*variables.CL(timeind);% CLONO2 + CL ->  CL2 + NO3


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UNSORTED
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
              
    
                                        
    rate.BR_O3 = 1.60e-11*exp(-780./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.BR.nd(step.doy).*variables.O3(timeind);                     % BR + O3 ->  BRO + O2                                         
    rate.BR_HO2 = 4.80e-12*exp(-310./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.BR.nd(step.doy).*atmosphere.atLevel.HO2.nd(step.doy);% BR + HO2 ->  HBR + O2                                        
    rate.BR_CH2O = 1.70e-11*exp(-800./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.BR.nd(step.doy).*atmosphere.atLevel.CH2O.nd(timeind);% BR + CH2O ->  HBR + HO2 + CO                                 
    rate.BRO_O = 1.90e-11*exp(230./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.BRO.nd(step.doy).*variables.O(timeind);% BRO + O ->  BR + O2                                          
    rate.BRO_OH = 1.70e-11*exp(250./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.BRO.nd(step.doy).*atmosphere.atLevel.OH.nd(step.doy);% BRO + OH ->  BR + HO2                                        
    rate.BRO_HO2 = 4.50e-12*exp(460./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.BRO.nd(step.doy).*atmosphere.atLevel.HO2.nd(step.doy);% BRO + HO2 ->  HOBR + O2                                      
    rate.BRO_NO = 8.80e-12*exp(260./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.BRO.nd(step.doy).*variables.NO(timeind);           % BRO + NO ->  BR + NO2                                        
    
    k0=5.20e-31*(300./atmosphere.atLevel.T(step.doy)).^3.20;            % BRO + NO2 + M ->  BRONO2 + M                                 
    ki=6.90e-12*(300./atmosphere.atLevel.T(step.doy)).^2.90;  %                                                         
    rate.BRO_NO2_M = termolecular(k0,ki)...
        .*atmosphere.atLevel.BRO.nd(step.doy).*variables.NO2(timeind);
    
    rate.BRO_CLOa = 9.50e-13*exp(550./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.BRO.nd(step.doy).*variables.CLO(timeind);% BRO + CLO ->  BR + OCLO                                      
    rate.BRO_CLOb = 2.30e-12*exp(260./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.BRO.nd(step.doy).*variables.CLO(timeind); % BRO + CLO ->  BR + CL + O2                                   
    rate.BRO_CLOc = 4.10e-13*exp(290./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.BRO.nd(step.doy).*variables.CLO(timeind); % BRO + CLO ->  BRCL + O2                                      
    rate.BRO_BRO = 1.50e-12*exp(230./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.BRO.nd(step.doy).*atmosphere.atLevel.BRO.nd(step.doy);           % BRO + BRO ->  2*BR + O2                                      
    rate.HBR_OH = 5.50e-12*exp(200./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.HBR.nd(step.doy).*atmosphere.atLevel.OH.nd(step.doy);           % HBR + OH ->  BR + H2O                                        
    rate.HBR_O = 5.80e-12*exp(-1500./atmosphere.atLevel.T(step.doy))...
    .*atmosphere.atLevel.HBR.nd(step.doy).*variables.O(timeind);         % HBR + O ->  BR + OH                                          
    rate.HOBR_O = 1.20e-10*exp(-430./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.HOBR.nd(timeind).*variables.O(timeind);          % HOBR + O ->  BRO + OH                                        
    rate.BRONO2_O = 1.90e-11*exp(215./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.BRONO2.nd(step.doy).*variables.O(timeind);% BRONO2 + O ->  BRO + NO3                                     
    rate.CH3CL_CL = 2.17e-11*exp(-1130./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.CH3CL.nd(step.doy).*variables.CL(timeind);% CH3CL + CL ->  HO2 + CO + 2*HCL                              
    rate.CH3CL_OH = 2.40e-12*exp(-1250./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.CH3CL.nd(step.doy).*atmosphere.atLevel.OH.nd(step.doy);         % CH3CL + OH ->  CL + H2O + HO2                                
    rate.CH3BR_CL = 1.40e-11*exp(-1030./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.CH3BR.nd(step.doy).*variables.CL(timeind);         % CH3BR + CL ->  HCL + HO2 + BR        
    rate.CH2BR2_CL = 6.30e-12*exp(-800./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.CH2BR2.nd(step.doy).*variables.CL(timeind); % CH2BR2 + CL ->  2*BR + HCL     
    rate.CHBR3_CL = 4.85e-12*exp(-850./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.CHBR3.nd(step.doy).*variables.CL(timeind);          % CHBR3 + CL ->  3*BR + HCL 
    rate.C2H6_CL = 7.20e-11*exp(-70./atmosphere.atLevel.T(step.doy))...
        .*atmosphere.atLevel.C2H6.nd(step.doy).*variables.CL(timeind); % C2H6 + CL ->  HCL + C2H5O2  
    rate.CH3CCL3_OH = 1.64e-12*exp(-1520./atmosphere.atLevel.T(step.doy))...
         .*atmosphere.atLevel.CH3CCL3.nd(step.doy).*atmosphere.atLevel.OH.nd(step.doy);         % CH3CCL3 + OH ->  H2O + 3*CL                                  
%     rate(93) = 1.05e-12*exp(-1600./atmosphere.atLevel.T(step.doy));         % HCFC22 + OH ->  H2O + CL                                     
%     rate(94) = 2.35e-12*exp(-1300./atmosphere.atLevel.T(step.doy));         % CH3BR + OH ->  BR + H2O + HO2                                

%     rate(96) = 1.25e-12*exp(-1600./atmosphere.atLevel.T(step.doy));         % HCFC141B + OH ->  2*CL                                       
%     rate(97) = 1.30e-12*exp(-1770./atmosphere.atLevel.T(step.doy));         % HCFC142B + OH ->  CL                                         
%     rate(98) = 2.00e-12*exp(-840./atmosphere.atLevel.T(step.doy));          % CH2BR2 + OH ->  2*BR + H2O                                   
%     rate(99) = 1.35e-12*exp(-600./atmosphere.atLevel.T(step.doy));          % CHBR3 + OH ->  3*BR                                          

%     rate(101) = 4.85e-12*exp(-850./atmosphere.atLevel.T(step.doy));          % CHBR3 + CL ->  3*BR + HCL                                    
%     rate(102) = 2.45e-12*exp(-1775./atmosphere.atLevel.T(step.doy));         % CH4 + OH ->  CH3O2 + H2O                                     
%     %rate(103) = .^ User defined .^                                          % CO + OH ->  CO2 + H                                          
%     
%     k0 = 5.90e-33*(300./atmosphere.atLevel.T(step.doy)).^1.40;          % CO + OH + M ->  CO2 + HO2 + M                                
%     ki=1.10e-12*(300./atmosphere.atLevel.T(step.doy)).^-1.30; %                                                         
%     rate(104) = termolecular(k0,ki);
%     
%     rate(105) = 6.00e-13*exp(-2058./atmosphere.atLevel.T(step.doy));         % CH2O + NO3 ->  CO + HO2 + HNO3                               
%     rate(106) = 5.50e-12*exp(125./atmosphere.atLevel.T(step.doy));           % CH2O + OH ->  CO + H2O + H                                   
%     rate(107) = 3.40e-11*exp(-1600./atmosphere.atLevel.T(step.doy));         % CH2O + O ->  HO2 + OH + CO                                   
%     rate(108) = 9.70e-15*exp(625./atmosphere.atLevel.T(step.doy));           % CH2O + HO2 ->  HOCH2OO                                       
%     rate(109) = 2.80e-12*exp(300./atmosphere.atLevel.T(step.doy));           % CH3O2 + NO ->  CH2O + NO2 + HO2                              
%     rate(110) = 4.10e-13*exp(750./atmosphere.atLevel.T(step.doy));           % CH3O2 + HO2 ->  CH3OOH + O2                                  
%     rate(111) = 5.00e-13*exp(-424./atmosphere.atLevel.T(step.doy));          % CH3O2 + CH3O2 ->  2*CH2O + 2*HO2                             
%     rate(112) = 1.90e-14*exp(706./atmosphere.atLevel.T(step.doy));           % CH3O2 + CH3O2 ->  CH2O + CH3OH                               
%     rate(113) = 2.90e-12*exp(-345./atmosphere.atLevel.T(step.doy));          % CH3OH + OH ->  HO2 + CH2O                                    
%     rate(114) = 3.80e-12*exp(200./atmosphere.atLevel.T(step.doy));           % CH3OOH + OH ->  .7*CH3O2 + .3*OH + .3*CH2O + H2O             
%     rate(115) = 4.50e-13;                                                    % HCOOH + OH ->  HO2 + CO2 + H2O                               
%     rate(116) = 2.40E+12*exp(-7000./atmosphere.atLevel.T(step.doy));         % HOCH2OO ->  CH2O + HO2                                       
%     rate(117) = 2.60e-12*exp(265./atmosphere.atLevel.T(step.doy));           % HOCH2OO + NO ->  HCOOH + NO2 + HO2                           
%     rate(118) = 7.50e-13*exp(700./atmosphere.atLevel.T(step.doy));           % HOCH2OO + HO2 ->  HCOOH                                      
%     rate(119) = 7.20e-11*exp(-70./atmosphere.atLevel.T(step.doy));           % C2H6 + CL ->  HCL + C2H5O2                                   
%     rate(120) = 7.66e-12*exp(-1020./atmosphere.atLevel.T(step.doy));         % C2H6 + OH ->  C2H5O2 + H2O                                   
%     
%     k0 = 5.50e-30;                                                      % C2H2 + OH + M ->  .65*GLYOXAL + .65*OH + .35*HCOOH + .35*HO2 + .35*CO + M  
%     ki = 8.30e-13*(300./atmosphere.atLevel.T(step.doy)).^-2.00;         %                                           
%     rate(121) = termolecular(k0,ki);
%     
%     k0 = 8.60e-29*(300./atmosphere.atLevel.T(step.doy)).^3.10;          % C2H4 + OH + M ->  EO2 + M                                    
%     ki = 9.00e-12*(300./atmosphere.atLevel.T(step.doy)).^0.85;                                                                                                                             
%     rate(122) = termolecular(k0,ki);
    
    function kout = termolecular(k0,ki)                
        x = .6;
        xpo = k0.*atmosphere.atLevel.M(step.doy)./ki;
        rate1 = k0.*atmosphere.atLevel.M(step.doy)./(1+xpo);
        xpo = log10(xpo);
        xpo = 1./(1+xpo.^2);
        kout = rate1.*x.^xpo;                     
    end


end