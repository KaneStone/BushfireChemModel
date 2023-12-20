function rates = gasphaserates(inputs,step,variables,dayaverage,atmosphere,i,rates,photo,climScaleFactor,SZAdiff,RN)

    if RN
        timeind = 1;
    else
        timeind = i;
    end

Clfact = 1.015;    
    
day = climScaleFactor(round(step.hour.*1./inputs.hourstep+1)); % rounding to strip stray 0 decimals    
kout = gasphaseequations(atmosphere,variables,photo,timeind,step,day);    
    
%   first need to calculate atomic oxygen
%    rates.O.production
% 2*j1*O2  + j3*O3  + j5*NO  + j6*NO2  + j8*N2O5  + j10*NO3  + j19*H2O  + j22*CLO  + j23*OCLO  + j30*BRO
%                + j53*CO2  + .18*j55*CH4  + j83*SO2  + j84*SO3  + j86*SO  + r4*N2*O1D  + r5*O2*O1D  + r52*O2*N
%                + r277*O2*S  + r280*O2*SO  + r37*H*HO2  + r41*OH*OH  + r53*N*NO  + r54*N*NO2
%                - r1*O2*M*O  - r2*O3*O  - 2*r3*M*O*O  - r38*OH*O  - r45*H2*O  - r46*HO2*O  - r49*H2O2*O  - r57*M*NO*O
%                - r60*NO2*O  - r61*M*NO2*O  - r68*NO3*O  - r81*CLO*O  - r94*HCL*O  - r95*HOCL*O  - r98*CLONO2*O
%                - r104*BRO*O  - r114*HBR*O  - r115*HOBR*O  - r116*BRONO2*O  - r134*CH2O*O  - r274*OCS*O
% variables.NO2(timeind) = atmosphere.atLevel.NO2.nd(step.doy);
% variables.NO3(timeind) = atmosphere.atLevel.NO3.nd(step.doy);

O_plength = length(rates.O.production);

rates.O.production(O_plength+1) = kout.N2_O1D;
rates.O.production(O_plength+2) = kout.O2_O1D;
rates.O.production(O_plength+3) = kout.N_O2;
rates.O.production(O_plength+4) = kout.H_HO2c;
rates.O.production(O_plength+5) = kout.OH_OH;
rates.O.production(O_plength+6) = kout.N_NO;

rates.O.destruction(1) = kout.O_O2_M;
rates.O.destruction(2) = kout.O3_O;
rates.O.destruction(3) = kout.O_O_M.*2;
rates.O.destruction(4) = kout.OH_O;
rates.O.destruction(5) = kout.H2_O;
rates.O.destruction(6) = kout.HO2_O;
rates.O.destruction(7) = kout.H2O2_O;
rates.O.destruction(8) = kout.NO_O_M;
rates.O.destruction(9) = kout.NO2_O;
rates.O.destruction(10) = kout.NO2_O_M;
rates.O.destruction(11) = kout.NO3_O;
rates.O.destruction(12) = kout.CLO_O;
rates.O.destruction(13) = kout.HCL_O;
rates.O.destruction(14) = kout.HOBR_O;
rates.O.destruction(15) = kout.HOCL_O;
rates.O.destruction(16) = kout.CLONO2_O;
rates.O.destruction(17) = kout.BRO_O;
rates.O.destruction(18) = kout.HBR_O;
rates.O.destruction(19) = kout.BRONO2_O;

%% O3 RATES
O3_dlength = length(rates.O3.destruction);

%production
rates.O3.production(1) = kout.O_O2_M;

%destruction
rates.O3.destruction(O3_dlength+1) = kout.O1D_O3;
rates.O3.destruction(O3_dlength+2) = kout.O3_O;
rates.O3.destruction(O3_dlength+3) = kout.H_O3;
rates.O3.destruction(O3_dlength+4) = kout.OH_O3;
rates.O3.destruction(O3_dlength+5) = kout.HO2_O3;
rates.O3.destruction(O3_dlength+6) = kout.NO_O3;
rates.O3.destruction(O3_dlength+7) = kout.NO2_O3;
rates.O3.destruction(O3_dlength+8) = kout.CL_O3.*Clfact;
rates.O3.destruction(O3_dlength+9) = kout.BR_O3;
    
%% CLONO2 rates

CLONO2_dlength = length(rates.CLONO2.destruction);

