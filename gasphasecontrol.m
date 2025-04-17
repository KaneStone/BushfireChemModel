function [rates,kv] = gasphasecontrol(inputs,step,variables,atmosphere,rates,k,kv)

    
    % calculate all the rates here first

    kv.N2_O1D = k.N2_O1D.*variables.O1D.*atmosphere.dummyN2(step.doy);
    kv.O2_O1D = k.O2_O1D.*variables.O1D.*atmosphere.dummyO2(step.doy);
    kv.OH_OH = k.OH_OH.*variables.OH.^2;
    kv.O_O2_M = k.O_O2_M.*variables.O.*atmosphere.dummyO2(step.doy);
    kv.O3_O = k.O3_O.*variables.O.*variables.O3;
    kv.O_O_M = k.O_O_M.*variables.O.^2;
    kv.HO2_O = k.HO2_O.*variables.O.*variables.HO2;
    kv.NO_O_M = k.NO_O_M.*variables.O.*variables.NO;
    kv.NO2_O = k.NO2_O.*variables.O.*variables.NO2;
    kv.NO2_O_M = k.NO2_O_M.*variables.O.*variables.NO2;
    kv.NO3_O = k.NO3_O.*variables.O.*variables.NO3;
    kv.CLO_O = k.CLO_O.*variables.O.*variables.CLO;
    kv.HOBR_O = k.HOBR_O.*variables.O.*variables.HOBR;
    kv.HOCL_O = k.HOCL_O.*variables.O.*variables.HOCL;
    kv.CLONO2_O = k.CLONO2_O.*variables.O.*variables.CLONO2;
    kv.BRO_O = k.BRO_O.*variables.O.*variables.BRO;
    kv.BRONO2_O = k.BRONO2_O.*variables.O.*variables.BRONO2;
    kv.OH_O = k.OH_O.*variables.O.*variables.OH;

    kv.H2O_O1D = k.H2O_O1D.*variables.O1D.*atmosphere.dummyH2O(step.doy);
    kv.O1D_N2Oa = k.O1D_N2Oa.*variables.O1D.*atmosphere.dummyN2O(step.doy);
    kv.O1D_N2Ob = k.O1D_N2Ob.*variables.O1D.*atmosphere.dummyN2O(step.doy);
    kv.HCL_O1D = k.HCL_O1D.*variables.O1D.*variables.HCL;
    kv.O1D_O3 = k.O1D_O3.*variables.O1D.*variables.O3;

    kv.H_O3 = k.H_O3.*variables.O3.*atmosphere.dummyH(step.doy);
    kv.OH_O3 = k.OH_O3.*variables.O3.*variables.OH;
    kv.HO2_O3 = k.HO2_O3.*variables.O3.*variables.HO2;
    kv.NO_O3 = k.NO_O3.*variables.O3.*variables.NO;
    kv.NO2_O3 = k.NO2_O3.*variables.O3.*variables.NO2;
    kv.CL_O3 = k.CL_O3.*variables.O3.*variables.CL;
    kv.BR_O3 = k.BR_O3.*variables.O3.*variables.BR;

    kv.CLO_NO2_M = k.CLO_NO2_M.*variables.CLO.*variables.NO2;

    kv.CLONO2_OH = k.CLONO2_OH.*variables.CLONO2.*variables.OH;
    kv.CLONO2_CL  = k.CLONO2_CL.*variables.CLONO2.*variables.CL;    

    kv.CL_H2 = k.CL_H2.*variables.CL.*atmosphere.dummyH2(step.doy);
    kv.CL_H2O2 = k.CL_H2O2.*variables.CL.*variables.H2O2;
    kv.CL_HO2a = k.CL_HO2a.*variables.CL.*variables.HO2;
    kv.CL_HO2b = k.CL_HO2b.*variables.CL.*variables.HO2;
    
    kv.CL_CH4 = k.CL_CH4.*variables.CL.*atmosphere.dummyCH4(step.doy);    
    kv.CLO_OHb = k.CLO_OHb.*variables.CLO.*variables.OH;
    kv.CLO_OHa = k.CLO_OHa.*variables.CLO.*variables.OH;
    kv.HOCL_CL = k.HOCL_CL.*variables.CL.*variables.HOCL;
    kv.HOCL_HOCL = k.HOCL_HOCL.*variables.HOCL.*variables.HOCL;

    kv.HCL_OH = k.HCL_OH.*variables.HCL.*variables.OH;
    kv.HCL_O = k.HCL_O.*variables.HCL.*variables.O;

    kv.HOCL_OH = k.HOCL_OH.*variables.HOCL.*variables.OH;
    kv.CL2O2_M = k.CL2O2_M.*variables.CL2O2;
    kv.BR_OCLO = k.BR_OCLO.*variables.BR.*variables.OCLO;

    kv.CLO_CLO_M = k.CLO_CLO_M.*variables.CLO.^2;

    kv.CLO_HO2 = k.CLO_HO2.*variables.CLO.*variables.HO2;
    kv.CLO_NO = k.CLO_NO.*variables.CLO.*variables.NO;
    kv.CLO_CLOa = k.CLO_CLOa.*variables.CLO.^2;
    kv.CLO_CLOb = k.CLO_CLOb.*variables.CLO.^2;
    kv.CLO_CLOc = k.CLO_CLOc.*variables.CLO.^2;
    kv.BRO_CLOa = k.BRO_CLOa.*variables.CLO.*variables.BRO;
    kv.BRO_CLOb = k.BRO_CLOb.*variables.CLO.*variables.BRO;
    kv.BRO_CLOc = k.BRO_CLOc.*variables.CLO.*variables.BRO;
    

    kv.BRO_OH = k.BRO_OH.*variables.BRO.*variables.OH;
    kv.BRO_HO2 = k.BRO_HO2.*variables.BRO.*variables.HO2;
    kv.BRO_NO = k.BRO_NO.*variables.BRO.*variables.NO;
    kv.BRO_NO2_M = k.BRO_NO2_M.*variables.BRO.*variables.NO2;
    kv.BRO_BRO = k.BRO_BRO.*variables.BRO.^2;

    kv.BR_HO2 = k.BR_HO2.*variables.BR.*variables.HO2;
    kv.HBR_OH = k.HBR_OH.*variables.HBR.*variables.OH;
    %kv.HBR_O1D = k.HBR_O1D.*variables.HBR.*variables.O1D;

    kv.N2O5_M = k.N2O5_M.*variables.N2O5;
    kv.HO2NO2_M = k.HO2NO2_M.*variables.HO2NO2;
    kv.NO_HO2 = k.NO_HO2.*variables.NO.*variables.HO2;
    kv.NO3_NO = k.NO3_NO.*variables.NO3.*variables.NO;
    kv.NO3_OH = k.NO3_OH.*variables.NO3.*variables.OH;
    kv.NO3_HO2 = k.NO3_HO2.*variables.NO3.*variables.HO2;
    kv.HO2NO2_OH = k.HO2NO2_OH.*variables.OH.*variables.HO2NO2;
    

    kv.NO2_NO3_M = k.NO2_NO3_M.*variables.NO2.*variables.NO3;
    kv.NO2_HO2_M = k.NO2_HO2_M.*variables.NO2.*variables.HO2;
    kv.NO2_OH_M = k.NO2_OH_M.*variables.NO2.*variables.OH;
    kv.HNO3_OH = k.HNO3_OH.*variables.HNO3.*variables.OH;
    

    kv.OH_HO2 = k.OH_HO2.*variables.OH.*variables.HO2;
    kv.OH_H2 = k.OH_H2.*variables.OH.*atmosphere.dummyH2(step.doy);
    kv.OH_H2O2 = k.OH_H2O2.*variables.OH.*variables.H2O2;
    kv.OH_OH_M = k.OH_OH_M.*variables.OH.^2;    
    kv.CH4_OH = k.CH4_OH.*variables.OH.*atmosphere.dummyCH4(step.doy);
    
    kv.OH_CO_Ma = k.OH_CO_Ma.*variables.OH.*atmosphere.dummyCO(step.doy);
    kv.OH_CO_Mb = k.OH_CO_Mb.*variables.OH.*atmosphere.dummyCO(step.doy);

    kv.H2_O1D = k.H2_O1D.*variables.O1D.*atmosphere.dummyH2(step.doy);    
    kv.CH4_O1Da = k.CH4_O1Da.*variables.O1D.*atmosphere.dummyCH4(step.doy);        
    kv.CH4_O1Db = k.CH4_O1Db.*variables.O1D.*atmosphere.dummyCH4(step.doy);    
    kv.CH4_O1Dc = k.CH4_O1Dc.*variables.O1D.*atmosphere.dummyCH4(step.doy);
    kv.H2O2_O = k.H2O2_O.*variables.H2O2.*variables.O;
    kv.HO2_HO2 = k.HO2_HO2.*variables.HO2.^2;    

    kv.H_O2_M = k.H_O2_M.*atmosphere.dummyH(step.doy).*atmosphere.dummyO2(step.doy); %no way this is important in lower stratopshere

    %% put aditional modules here
    
    % additions of CH2O, CH3O2...
    if inputs.methanechemistry
              
        kv.CH3O2_CH3O2a = k.CH3O2_CH3O2a.*variables.CH3O2.^2;
        kv.CH3O2_CH3O2b = k.CH3O2_CH3O2b.*variables.CH3O2.^2;        
        kv.CH3OH_OH = k.CH3OH_OH.*variables.CH3OH.*variables.OH;   
        kv.CH3OOH_OH = k.CH3OOH_OH.*variables.CH3OOH.*variables.OH;    
        kv.CLO_CH3O2 = k.CLO_CH3O2.*variables.CLO.*variables.CH3O2;
        kv.CH3O2_NO = k.CH3O2_NO.*variables.NO.*variables.CH3O2;
        
        kv.CH2O_O = k.CH2O_O.*variables.CH2O.*variables.O;           
        kv.CL_CH2O = k.CL_CH2O.*variables.CL.*variables.CH2O;
        kv.BR_CH2O = k.BR_CH2O.*variables.BR.*variables.CH2O;
        kv.NO3_CH2O = k.NO3_CH2O.*variables.NO3.*variables.CH2O;
        kv.OH_CH2O = k.OH_CH2O.*variables.OH.*variables.CH2O;
        kv.HO2_CH2O = k.HO2_CH2O.*variables.HO2.*variables.CH2O;
        
        kv.CH3O2_HO2 = k.CH3O2_HO2.*variables.CH3O2.*variables.HO2;
    else
        kv.CL_CH2O = k.CL_CH2O.*variables.CL.*atmosphere.dummyCH2O(step.doy);
        kv.BR_CH2O = k.BR_CH2O.*variables.BR.*atmosphere.dummyCH2O(step.doy);
        kv.NO3_CH2O = k.NO3_CH2O.*variables.NO3.*atmosphere.dummyCH2O(step.doy);
        kv.OH_CH2O = k.OH_CH2O.*variables.OH.*atmosphere.dummyCH2O(step.doy);
        kv.HO2_CH2O = k.HO2_CH2O.*variables.HO2.*atmosphere.dummyCH2O(step.doy);        
        kv.CLO_CH3O2 = k.CLO_CH3O2.*variables.CLO.*atmosphere.dummyCH3O2(step.doy);
        kv.CH3O2_NO = k.CH3O2_NO.*variables.NO.*atmosphere.dummyCH3O2(step.doy);        
    end
    
    %% Begin gas phase continuity

    %% O3P

    rates.O.production(end+1) = kv.N2_O1D;
    rates.O.production(end+1) = kv.O2_O1D;
    rates.O.production(end+1) = kv.OH_OH;

    rates.O.destruction(1) = kv.O_O2_M;
    rates.O.destruction(2) = kv.O3_O;
    rates.O.destruction(3) = kv.O_O_M.*2;
    rates.O.destruction(4) = kv.HO2_O;
    rates.O.destruction(5) = kv.NO_O_M;
    rates.O.destruction(6) = kv.NO2_O;
    rates.O.destruction(7) = kv.NO2_O_M;
    rates.O.destruction(8) = kv.NO3_O;
    rates.O.destruction(9) = kv.CLO_O;
    rates.O.destruction(10) = kv.HOBR_O;
    rates.O.destruction(11) = kv.HOCL_O;
    rates.O.destruction(12) = kv.CLONO2_O;
    rates.O.destruction(13) = kv.BRO_O;
    rates.O.destruction(14) = kv.BRONO2_O;
    rates.O.destruction(15) = kv.OH_O;
    %rates.O.destruction(16) = kv.CH2O_O;

    %% O1D

    rates.O1D.destruction(1) = kv.N2_O1D;
    rates.O1D.destruction(end+1) = kv.O2_O1D;
    rates.O1D.destruction(end+1) = kv.H2O_O1D;
    rates.O1D.destruction(end+1) = kv.O1D_N2Oa;
    rates.O1D.destruction(end+1) = kv.O1D_N2Ob;
    rates.O1D.destruction(end+1) = kv.HCL_O1D;
    rates.O1D.destruction(end+1) = kv.O1D_O3;
    %rates.O1D.destruction(8) = kv.HBR_O1D;
    rates.O1D.destruction(end+1) = kv.H2_O1D;
    rates.O1D.destruction(end+1) = kv.CH4_O1Da;
    rates.O1D.destruction(end+1) = kv.CH4_O1Db;
    rates.O1D.destruction(end+1) = kv.CH4_O1Dc;

    %% O3 RATES

    %production
    rates.O3.production(1) = kv.O_O2_M;

    %destruction
    rates.O3.destruction(end+1) = kv.O1D_O3;
    rates.O3.destruction(end+1) = kv.O3_O;
    rates.O3.destruction(end+1) = kv.H_O3;
    rates.O3.destruction(end+1) = kv.OH_O3;
    rates.O3.destruction(end+1) = kv.HO2_O3;
    rates.O3.destruction(end+1) = kv.NO_O3;
    rates.O3.destruction(end+1) = kv.NO2_O3;
    rates.O3.destruction(end+1) = kv.CL_O3;
    rates.O3.destruction(end+1) = kv.BR_O3;

    %% CLONO2

    %production
    rates.CLONO2.production(1) = kv.CLO_NO2_M;

    %destruction
    rates.CLONO2.destruction(end+1) = kv.CLONO2_O;
    rates.CLONO2.destruction(end+1) = kv.CLONO2_OH;
    rates.CLONO2.destruction(end+1) = kv.CLONO2_CL;

    %% HCL

    %production
    rates.HCL.production(1) = kv.CL_H2;
    rates.HCL.production(2) = kv.CL_H2O2;
    rates.HCL.production(3) = kv.CL_HO2a;
    rates.HCL.production(4) = kv.CL_CH2O;
    rates.HCL.production(5) = kv.CL_CH4;
    rates.HCL.production(6) = kv.CLO_OHb;
    rates.HCL.production(7) = kv.HOCL_CL;

    %destruction
    rates.HCL.destruction(end+1) = kv.HCL_O1D;
    rates.HCL.destruction(end+1) = kv.HCL_OH;
    rates.HCL.destruction(end+1) = kv.HCL_O;

    %% CLO

    rates.CLO.production(end+1) = kv.CL_O3;
    rates.CLO.production(end+1) = kv.CL_HO2b;
    rates.CLO.production(end+1) = kv.HOCL_O;
    rates.CLO.production(end+1) = kv.HOCL_OH;
    rates.CLO.production(end+1) = kv.HOCL_CL;
    rates.CLO.production(end+1) = kv.CLONO2_O;
    rates.CLO.production(end+1) = kv.CL2O2_M.*2;
    rates.CLO.production(end+1) = kv.BR_OCLO;
    rates.CLO.production(end+1) = kv.HOCL_HOCL;

    rates.CLO.destruction(end+1) = kv.CLO_CLO_M.*2;
    rates.CLO.destruction(end+1) = kv.CLO_NO2_M;
    rates.CLO.destruction(end+1) = kv.CLO_O;
    rates.CLO.destruction(end+1) = kv.CLO_OHa;
    rates.CLO.destruction(end+1) = kv.CLO_OHb;
    rates.CLO.destruction(end+1) = kv.CLO_HO2;
    rates.CLO.destruction(end+1) = kv.CLO_NO;
    rates.CLO.destruction(end+1) = kv.CLO_CLOa*2;
    rates.CLO.destruction(end+1) = kv.CLO_CLOb*2;
    rates.CLO.destruction(end+1) = kv.CLO_CLOc*2;
    rates.CLO.destruction(end+1) = kv.BRO_CLOa;
    rates.CLO.destruction(end+1) = kv.BRO_CLOb;
    rates.CLO.destruction(end+1) = kv.BRO_CLOc;
    rates.CLO.destruction(end+1) = kv.CLO_CH3O2;


    %% CL2
    rates.CL2.production(1) = kv.CLO_CLOb;
    rates.CL2.production(2) = kv.CLONO2_CL;

    %% CL

    rates.CL.production(end+1) = kv.CLO_O;
    rates.CL.production(end+1) = kv.CLO_OHa;
    rates.CL.production(end+1) = kv.CLO_NO;
    rates.CL.production(end+1) = kv.HCL_OH;
    rates.CL.production(end+1) = kv.BRO_CLOb;
    rates.CL.production(end+1) = kv.CLO_CLOa.*2;
    rates.CL.production(end+1) = kv.CLO_CLOc;
    rates.CL.production(end+1) = kv.CLO_CH3O2;
    rates.CL.production(end+1) = kv.HCL_O1D;
    rates.CL.production(end+1) = kv.HCL_O;
    % testing
    rates.CL.production(end+1) = kv.HOCL_HOCL;

    rates.CL.destruction(1) = kv.CL_O3;
    rates.CL.destruction(2) = kv.CL_H2;
    rates.CL.destruction(3) = kv.CL_H2O2;
    rates.CL.destruction(4) = kv.CL_HO2a;
    rates.CL.destruction(5) = kv.CL_HO2b; 
    rates.CL.destruction(6) = kv.CL_CH2O;
    rates.CL.destruction(7) = kv.CL_CH4;
    rates.CL.destruction(8) = kv.HOCL_CL;
    rates.CL.destruction(9) = kv.CLONO2_CL;

    %% OCLO
    rates.OCLO.destruction(end+1) = kv.BR_OCLO;

    rates.OCLO.production(1) = kv.CLO_CLOc;
    rates.OCLO.production(2) = kv.BRO_CLOa;

    %% BRCL
    rates.BRCL.production(1) = kv.BRO_CLOc;

    %% CL2O2 

    %production
    rates.CL2O2.production(1) = kv.CLO_CLO_M;

    %destruction
    rates.CL2O2.destruction(end+1) = kv.CL2O2_M;

    %% HOCL

    rates.HOCL.production(1) = kv.CLO_HO2;
    rates.HOCL.production(2) = kv.CLONO2_OH;

    rates.HOCL.destruction(end+1) = kv.HOCL_O;
    rates.HOCL.destruction(end+1) = kv.HOCL_CL;
    rates.HOCL.destruction(end+1) = kv.HOCL_OH;
    % testing
    rates.HOCL.destruction(end+1) = kv.HOCL_HOCL.*2;

    %% BRO

    rates.BRO.production(end+1) = kv.BR_O3;
    rates.BRO.production(end+1) = kv.HOBR_O;
    rates.BRO.production(end+1) = kv.BRONO2_O;
    rates.BRO.production(end+1) = kv.BR_OCLO;

    rates.BRO.destruction(end+1) =  kv.BRO_O;
    rates.BRO.destruction(end+1) =  kv.BRO_OH;
    rates.BRO.destruction(end+1) =  kv.BRO_HO2;
    rates.BRO.destruction(end+1) =  kv.BRO_NO;
    rates.BRO.destruction(end+1) =  kv.BRO_NO2_M;
    rates.BRO.destruction(end+1) =  kv.BRO_CLOa;
    rates.BRO.destruction(end+1) =  kv.BRO_CLOb;
    rates.BRO.destruction(end+1) =  kv.BRO_CLOc;
    rates.BRO.destruction(end+1) =  kv.BRO_BRO.*2;

    %% HOBR

    rates.HOBR.production(1) = kv.BRO_HO2;

    rates.HOBR.destruction(end+1) =  kv.HOBR_O;

    %% HBR

    rates.HBR.production(1) = kv.BR_HO2;
    rates.HBR.production(2) = kv.BR_CH2O;

    rates.HBR.destruction(1) =  kv.HBR_OH;

    %% BRONO2

    rates.BRONO2.production(1) = kv.BRO_NO2_M;

    rates.BRONO2.destruction(end+1) = kv.BRONO2_O;

    %% BR

    rates.BR.production(end+1) = kv.BRO_O;
    rates.BR.production(end+1) = kv.BRO_OH;
    rates.BR.production(end+1) = kv.BRO_NO;
    rates.BR.production(end+1) = kv.BRO_CLOa;
    rates.BR.production(end+1) = kv.BRO_CLOb;
    rates.BR.production(end+1) = kv.BRO_BRO.*2;
    rates.BR.production(end+1) = kv.HBR_OH;

    rates.BR.destruction(1) = kv.BR_O3;
    rates.BR.destruction(2) = kv.BR_HO2;
    rates.BR.destruction(3) = kv.BR_CH2O;
    rates.BR.destruction(4) = kv.BR_OCLO;

    %% NO2     

    rates.NO2.production(end+1) = kv.N2O5_M; 
    rates.NO2.production(end+1) = kv.HO2NO2_M; 
    rates.NO2.production(end+1) = kv.NO_O_M; 
    rates.NO2.production(end+1) = kv.NO_HO2; 
    rates.NO2.production(end+1) = kv.NO_O3; 
    rates.NO2.production(end+1) = kv.NO3_NO.*2;
    rates.NO2.production(end+1) = kv.NO3_O; 
    rates.NO2.production(end+1) = kv.NO3_OH;
    rates.NO2.production(end+1) = kv.NO3_HO2;
    rates.NO2.production(end+1) = kv.HO2NO2_OH;
    rates.NO2.production(end+1) = kv.CLO_NO;
    rates.NO2.production(end+1) = kv.BRO_NO;
    rates.NO2.production(end+1) = kv.CH3O2_NO;

    rates.NO2.destruction(end+1) = kv.NO2_O;
    rates.NO2.destruction(end+1) = kv.NO2_O_M;
    rates.NO2.destruction(end+1) = kv.NO2_O3;
    rates.NO2.destruction(end+1) = kv.NO2_NO3_M;
    rates.NO2.destruction(end+1) = kv.NO2_HO2_M;
    rates.NO2.destruction(end+1) = kv.CLO_NO2_M;
    rates.NO2.destruction(end+1) = kv.BRO_NO2_M;
    rates.NO2.destruction(end+1) = kv.NO2_OH_M;

    %% NO

    rates.NO.production(end+1) = kv.NO2_O;
    %rates.NO.production(end+1) = kv.O1D_N2Oa.*2; % removed this to keep NOy continuity

    rates.NO.destruction(1) = kv.NO_O_M;
    rates.NO.destruction(end+1) = kv.NO_HO2;
    rates.NO.destruction(end+1) = kv.NO_O3;
    rates.NO.destruction(end+1) = kv.NO3_NO;
    rates.NO.destruction(end+1) = kv.CLO_NO;
    rates.NO.destruction(end+1) = kv.BRO_NO;
    rates.NO.destruction(end+1) = kv.CH3O2_NO;

    %% NO3

    rates.NO3.production(end+1) = kv.N2O5_M;
    rates.NO3.production(end+1) = kv.NO2_O_M;
    rates.NO3.production(end+1) = kv.NO2_O3;
    rates.NO3.production(end+1) = kv.HNO3_OH;
    rates.NO3.production(end+1) = kv.CLONO2_O;
    rates.NO3.production(end+1) = kv.CLONO2_OH;
    rates.NO3.production(end+1) = kv.CLONO2_CL;
    rates.NO3.production(end+1) = kv.BRONO2_O;

    rates.NO3.destruction(end+1) = kv.NO2_NO3_M;
    rates.NO3.destruction(end+1) = kv.NO3_NO;
    rates.NO3.destruction(end+1) = kv.NO3_O;
    rates.NO3.destruction(end+1) = kv.NO3_OH;
    rates.NO3.destruction(end+1) = kv.NO3_HO2;
    rates.NO3.destruction(end+1) = kv.NO3_CH2O;

    %% N2O5

    rates.N2O5.production(1) = kv.NO2_NO3_M;

    rates.N2O5.destruction(end+1) = kv.N2O5_M;

    %% HNO3

    rates.HNO3.destruction(end+1) = kv.HNO3_OH;

    rates.HNO3.production(1) = kv.NO2_OH_M;
    rates.HNO3.production(2) = kv.NO3_CH2O;

    %% HO2NO2

    rates.HO2NO2.destruction(end+1) = kv.HO2NO2_M;
    rates.HO2NO2.destruction(end+1) = kv.HO2NO2_OH;

    rates.HO2NO2.production(1) = kv.NO2_HO2_M;

    %% OH

    rates.OH.destruction(1) = kv.OH_O;
    rates.OH.destruction(2) = kv.OH_O3;
    rates.OH.destruction(3) = kv.OH_OH.*2;
    rates.OH.destruction(4) = kv.OH_HO2;
    rates.OH.destruction(5) = kv.OH_H2;
    rates.OH.destruction(6) = kv.OH_H2O2;
    rates.OH.destruction(7) = kv.OH_OH_M.*2;
    rates.OH.destruction(8) = kv.CH4_OH;
    rates.OH.destruction(9) = kv.HO2NO2_OH;
    rates.OH.destruction(10) = kv.CLO_OHa;
    rates.OH.destruction(11) = kv.CLO_OHb;
    rates.OH.destruction(12) = kv.HNO3_OH;
    rates.OH.destruction(13) = kv.HCL_OH;
    rates.OH.destruction(14) = kv.HOCL_OH;
    rates.OH.destruction(15) = kv.CLONO2_OH;
    rates.OH.destruction(16) = kv.BRO_OH;
    rates.OH.destruction(17) = kv.HBR_OH;
    rates.OH.destruction(18) = kv.OH_CH2O;
    rates.OH.destruction(19) = kv.NO3_OH;
    rates.OH.destruction(20) = kv.NO2_OH_M;
    rates.OH.destruction(21) = kv.OH_CO_Ma;
    rates.OH.destruction(22) = kv.OH_CO_Mb;

    rates.OH.production(end+1) = kv.H2O_O1D.*2;
    rates.OH.production(end+1) = kv.H_O3;
    rates.OH.production(end+1) = kv.HO2_O3;
    rates.OH.production(end+1) = kv.HO2_O;
    rates.OH.production(end+1) = kv.NO_HO2;
    rates.OH.production(end+1) = kv.H2_O1D;
    rates.OH.production(end+1) = kv.CH4_O1Da;
    rates.OH.production(end+1) = kv.CL_HO2b;
    rates.OH.production(end+1) = kv.H2O2_O;
    rates.OH.production(end+1) = kv.NO3_HO2;
    rates.OH.production(end+1) = kv.HCL_O1D;
    rates.OH.production(end+1) = kv.HOCL_O;
    rates.OH.production(end+1) = kv.HCL_O;
    rates.OH.production(end+1) = kv.HOBR_O;   

    %% HO2

    rates.HO2.destruction(end+1) = kv.HO2_O3;
    rates.HO2.destruction(end+1) = kv.HO2_O;
    rates.HO2.destruction(end+1) = kv.NO_HO2;
    rates.HO2.destruction(end+1) = kv.OH_HO2;
    rates.HO2.destruction(end+1) = kv.CLO_HO2;
    rates.HO2.destruction(end+1) = kv.HO2_HO2.*2;
    rates.HO2.destruction(end+1) = kv.NO2_HO2_M;
    rates.HO2.destruction(end+1) = kv.NO3_HO2;
    rates.HO2.destruction(end+1) = kv.BRO_HO2;
    rates.HO2.destruction(end+1) = kv.CL_HO2a;
    rates.HO2.destruction(end+1) = kv.CL_HO2b;
    rates.HO2.destruction(end+1) = kv.HO2_CH2O;
    rates.HO2.destruction(end+1) = kv.BR_HO2;

    rates.HO2.production(end+1) = kv.H_O2_M;
    rates.HO2.production(end+1) = kv.OH_O3;
    rates.HO2.production(end+1) = kv.OH_H2O2;
    rates.HO2.production(end+1) = kv.H2O2_O;
    rates.HO2.production(end+1) = kv.CLO_OHa;
    rates.HO2.production(end+1) = kv.CH4_O1Db;
    rates.HO2.production(end+1) = kv.NO3_OH;
    rates.HO2.production(end+1) = kv.CL_H2O2;
    rates.HO2.production(end+1) = kv.CL_CH2O;
    rates.HO2.production(end+1) = kv.BR_CH2O;
    rates.HO2.production(end+1) = kv.BRO_OH;
    rates.HO2.production(end+1) = kv.OH_CO_Ma;
    rates.HO2.production(end+1) = kv.CLO_CH3O2;
    rates.HO2.production(end+1) = kv.HO2NO2_M;

    %% H2O2

    rates.H2O2.destruction(end+1) = kv.OH_H2O2;
    rates.H2O2.destruction(end+1) = kv.H2O2_O;

    rates.H2O2.production(1) = kv.HO2_HO2;
    rates.H2O2.production(2) = kv.OH_OH_M;
    
    % If adding in new species add additional gas phase rates here.

    if inputs.methanechemistry
        % CH2O
        rates.CH2O.production(end+1) = kv.CH4_O1Db;
        rates.CH2O.production(end+1) = kv.CH4_O1Dc;
        rates.CH2O.production(end+1) = kv.CH3O2_NO;
        rates.CH2O.production(end+1) = kv.CLO_CH3O2;
        rates.CH2O.production(end+1) = kv.CH3O2_CH3O2a.*2;
        rates.CH2O.production(end+1) = kv.CH3O2_CH3O2b;
        rates.CH2O.production(end+1) = kv.CH3OH_OH;
        rates.CH2O.production(end+1) = kv.CH3OOH_OH.*.3;
        
        rates.CH2O.destruction(end+1) = kv.CL_CH2O;
        rates.CH2O.destruction(end+1) = kv.BR_CH2O;
        rates.CH2O.destruction(end+1) = kv.NO3_CH2O;
        rates.CH2O.destruction(end+1) = kv.OH_CH2O;
        rates.CH2O.destruction(end+1) = kv.HO2_CH2O;
        rates.CH2O.destruction(end+1) = kv.CH2O_O;
        
        % CH3O2
        rates.CH3O2.production(1) = kv.CL_CH4;
        rates.CH3O2.production(2) = kv.CH4_O1Da;
        rates.CH3O2.production(3) = kv.CH4_OH;
        rates.CH3O2.production(4) = kv.CH3OOH_OH.*.7;
        
        rates.CH3O2.destruction(1) = kv.CLO_CH3O2;
        rates.CH3O2.destruction(2) = kv.CH3O2_NO;
        rates.CH3O2.destruction(3) = kv.CH3O2_HO2;
        rates.CH3O2.destruction(4) = kv.CH3O2_CH3O2a.*2;
        rates.CH3O2.destruction(5) = kv.CH3O2_CH3O2b.*2;        
        
        % CH3OOH
        rates.CH3OOH.production(1) = kv.CH3O2_HO2;
        
        rates.CH3OOH.destruction(end+1) = kv.CH3OOH_OH;
        
        %CH3OH
        rates.CH3OH.production(1) = kv.CH3O2_CH3O2b;
        rates.CH3OH.destruction(2) = kv.CH3OH_OH;
        
        % additions to species that are already in main code block
        rates.HO2.production(end+1) = kv.CH3O2_CH3O2a.*2;
        rates.HO2.production(end+1) = kv.CH3OH_OH;
        rates.HO2.production(end+1) = kv.CH3O2_HO2;
        rates.HO2.production(end+1) = kv.CH2O_O;
        
        rates.OH.destruction(end+1) = kv.CH3OH_OH;
        rates.OH.destruction(end+1) = kv.CH3OOH_OH;
        rates.HO2.production(end+1) = kv.CH2O_O;
        
        rates.O.destruction(end+1) = kv.CH2O_O;
        
    end
    
end