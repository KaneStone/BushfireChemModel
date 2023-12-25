function [rates] = gasphasecontrol(step,variables,atmosphere,i,rates,photo,RN)

    if RN
        timeind = 1;
    else
        timeind = i;
    end

Clfact = 1.000;    
    
%day = climScaleFactor(round(step.hour.*1./inputs.hourstep+1)); % rounding to strip stray 0 decimals    
kout = gasphaserates(atmosphere,variables,photo,timeind,step);    
    
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
rates.O.production(O_plength+3) = kout.OH_OH;
%rates.O.production(O_plength+4) = kout.N_NO;
% rates.O.production(O_plength+5) = kout.N_O2;
% rates.O.production(O_plength+6) = kout.H_HO2c;

rates.O.destruction(1) = kout.O_O2_M;
rates.O.destruction(2) = kout.O3_O;
rates.O.destruction(3) = kout.O_O_M.*2;
rates.O.destruction(4) = kout.HO2_O;
rates.O.destruction(5) = kout.NO_O_M;
rates.O.destruction(6) = kout.NO2_O;
rates.O.destruction(7) = kout.NO2_O_M;
rates.O.destruction(8) = kout.NO3_O;
rates.O.destruction(9) = kout.CLO_O;
rates.O.destruction(10) = kout.HOBR_O;
rates.O.destruction(11) = kout.HOCL_O;
rates.O.destruction(12) = kout.CLONO2_O;
rates.O.destruction(13) = kout.BRO_O;
rates.O.destruction(14) = kout.BRONO2_O;
rates.O.destruction(15) = kout.OH_O;
%rates.O.destruction(16) = kout.H2_O;
%rates.O.destruction(17) = kout.H2O2_O;
%rates.O.destruction(18) = kout.HCL_O;
%rates.O.destruction(19) = kout.HBR_O;

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

% if O3dyn < 0
%     rates.O3.production(end+1) = abs(O3dyn).*variables.O3(timeind);
% else
%     rates.O3.destruction(end+1) = O3dyn;
% end

%% O1D
% j2*O3  + j4*N2O  + j18*H2O                                                                              
%  - r4*N2*O1D  - r5*O2*O1D  - r6*H2O*O1D  - r7*N2O*O1D  - r8*N2O*O1D  - r9*O3*O1D  - r10*CFC11*O1D       
%  - r11*CFC12*O1D  - r12*CFC113*O1D  - r13*CFC114*O1D  - r14*CFC115*O1D  - r15*HCFC22*O1D                
%  - r16*HCFC141B*O1D  - r17*HCFC142B*O1D  - r18*CCL4*O1D  - r19*CH3BR*O1D  - r20*CF2CLBR*O1D             
%  - r21*CF3BR*O1D  - r22*H1202*O1D  - r23*H2402*O1D  - r24*CHBR3*O1D  - r25*CH2BR2*O1D  - r26*CH4*O1D    
%  - r27*CH4*O1D  - r28*CH4*O1D  - r29*H2*O1D  - r30*HCL*O1D  - r31*HBR*O1D  - r32*HCN*O1D  

%production

%destruction
rates.O1D.destruction(1) = kout.N2_O1D;
rates.O1D.destruction(2) = kout.O2_O1D;
rates.O1D.destruction(3) = kout.H2O_O1D;
rates.O1D.destruction(4) = kout.O1D_N2Oa;
rates.O1D.destruction(5) = kout.O1D_N2Ob;
rates.O1D.destruction(5) = kout.HCL_O1D;
if i == 25
    a = 1;
end
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
% rates.HCL.production(8) = kout.CH3CL_CL*2;
% rates.HCL.production(9) = kout.CH3BR_CL;
% rates.HCL.production(10) = kout.CH2BR2_CL;
% rates.HCL.production(11) = kout.CHBR3_CL;
% rates.HCL.production(12) = kout.C2H6_CL;

%destruction
rates.HCL.destruction(HCL_dlength+1) = kout.HCL_O1D;
rates.HCL.destruction(HCL_dlength+2) = kout.HCL_OH;
%rates.HCL.destruction(HCL_dlength+3) = kout.HCL_O;



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
rates.CLO.production(CLO_plength+8) = kout.BR_OCLO;

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
rates.CLO.destruction(CLO_dlength+14) = kout.CLO_CH3O2;
% rates.CLO.destruction(CLO_dlength+14) = kout.CLO_SO;