%production
rates.CLONO2.production(1) = kout.CLO_NO2_M;

%destruction
rates.CLONO2.destruction(CLONO2_dlength+1) = kout.CLONO2_O;
rates.CLONO2.destruction(CLONO2_dlength+2) = kout.CLONO2_OH;
rates.CLONO2.destruction(CLONO2_dlength+3) = kout.CLONO2_CL;

%% HCL
%  r75*CL*H2  + r76*CL*H2O2  + r77*CL*HO2  + r79*CL*CH2O  + r80*CL*CH4  + r83*CLO*OH  + r96*HOCL*CL
%                  + 2*r117*CH3CL*CL  + r122*CH3BR*CL  + r127*CH2BR2*CL  + r128*CHBR3*CL  + r146*C2H6*CL
%                  - j26*HCL  - r30*O1D*HCL  - r93*OH*HCL  - r94*O*HCL  - r292*CLONO2*HCL  - r293*HOCL*HCL
%                  - r294*HOBR*HCL  - r297*CLONO2*HCL  - r298*HOCL*HCL  - r303*CLONO2*HCL  - r304*HOCL*HCL
%                  - r305*HOBR*HCL

HCL_dlength = length(rates.HCL.destruction);

%production
rates.HCL.production(1) = kout.CL_H2;
rates.HCL.production(2) = kout.CL_H2O2;
rates.HCL.production(3) = kout.CL_HO2a;
rates.HCL.production(4) = kout.CL_CH2O;
rates.HCL.production(5) = kout.CL_CH4;
rates.HCL.production(6) = kout.CLO_OHb;
rates.HCL.production(7) = kout.HOCL_CL;
rates.HCL.production(8) = kout.CH3CL_CL*2;
rates.HCL.production(9) = kout.CH3BR_CL;
rates.HCL.production(10) = kout.CH2BR2_CL;
rates.HCL.production(11) = kout.CHBR3_CL;
rates.HCL.production(12) = kout.C2H6_CL;

%destruction
rates.HCL.destruction(HCL_dlength+1) = kout.HCL_O1D;
rates.HCL.destruction(HCL_dlength+2) = kout.HCL_OH;
rates.HCL.destruction(HCL_dlength+3) = kout.HCL_O;

%% CLO
% j23*OCLO  + j28*CLONO2  + r92*M*CL2O2  + r92*M*CL2O2  + r74*CL*O3  + r78*CL*HO2  + r95*HOCL*O
%                  + r96*HOCL*CL  + r97*HOCL*OH  + r98*CLONO2*O  + r285*SO*OCLO
%                  - j22*CLO  - r81*O*CLO  - r82*OH*CLO  - r83*OH*CLO  - r84*HO2*CLO  - r85*CH3O2*CLO  - r86*NO*CLO
%                  - r87*M*NO2*CLO  - 2*r88*CLO*CLO  - 2*r89*CLO*CLO  - 2*r90*CLO*CLO  - 2*r91*M*CLO*CLO  - r109*BRO*CLO
%                  - r110*BRO*CLO  - r111*BRO*CLO  - r283*SO*CLO

CLO_plength = length(rates.CLO.production);
CLO_dlength = length(rates.CLO.destruction);


rates.CLO.production(CLO_plength+1) = kout.CL_O3;
rates.CLO.production(CLO_plength+2) = kout.CL_HO2b;
rates.CLO.production(CLO_plength+3) = kout.HOCL_O;
rates.CLO.production(CLO_plength+4) = kout.HOCL_OH;
rates.CLO.production(CLO_plength+5) = kout.HOCL_CL;
rates.CLO.production(CLO_plength+6) = kout.CLONO2_O;
rates.CLO.production(CLO_plength+7) = kout.CL2O2_M;

rates.CLO.destruction(CLO_dlength+1) = kout.CLO_CLO_M.*2;
rates.CLO.destruction(CLO_dlength+2) = kout.CLO_NO2_M;
rates.CLO.destruction(CLO_dlength+3) = kout.CLO_O;
rates.CLO.destruction(CLO_dlength+4) = kout.CLO_OHa;
rates.CLO.destruction(CLO_dlength+5) = kout.CLO_OHb;
rates.CLO.destruction(CLO_dlength+6) = kout.CLO_HO2;
rates.CLO.destruction(CLO_dlength+7) = kout.CLO_NO;
rates.CLO.destruction(CLO_dlength+8) = kout.CLO_CLOa*2;
rates.CLO.destruction(CLO_dlength+9) = kout.CLO_CLOb*2;
rates.CLO.destruction(CLO_dlength+10) = kout.CLO_CLOc*2;
rates.CLO.destruction(CLO_dlength+11) = kout.BRO_CLOa;
rates.CLO.destruction(CLO_dlength+12) = kout.BRO_CLOb;
rates.CLO.destruction(CLO_dlength+13) = kout.BRO_CLOc;
rates.CLO.destruction(CLO_dlength+14) = kout.CLO_SO;
rates.CLO.destruction(CLO_dlength+15) = kout.CLO_CH3O2;

% termolecular
%k0=1.90e-32.*(300./(atmosphere.atLevel.T(step.doy))).^3.6; % low pressure limit
%ki=3.7e-12.*(300./(atmosphere.atLevel.T(step.doy))).^1.6; % high pressure limit

lifetime = 1./((rates.CLO.destruction(CLO_dlength+7) + rates.CLO.destruction(CLO_dlength+6))./variables.CLO(timeind));


%% CL2  d(CL2)/dt = r89*CLO*CLO  + r100*CLONO2*CL  + r292*CLONO2*HCL  + r293*HOCL*HCL  + r297*CLONO2*HCL  + r298*HOCL*HCL
                % + r303*CLONO2*HCL  + r304*HOCL*HCL
                % - j21*CL2
CL2_plength = 0;
CL2_dlength = 1;

rates.CL2.production(CL2_plength+1) = kout.CLO_CLOb;
rates.CL2.production(CL2_plength+1) = kout.CLONO2_CL;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% CL d(CL)/dt = 2*j21*CL2  + j22*CLO  + 2*j24*CL2O2  + j25*HOCL  + j26*HCL  + j27*CLONO2  + j29*BRCL  + j35*CH3CL
%                 + 4*j36*CCL4  + 3*j37*CH3CCL3  + 3*j38*CFC11  + 2*j39*CFC12  + 3*j40*CFC113  + j41*HCFC22
%                 + 2*j42*CFC114  + j43*CFC115  + 2*j44*HCFC141B  + j45*HCFC142B  + j50*CF2CLBR  + 3*r10*O1D*CFC11
%                 + 2*r11*O1D*CFC12  + 3*r12*O1D*CFC113  + 2*r13*O1D*CFC114  + r14*O1D*CFC115  + r15*O1D*HCFC22
%                 + 2*r16*O1D*HCFC141B  + r17*O1D*HCFC142B  + 4*r18*O1D*CCL4  + r20*O1D*CF2CLBR  + r30*O1D*HCL
%                 + r81*CLO*O  + r82*CLO*OH  + r85*CLO*CH3O2  + r86*CLO*NO  + 2*r88*CLO*CLO  + r90*CLO*CLO  + r93*HCL*OH
%                 + r94*HCL*O  + r110*BRO*CLO  + r118*CH3CL*OH  + 3*r119*CH3CCL3*OH  + r120*HCFC22*OH
%                 + 2*r123*HCFC141B*OH  + r124*HCFC142B*OH  + r283*SO*CLO
%                 - r74*O3*CL  - r75*H2*CL  - r76*H2O2*CL  - r77*HO2*CL  - r78*HO2*CL  - r79*CH2O*CL  - r80*CH4*CL
%                 - r96*HOCL*CL  - r100*CLONO2*CL  - r117*CH3CL*CL  - r122*CH3BR*CL  - r127*CH2BR2*CL  - r128*CHBR3*CL
%                 - r146*C2H6*CL

CL_plength = length(rates.CL.production); 
CL_dlength = 0;


rates.CL.production(CL_plength+1) = kout.HCL_O1D;
rates.CL.production(CL_plength+2) = kout.CLO_O;
rates.CL.production(CL_plength+3) = kout.CLO_OHa;
rates.CL.production(CL_plength+4) = kout.CLO_CH3O2;
rates.CL.production(CL_plength+5) = kout.CLO_NO;
rates.CL.production(CL_plength+6) = kout.CLO_CLOa*2;
rates.CL.production(CL_plength+7) = kout.CLO_CLOc;
rates.CL.production(CL_plength+8) = kout.HCL_OH;
rates.CL.production(CL_plength+9) = kout.HCL_O;
rates.CL.production(CL_plength+10) = kout.BRO_CLOb;
rates.CL.production(CL_plength+11) = kout.CH3CL_OH;
rates.CL.production(CL_plength+12) = kout.CH3CCL3_OH;
rates.CL.production(CL_plength+13) = kout.CLO_SO;