% termolecular
%k0=1.90e-32.*(300./(atmosphere.atLevel.T(step.doy))).^3.6; % low pressure limit
%ki=3.7e-12.*(300./(atmosphere.atLevel.T(step.doy))).^1.6; % high pressure limit

lifetime = 1./((rates.CLO.destruction(CLO_dlength+7) + rates.CLO.destruction(CLO_dlength+6))./variables.CLO(timeind));


%% CL2  d(CL2)/dt = r89*CLO*CLO  + r100*CLONO2*CL  + r292*CLONO2*HCL  + r293*HOCL*HCL  + r297*CLONO2*HCL  + r298*HOCL*HCL
                % + r303*CLONO2*HCL  + r304*HOCL*HCL
                % - j21*CL2
CL2_plength = 0;


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



rates.CL.production(CL_plength+1) = kout.CLO_O;
rates.CL.production(CL_plength+2) = kout.CLO_OHa;

rates.CL.production(CL_plength+3) = kout.CLO_NO;

rates.CL.production(CL_plength+4) = kout.HCL_OH;
rates.CL.production(CL_plength+5) = kout.BRO_CLOb;
% rates.CL.production(CL_plength+6) = kout.CH3CL_OH;
% rates.CL.production(CL_plength+7) = kout.CLO_CLOc;
% rates.CL.production(CL_plength+8) = kout.CLO_CH3O2;
% rates.CL.production(CL_plength+9) = kout.HCL_O1D;
% rates.CL.production(CL_plength+10) = kout.CLO_CLOa*2;
% rates.CL.production(CL_plength+11) = kout.HCL_O;
% rates.CL.production(CL_plength+12) = kout.CH3CCL3_OH;
% rates.CL.production(CL_plength+13) = kout.CLO_SO;

%reaction_namelist.CL.production{end+1:}

rates.CL.destruction(CL_dlength+1) = kout.CL_O3.*Clfact; % This term to make temporarily stable (only works at 25 km)
rates.CL.destruction(CL_dlength+2) = kout.CL_H2;
rates.CL.destruction(CL_dlength+3) = kout.CL_H2O2;
rates.CL.destruction(CL_dlength+4) = kout.CL_HO2a;
rates.CL.destruction(CL_dlength+5) = kout.CL_HO2b; 
rates.CL.destruction(CL_dlength+6) = kout.CL_CH2O;
rates.CL.destruction(CL_dlength+7) = kout.CL_CH4;
rates.CL.destruction(CL_dlength+8) = kout.HOCL_CL;
rates.CL.destruction(CL_dlength+9) = kout.CLONO2_CL;
% rates.CL.destruction(CL_dlength+10) = kout.CL_O2_M;
% rates.CL.destruction(CL_dlength+11) = kout.CL_CO_M;
% rates.CL.destruction(CL_dlength+12) = kout.CL_NO_M;
% rates.CL.destruction(CL_dlength+13) = kout.CL_NO2_M;
%rates.CL.destruction(CL_dlength+10) = kout.CH3CL_CL;
% rates.CL.destruction(CL_dlength+11) = kout.CH3BR_CL;
% rates.CL.destruction(CL_dlength+12) = kout.CH2BR2_CL;
% rates.CL.destruction(CL_dlength+13) = kout.CHBR3_CL;
% rates.CL.destruction(CL_dlength+14) = kout.C2H6_CL;

if i == 30
    a = 1;
end

%% OCLO
rates.OCLO.destruction(2) = kout.BR_OCLO;

rates.OCLO.production(1) = kout.CLO_CLOc;
rates.OCLO.production(2) = kout.BRO_CLOa;

%% BRCL
rates.BRCL.production(1) = kout.BRO_CLOc;

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

%% BRO
% d(BRO)/dt = j34*BRONO2  + r101*BR*O3  + r115*HOBR*O  + r116*BRONO2*O                                                
% - j30*BRO  - r104*O*BRO  - r105*OH*BRO  - r106*HO2*BRO  - r107*NO*BRO  - r108*M*NO2*BRO  
BRO_dlength = length(rates.BRO.destruction); 
BRO_plength = length(rates.BRO.production); 

rates.BRO.production(BRO_plength+1) = kout.BR_O3;
rates.BRO.production(BRO_plength+2) = kout.HOBR_O;
rates.BRO.production(BRO_plength+3) = kout.BRONO2_O;
rates.BRO.production(BRO_plength+4) = kout.BR_OCLO;