rates.CL.destruction(CL_dlength+1) = kout.CL_O3.*Clfact; % This term to make temporarily stable (only works at 25 km)
rates.CL.destruction(CL_dlength+2) = kout.CL_H2;
rates.CL.destruction(CL_dlength+3) = kout.CL_H2O2;
rates.CL.destruction(CL_dlength+4) = kout.CL_HO2a;
rates.CL.destruction(CL_dlength+5) = kout.CL_HO2b; 
rates.CL.destruction(CL_dlength+6) = kout.CL_CH2O;
rates.CL.destruction(CL_dlength+7) = kout.CL_CH4;
rates.CL.destruction(CL_dlength+8) = kout.HOCL_CL;
rates.CL.destruction(CL_dlength+9) = kout.CLONO2_CL;
rates.CL.destruction(CL_dlength+10) = kout.CH3CL_CL;
rates.CL.destruction(CL_dlength+11) = kout.CH3BR_CL;
rates.CL.destruction(CL_dlength+12) = kout.CH2BR2_CL;
rates.CL.destruction(CL_dlength+13) = kout.CHBR3_CL;
rates.CL.destruction(CL_dlength+14) = kout.C2H6_CL;

%% CL2O2 r91*M*CLO*CLO
          %         - j24*CL2O2  - r92*M*CL2O2
CL2O2_dlength = length(rates.CL2O2.destruction); 
CL2O2_plength = 0;

%production
rates.CL2O2.production(CL2O2_plength+1) = kout.CLO_CLO_M;

%destruction
rates.CL2O2.destruction(CL2O2_dlength+1) = kout.CL2O2_M;

%% HOCL
%  r290*CLONO2  + r296*CLONO2  + r301*CLONO2  + r84*CLO*HO2  + r99*CLONO2*OH
%                   - j25*HOCL  - r95*O*HOCL  - r96*CL*HOCL  - r97*OH*HOCL  - r293*HCL*HOCL  - r298*HCL*HOCL
%                   - r304*HCL*HOCL

HOCL_dlength = length(rates.HOCL.destruction); 
HOCL_plength = 0;

rates.HOCL.production(HOCL_plength+1) = kout.CLO_HO2;
rates.HOCL.production(HOCL_plength+2) = kout.CLONO2_OH;

rates.HOCL.destruction(HOCL_dlength+1) =  kout.HOCL_O;
rates.HOCL.destruction(HOCL_dlength+2) =  kout.HOCL_CL;
rates.HOCL.destruction(HOCL_dlength+3) =  kout.HOCL_OH;

%% NO2     

% j7*N2O5  + j9*HNO3  + j10*NO3  + j13*HO2NO2  + j28*CLONO2  + j34*BRONO2  + .6*j59*PAN  + j60*MPAN       
% + j71*ONITR  + r64*M*N2O5  + r73*M*HO2NO2  + r172*M*PAN  + r218*M*MPAN  + r57*M*NO*O  + r58*NO*HO2     
% + r59*NO*O3  + 2*r67*NO3*NO  + r68*NO3*O  + r69*NO3*OH  + r70*NO3*HO2  + r72*HO2NO2*OH  + r86*CLO*NO   
% + r107*BRO*NO  + r136*CH3O2*NO  + r144*HOCH2OO*NO  + r150*EO2*NO  + r156*C2H5O2*NO  + r163*CH3CO3*NO   
% + r177*C3H7O2*NO  + r182*PO2*NO  + r186*RO2*NO  + r193*ONIT*OH  + r195*ENEO2*NO  + r199*MEKO2*NO       
% + r204*MACRO2*NO  + r206*MACRO2*NO3  + r211*MCO3*NO  + r212*MCO3*NO3  + .92*r223*ISOPO2*NO             
% + r224*ISOPO2*NO3  + 1.206*r229*ISOPNO3*NO  + 1.206*r230*ISOPNO3*NO3  + .206*r231*ISOPNO3*HO2          
% + .4*r233*ONITR*OH  + r234*ONITR*NO3  + .9*r236*ALKO2*NO  + r239*XO2*NO  + r240*XO2*NO3                
% + .9*r247*TOLO2*NO  + .7*r251*XOH*NO2  + .9*r254*BENO2*NO  + .9*r257*XYLO2*NO  + r260*C10H16*NO3       
% + r261*TERPO2*NO                                                                                       
% - j6*NO2  - r266*NO2  - r54*N*NO2  - r55*N*NO2  - r56*N*NO2  - r60*O*NO2  - r61*M*O*NO2  - r62*O3*NO2  
% - r63*M*NO3*NO2  - r65*M*OH*NO2  - r71*M*HO2*NO2  - r87*M*CLO*NO2  - r108*M*BRO*NO2                    
% - r164*M*CH3CO3*NO2  - r217*M*MCO3*NO2  - r251*XOH*NO2  - r282*SO*NO2  