rates.BRO.destruction(BRO_dlength+1) =  kout.BRO_O;
rates.BRO.destruction(BRO_dlength+2) =  kout.BRO_OH;
rates.BRO.destruction(BRO_dlength+3) =  kout.BRO_HO2;
rates.BRO.destruction(BRO_dlength+4) =  kout.BRO_NO;
rates.BRO.destruction(BRO_dlength+5) =  kout.BRO_NO2_M;
rates.BRO.destruction(BRO_dlength+6) =  kout.BRO_CLOa;
rates.BRO.destruction(BRO_dlength+7) =  kout.BRO_CLOb;
rates.BRO.destruction(BRO_dlength+8) =  kout.BRO_CLOc;
rates.BRO.destruction(BRO_dlength+8) =  kout.BRO_BRO.*2;

%% HOBR
% d(HOBR)/dt = r291*BRONO2  + r299*BRONO2  + r302*BRONO2  + r106*BRO*HO2                                              
% - j31*HOBR  - r115*O*HOBR  - r294*HCL*HOBR  - r305*HCL*HOBR   

HOBR_dlength = length(rates.HOBR.destruction); 

rates.HOBR.production(1) = kout.BRO_HO2;

rates.HOBR.destruction(HOBR_dlength+1) =  kout.HOBR_O;

%% HBR
% d(HBR)/dt = r102*BR*HO2  + r103*BR*CH2O                                                                             
% - j32*HBR  - r31*O1D*HBR  - r113*OH*HBR  - r114*O*HBR  

rates.HBR.production(1) = kout.BR_HO2;
rates.HBR.production(2) = kout.BR_CH2O;

rates.HBR.destruction(1) =  kout.HBR_OH;
%rates.HBR.destruction(2) =  kout.HBR_O1D;
%rates.HBR.destruction(3) =  kout.HBR_O;

%% BRONO2
% d(BRONO2)/dt = r108*M*BRO*NO2                                                                                       
% - j33*BRONO2  - j34*BRONO2  - r291*BRONO2  - r299*BRONO2  - r302*BRONO2  - r116*O*BRONO2    

BRONO2_dlength = length(rates.BRONO2.destruction); 

rates.BRONO2.production(1) = kout.BRO_NO2_M;

rates.BRONO2.destruction(BRONO2_dlength+1) =  kout.BRONO2_O;

%% BR
% BR)/dt = j29*BRCL  + j30*BRO  + j31*HOBR  + j32*HBR  + j33*BRONO2  + j46*CH3BR  + j47*CF3BR  + 2*j48*H1202        
% + 2*j49*H2402  + j50*CF2CLBR  + 3*j51*CHBR3  + 2*j52*CH2BR2  + r19*O1D*CH3BR  + r20*O1D*CF2CLBR         
% + r21*O1D*CF3BR  + 2*r22*O1D*H1202  + 2*r23*O1D*H2402  + 3*r24*O1D*CHBR3  + 2*r25*O1D*CH2BR2            
% + r31*O1D*HBR  + r104*BRO*O  + r105*BRO*OH  + r107*BRO*NO  + r109*BRO*CLO  + r110*BRO*CLO               
% + 2*r112*BRO*BRO  + r113*HBR*OH  + r114*HBR*O  + r121*CH3BR*OH  + r122*CH3BR*CL  + 2*r125*CH2BR2*OH     
% + 3*r126*CHBR3*OH  + 2*r127*CH2BR2*CL  + 3*r128*CHBR3*CL  + r284*SO*BRO                                 
% - r101*O3*BR  - r102*HO2*BR  - r103*CH2O*BR 

BR_plength = length(rates.BR.production); 