NO2_dlength = length(rates.NO2.destruction); 
NO2_plength = length(rates.NO2.production); 

rates.NO2.production(NO2_plength+1) = kout.N2O5_M;
rates.NO2.production(NO2_plength+2) = kout.HO2NO2_M;
rates.NO2.production(NO2_plength+3) = kout.NO_O_M;
rates.NO2.production(NO2_plength+4) = kout.NO_HO2;
rates.NO2.production(NO2_plength+5) = kout.NO_O3;%.*1.0037; % The 1.0037 term is to make NOx cycle stable at reasonable concentrations. (only works for 25 km)
rates.NO2.production(NO2_plength+6) = kout.NO3_NO.*2;
rates.NO2.production(NO2_plength+7) = kout.NO3_O;
rates.NO2.production(NO2_plength+8) = kout.NO3_OH;
rates.NO2.production(NO2_plength+9) = kout.NO3_HO2;
rates.NO2.production(NO2_plength+10) = kout.HO2NO2_OH;
rates.NO2.production(NO2_plength+11) = kout.CLO_NO;
rates.NO2.production(NO2_plength+12) = kout.BRO_NO;
rates.NO2.production(NO2_plength+13) = kout.CH3O2_NO;
%rates.NO2.production(NO2_plength+14) = kout.CH3O3_NO;

rates.NO2.destruction(NO2_dlength+1) = kout.N_NO2a;
rates.NO2.destruction(NO2_dlength+2) = kout.N_NO2b;
rates.NO2.destruction(NO2_dlength+3) = kout.NO2_O;
rates.NO2.destruction(NO2_dlength+4) = kout.NO2_O_M;
rates.NO2.destruction(NO2_dlength+5) = kout.NO2_O3;
rates.NO2.destruction(NO2_dlength+6) = kout.NO2_NO3_M;
rates.NO2.destruction(NO2_dlength+7) = kout.NO2_OH_M;
rates.NO2.destruction(NO2_dlength+8) = kout.NO2_HO2_M;
rates.NO2.destruction(NO2_dlength+9) = kout.CLO_NO2_M;
rates.NO2.destruction(NO2_dlength+10) = kout.BRO_NO2_M;


%%NO
% d(NO)/dt = j6*NO2  + j8*N2O5  + j11*NO3  + r52*O2*N  + .5*r266*NO2  + 2*r7*O1D*N2O  + 2*r55*N*NO2  + r60*NO2*O      
% + r282*SO*NO2                                                                                           
% - j5*NO  - r53*N*NO  - r57*M*O*NO  - r58*HO2*NO  - r59*O3*NO  - r67*NO3*NO  - r86*CLO*NO                
% - r107*BRO*NO  - r136*CH3O2*NO  - r144*HOCH2OO*NO  - r150*EO2*NO  - r156*C2H5O2*NO  - r163*CH3CO3*NO    
% - r177*C3H7O2*NO  - r182*PO2*NO  - r186*RO2*NO  - r195*ENEO2*NO  - r199*MEKO2*NO  - r204*MACRO2*NO      
% - r205*MACRO2*NO  - r211*MCO3*NO  - r223*ISOPO2*NO  - r229*ISOPNO3*NO  - r236*ALKO2*NO  - r239*XO2*NO   
% - r247*TOLO2*NO  - r254*BENO2*NO  - r257*XYLO2*NO  - r261*TERPO2*NO 