rates.BR.production(BR_plength+1) = kout.BRO_O;
rates.BR.production(BR_plength+2) = kout.BRO_OH;
rates.BR.production(BR_plength+3) = kout.BRO_NO;
rates.BR.production(BR_plength+4) = kout.BRO_CLOa;
rates.BR.production(BR_plength+5) = kout.BRO_CLOb;
rates.BR.production(BR_plength+6) = kout.BRO_BRO.*2;
rates.BR.production(BR_plength+7) = kout.HBR_OH;
% rates.BR.production(BR_plength+8) = kout.CHBR3_O1D.*3;
% rates.BR.production(BR_plength+9) = kout.CH3BR_O1D;
% rates.BR.production(BR_plength+10) = kout.CH2BR2_O1D.*2;
% rates.BR.production(BR_plength+11) = kout.HBR_O;
% rates.BR.production(BR_plength+12) = kout.CH3BR_CL;
% rates.BR.production(BR_plength+13) = kout.CH3BR_OH;%
% rates.BR.production(BR_plength+14) = kout.CH2BR2_OH.*2;%
% rates.BR.production(BR_plength+15) = kout.CHBR3_OH.*3;%
% rates.BR.production(BR_plength+16) = kout.CH2BR2_CL.*2;
% rates.BR.production(BR_plength+17) = kout.CHBR3_CL.*3;
% rates.BR.production(BR_plength+18) = kout.HBR_O1D;
% 5,6,7

rates.BR.destruction(1) = kout.BR_O3;
rates.BR.destruction(2) = kout.BR_HO2;
rates.BR.destruction(3) = kout.BR_CH2O;
rates.BR.destruction(4) = kout.BR_OCLO;

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
rates.NO2.production(NO2_plength+5) = kout.NO_O3;% + variables.NO2(timeind)./16750; % The 1.0037 term is to make NOx cycle stable at reasonable concentrations. (only works for 25 km)
rates.NO2.production(NO2_plength+6) = kout.NO3_NO.*2;
rates.NO2.production(NO2_plength+7) = kout.NO3_O;
rates.NO2.production(NO2_plength+8) = kout.NO3_OH;
rates.NO2.production(NO2_plength+9) = kout.NO3_HO2;
rates.NO2.production(NO2_plength+10) = kout.HO2NO2_OH;
rates.NO2.production(NO2_plength+11) = kout.CLO_NO;
rates.NO2.production(NO2_plength+12) = kout.BRO_NO;
rates.NO2.production(NO2_plength+13) = kout.CH3O2_NO;
%rates.NO2.production(NO2_plength+14) = kout.PAN_M;
%rates.NO2.production(NO2_plength+14) = kout.CH3O3_NO;


rates.NO2.destruction(NO2_dlength+1) = kout.NO2_O;
rates.NO2.destruction(NO2_dlength+2) = kout.NO2_O_M;
rates.NO2.destruction(NO2_dlength+3) = kout.NO2_O3;
rates.NO2.destruction(NO2_dlength+4) = kout.NO2_NO3_M;
rates.NO2.destruction(NO2_dlength+5) = kout.NO2_HO2_M;
rates.NO2.destruction(NO2_dlength+6) = kout.CLO_NO2_M;
rates.NO2.destruction(NO2_dlength+7) = kout.BRO_NO2_M;
rates.NO2.destruction(NO2_dlength+8) = kout.NO2_OH_M;
%rates.NO2.destruction(NO2_dlength+9) = kout.N_NO2a;
%rates.NO2.destruction(NO2_dlength+10) = kout.N_NO2b;


lifetime = 1./((sum(rates.NO2.destruction))./variables.NO2(timeind));


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




rates.NO.production(NO_plength+1) = kout.NO2_O;
%rates.NO.production(1) = 0;

% rates.NO.production(NO_plength+2) = kout.N_O2;
rates.NO.production(NO_plength+2) = kout.O1D_N2Oa.*2;
% rates.NO.production(NO_plength+4) = kout.N_NO2b.*2;
% rates.NO.production(NO_plength+5) = kout.NO2_SO;

rates.NO.destruction(NO_dlength+1) = kout.NO_O_M;
rates.NO.destruction(NO_dlength+2) = kout.NO_HO2;
rates.NO.destruction(NO_dlength+3) = kout.NO_O3;
rates.NO.destruction(NO_dlength+4) = kout.NO3_NO;
rates.NO.destruction(NO_dlength+5) = kout.CLO_NO;
rates.NO.destruction(NO_dlength+6) = kout.BRO_NO;
rates.NO.destruction(NO_dlength+7) = kout.CH3O2_NO;

%rates.NO.destruction(NO_dlength+8) = kout.N_NO;

dummyNO = (rates.NO2.destruction(1) + rates.NO2.destruction(2))./...
    (rates.NO2.production(10) + rates.NO2.production(11) + rates.NO2.production(19) + rates.NO2.production(17)).*variables.NO2; 

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

rates.N2O5.destruction(N2O5_dlength+1) = kout.N2O5_M;


%% N2O5
% d(N2O5)/dt = r63*M*NO2*NO3                                                                                          
% - j7*N2O5  - j8*N2O5  - r64*M*N2O5  - r264*N2O5  - r289*N2O5  - r295*N2O5  - r300*N2O5                
HNO3_dlength = length(rates.HNO3.destruction); 

rates.HNO3.destruction(HNO3_dlength+1) = kout.HNO3_OH;

rates.HNO3.production(1) = kout.NO2_OH_M;
rates.HNO3.production(2) = kout.NO3_CH2O;

%% HO2NO2
% d(HO2NO2)/dt = r71*M*NO2*HO2                                                                                        
% - j12*HO2NO2  - j13*HO2NO2  - r73*M*HO2NO2  - r72*OH*HO2NO2                   
HO2NO2_dlength = length(rates.HO2NO2.destruction); 

rates.HO2NO2.destruction(HO2NO2_dlength+1) = kout.HO2NO2_M;
rates.HO2NO2.destruction(HO2NO2_dlength+2) = kout.HO2NO2_OH;

%rates.N2O5.production(N2O5_plength+14) = kout.CH3O3_N2O5;

rates.HO2NO2.production(1) = kout.NO2_HO2_M;

%% OH

% d(OH)/dt = j9*HNO3  + j12*HO2NO2  + j14*CH3OOH  + j17*H2O  + 2*j20*H2O2  + j25*HOCL  + j31*HOBR  + .66*j55*CH4      
% + j57*POOH  + j58*CH3COOOH  + j64*C2H5OOH  + j65*EOOH  + j66*C3H7OOH  + j67*ROOH  + j70*XOOH            
% + j78*ALKOOH  + j79*MEKOOH  + j80*TOLOOH  + j81*TERPOOH  + .5*r266*NO2  + 2*r6*O1D*H2O  + r26*O1D*CH4   
% + r29*O1D*H2  + r30*O1D*HCL  + r31*O1D*HBR  + r32*O1D*HCN  + r34*H*O3  + 2*r35*H*HO2  + r45*H2*O        
% + r46*HO2*O  + r47*HO2*O3  + r49*H2O2*O  + r58*NO*HO2  + r70*NO3*HO2  + r78*CL*HO2  + r94*HCL*O         
% + r95*HOCL*O  + r114*HBR*O  + r115*HOBR*O  + r134*CH2O*O  + .3*r141*CH3OOH*OH  + .65*r147*M*C2H2*OH     
% + .12*r154*C2H4*O3  + .5*r160*C2H5OOH*OH  + .33*r175*C3H6*O3  + .5*r184*POOH*OH  + .08*r197*MVK*O3      
% + .215*r203*MACR*O3  + .1*r210*MACROOH*OH  + .27*r221*ISOP*O3  + .7*r259*C10H16*O3                      
% - r38*O*OH  - r39*O3*OH  - r40*HO2*OH  - 2*r41*OH*OH  - 2*r42*M*OH*OH  - r43*H2*OH  - r44*H2O2*OH       
% - r50*M*HCN*OH  - r51*CH3CN*OH  - r65*M*NO2*OH  - r66*HNO3*OH  - r69*NO3*OH  - r72*HO2NO2*OH            
% - r82*CLO*OH  - r83*CLO*OH  - r93*HCL*OH  - r97*HOCL*OH  - r99*CLONO2*OH  - r105*BRO*OH  - r113*HBR*OH  
% - r118*CH3CL*OH  - r119*CH3CCL3*OH  - r120*HCFC22*OH  - r121*CH3BR*OH  - r123*HCFC141B*OH               
% - r124*HCFC142B*OH  - r125*CH2BR2*OH  - r126*CHBR3*OH  - r129*CH4*OH  - r130*CO*OH  - r131*M*CO*OH      
% - r133*CH2O*OH  - r140*CH3OH*OH  - r141*CH3OOH*OH  - r142*HCOOH*OH  - r147*M*C2H2*OH  - r148*C2H6*OH    
% - r149*M*C2H4*OH  - r155*CH3COOH*OH  - r160*C2H5OOH*OH  - r161*CH3CHO*OH  - r168*CH3COOOH*OH            
% - r169*GLYALD*OH  - r170*GLYOXAL*OH  - r171*C2H5OH*OH  - r173*PAN*OH  - r174*M*C3H6*OH                  
% - r180*C3H7OOH*OH  - r181*C3H8*OH  - r184*POOH*OH  - r185*CH3COCH3*OH  - r189*ROOH*OH  - r190*HYAC*OH   
% - r191*CH3COCHO*OH  - r193*ONIT*OH  - r194*BIGENE*OH  - r196*MVK*OH  - r198*MEK*OH  - r201*MEKOOH*OH    
% - r202*MACR*OH  - r210*MACROOH*OH  - r219*M*MPAN*OH  - r220*ISOP*OH  - r226*ISOPOOH*OH                  
% - r232*BIGALK*OH  - r233*ONITR*OH  - r235*HYDRALD*OH  - r238*ALKOOH*OH  - r244*XOOH*OH                  
% - r246*TOLUENE*OH  - r249*TOLOOH*OH  - r250*CRESOL*OH  - r252*BENZENE*OH  - r255*XYLENE*OH              
% - r258*C10H16*OH  - r263*TERPOOH*OH  - r268*DMS*OH  - r269*DMS*OH  - r271*NH3*OH  - r275*OCS*OH         
% - r276*S*OH  - r279*SO*OH  - r286*M*SO2*OH    