NO_dlength = 0;%length(rates.NO.destruction); 
NO_plength = length(rates.NO.production); 

rates.NO.production(NO_plength+1) = kout.N_O2;
rates.NO.production(NO_plength+2) = kout.O1D_N2Oa.*2;
rates.NO.production(NO_plength+3) = kout.N_NO2b.*2;
rates.NO.production(NO_plength+4) = kout.NO2_O;
rates.NO.production(NO_plength+5) = kout.NO2_SO;

%rates.NO.production(NO_plength+14) = kout.CH3O3_NO;

rates.NO.destruction(NO_dlength+1) = kout.N_NO;
rates.NO.destruction(NO_dlength+2) = kout.NO_O_M;
rates.NO.destruction(NO_dlength+3) = kout.NO_HO2;
rates.NO.destruction(NO_dlength+4) = kout.NO_O3;
rates.NO.destruction(NO_dlength+5) = kout.NO3_NO;
rates.NO.destruction(NO_dlength+6) = kout.CLO_NO;
rates.NO.destruction(NO_dlength+7) = kout.BRO_NO;
rates.NO.destruction(NO_dlength+8) = kout.CH3O2_NO;
 
%% NO3
% d(NO3)/dt = j7*N2O5  + j8*N2O5  + j12*HO2NO2  + j27*CLONO2  + j33*BRONO2  + .4*j59*PAN  + r64*M*N2O5                
%  + r61*M*NO2*O  + r62*NO2*O3  + r66*HNO3*OH  + r98*CLONO2*O  + r99*CLONO2*OH  + r100*CLONO2*CL          
%  + r116*BRONO2*O  + r173*PAN*OH  + .5*r219*M*MPAN*OH                                                    
%  - j10*NO3  - j11*NO3  - r265*NO3  - r63*M*NO2*NO3  - r67*NO*NO3  - r68*O*NO3  - r69*OH*NO3             
%  - r70*HO2*NO3  - r132*CH2O*NO3  - r162*CH3CHO*NO3  - r176*C3H6*NO3  - r192*CH3COCHO*NO3                
%  - r206*MACRO2*NO3  - r212*MCO3*NO3  - r222*ISOP*NO3  - r224*ISOPO2*NO3  - r230*ISOPNO3*NO3             
%  - r234*ONITR*NO3  - r240*XO2*NO3  - r260*C10H16*NO3  - r270*DMS*NO3                                    


NO3_dlength = length(rates.NO3.destruction); 
NO3_plength = length(rates.NO3.production); 

rates.NO3.production(NO3_plength+1) = kout.N2O5_M;
rates.NO3.production(NO3_plength+2) = kout.NO2_O_M;
rates.NO3.production(NO3_plength+3) = kout.NO2_O3;
rates.NO3.production(NO3_plength+4) = kout.HNO3_OH;
rates.NO3.production(NO3_plength+5) = kout.CLONO2_O;
rates.NO3.production(NO3_plength+6) = kout.CLONO2_OH;
rates.NO3.production(NO3_plength+7) = kout.CLONO2_CL;
rates.NO3.production(NO3_plength+8) = kout.BRONO2_O;

%rates.NO3.production(NO3_plength+14) = kout.CH3O3_NO3;

rates.NO3.destruction(NO3_dlength+1) = kout.NO2_NO3_M;
rates.NO3.destruction(NO3_dlength+2) = kout.NO3_NO;
rates.NO3.destruction(NO3_dlength+3) = kout.NO3_O;
rates.NO3.destruction(NO3_dlength+4) = kout.NO3_OH;
rates.NO3.destruction(NO3_dlength+5) = kout.NO3_HO2;
rates.NO3.destruction(NO3_dlength+6) = kout.NO3_CH2O;


%% N2O5
% d(N2O5)/dt = r63*M*NO2*NO3                                                                                          
% - j7*N2O5  - j8*N2O5  - r64*M*N2O5  - r264*N2O5  - r289*N2O5  - r295*N2O5  - r300*N2O5                
N2O5_dlength = length(rates.N2O5.destruction); 

rates.N2O5.production(1) = kout.NO2_NO3_M;

%rates.N2O5.production(N2O5_plength+14) = kout.CH3O3_N2O5;

rates.N2O5.destruction(N2O5_dlength+1) = kout.N2O5_M;


end