OH_plength = length(rates.OH.production);

rates.OH.destruction(1) = kout.OH_O;
rates.OH.destruction(2) = kout.OH_O3;
rates.OH.destruction(3) = kout.OH_OH.*2;
rates.OH.destruction(4) = kout.OH_HO2;
rates.OH.destruction(5) = kout.OH_H2;
rates.OH.destruction(6) = kout.OH_H2O2;
rates.OH.destruction(7) = kout.OH_OH_M.*2;
rates.OH.destruction(8) = kout.OH_CO_Ma;
rates.OH.destruction(9) = kout.OH_CO_Mb;
rates.OH.destruction(10) = kout.CH4_OH;
%rates.OH.destruction(10) = kout.CH3BR_OH;

rates.OH.production(OH_plength+1) = kout.H2O_O1D.*2;
rates.OH.production(OH_plength+2) = kout.H_O3;
rates.OH.production(OH_plength+3) = kout.HO2_O3;
rates.OH.production(OH_plength+4) = kout.HO2_O;
rates.OH.production(OH_plength+5) = kout.NO_HO2;
rates.OH.production(OH_plength+6) = kout.H2_O1D;
rates.OH.production(OH_plength+7) = kout.CH4_O1D;
% rates.OH.production(OH_plength+8) = kout.H2O2_O;
% rates.OH.production(OH_plength+9) = kout.H2_O;
% rates.OH.production(OH_plength+10) = kout.H_HO2a*2;
%10,11,12,13


%% HO2
   
% - r276*S*OH  - r279*SO*OH  - r286*M*SO2*OH    

HO2_plength = length(rates.HO2.production);
HO2_dlength = length(rates.HO2.destruction);

rates.HO2.destruction(HO2_dlength+1) = kout.HO2_O3;
rates.HO2.destruction(HO2_dlength+2) = kout.HO2_O;
rates.HO2.destruction(HO2_dlength+3) = kout.NO_HO2;
rates.HO2.destruction(HO2_dlength+4) = kout.OH_HO2;
rates.HO2.destruction(HO2_dlength+5) = kout.CLO_HO2;
rates.HO2.destruction(HO2_dlength+6) = kout.HO2_HO2;
rates.HO2.destruction(HO2_dlength+7) = kout.NO2_HO2_M;
rates.HO2.destruction(HO2_dlength+8) = kout.NO3_HO2;

% rates.HO2.destruction(HO2_dlength+7) = kout.H_HO2a;
% rates.HO2.destruction(HO2_dlength+8) = kout.H_HO2b;
% rates.HO2.destruction(HO2_dlength+9) = kout.H_HO2c;

rates.HO2.production(HO2_plength+1) = kout.H_O2_M;
rates.HO2.production(HO2_plength+2) = kout.OH_O3;
rates.HO2.production(HO2_plength+3) = kout.OH_H2O2;
% rates.HO2.production(HO2_plength+4) = kout.H2O2_O;
% rates.HO2.production(HO2_dlength+5) = kout.CH3BR_OH;
% rates.HO2.production(HO2_dlength+6) = kout.CH3BR_CL;

end