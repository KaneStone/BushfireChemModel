function rates = gasphaserates(inputs,step,variables,dayaverage,atmosphere,i,rates,photo,climScaleFactor,SZAdiff,RN)

    if RN
        timeind = 1;
    else
        timeind = i;
    end

    
kout = gasphaseequations(atmosphere,variables,photo,timeind);    
    
%   first need to calculate atomic oxygen
%    rates.O.production
% 2*j1*O2  + j3*O3  + j5*NO  + j6*NO2  + j8*N2O5  + j10*NO3  + j19*H2O  + j22*CLO  + j23*OCLO  + j30*BRO
%                + j53*CO2  + .18*j55*CH4  + j83*SO2  + j84*SO3  + j86*SO  + r4*N2*O1D  + r5*O2*O1D  + r52*O2*N
%                + r277*O2*S  + r280*O2*SO  + r37*H*HO2  + r41*OH*OH  + r53*N*NO  + r54*N*NO2
%                - r1*O2*M*O  - r2*O3*O  - 2*r3*M*O*O  - r38*OH*O  - r45*H2*O  - r46*HO2*O  - r49*H2O2*O  - r57*M*NO*O
%                - r60*NO2*O  - r61*M*NO2*O  - r68*NO3*O  - r81*CLO*O  - r94*HCL*O  - r95*HOCL*O  - r98*CLONO2*O
%                - r104*BRO*O  - r114*HBR*O  - r115*HOBR*O  - r116*BRONO2*O  - r134*CH2O*O  - r274*OCS*O

day = climScaleFactor(round(step.hour.*1./inputs.hourstep+1)); % rounding to strip stray 0 decimals
daynormaltemp = (climScaleFactor - min(climScaleFactor))./(max(climScaleFactor)-min(climScaleFactor));
daynorm = daynormaltemp(round(step.hour.*1./inputs.hourstep+1));
SZAdiffout = SZAdiff(round(step.hour.*1./inputs.hourstep+1));
%variables.CL(timeind) = atmosphere.atLevel.CL.nd(step.doy).*day;

% kO1D_N2 = 2.15e-11.*exp(110./atmosphere.atLevel.T(step.doy)); %O1D_N2
% kO1D_O2 = 3.30e-11.*exp(55./atmosphere.atLevel.T(step.doy)); %O1D_O2
% O1D = photo(2).*variables.O3(timeind)./(kO1D_N2.*atmosphere.atLevel.N2.nd(step.doy) + kO1D_O2.*atmosphere.atLevel.O2.nd(step.doy));

%% O3 RATES
O3_dlength = length(rates.O3.destruction);

%production
rates.O3.production(1) = kout.O2_O_M;

%destruction
rates.O3.destruction(O3_dlength+1) = kout.O2_O_M;
rates.O3.production(O3_dlength+2) = kout.O3_O;
rates.O3.production(O3_dlength+3) = kout.O3_H;
rates.O3.production(O3_dlength+4) = kout.O3_OH;
rates.O3.production(O3_dlength+5) = kout.O3_HO2;
rates.O3.production(O3_dlength+6) = kout.O3_NO;
rates.O3.production(O3_dlength+7) = kout.O3_NO2;
rates.O3.production(O3_dlength+8) = kout.O3_CL;
rates.O3.production(O3_dlength+9) = kout.O3_BR;
    
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
rates.HCL.production(8) = kout.CL_CH3CL*2;
rates.HCL.production(9) = kout.CL_CH3BR;
rates.HCL.production(10) = kout.CL_CH2BR2;
rates.HCL.production(11) = kout.CL_CHBR3;
rates.HCL.production(12) = kout.CL_C2H6;

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

% termolecular
%k0=1.90e-32.*(300./(atmosphere.atLevel.T(step.doy))).^3.6; % low pressure limit
%ki=3.7e-12.*(300./(atmosphere.atLevel.T(step.doy))).^1.6; % high pressure limit
k0=1.60e-32.*(300./(atmosphere.atLevel.T(step.doy))).^4.5; % low pressure limit
ki=3e-12.*(300./(atmosphere.atLevel.T(step.doy))).^2; % high pressure limit
x = .6;
xpo = k0.*atmosphere.atLevel.M(step.doy)./ki;
rate = k0.*atmosphere.atLevel.M(step.doy)./(1+xpo);
xpo = log10(xpo);
xpo = 1./(1+xpo.^2);
k2clo = rate.*x.^xpo;

rates.CLO.destruction(CLO_dlength+1) = k2clo.*variables.CLO(timeind).*variables.CLO(timeind).*100;
rates.CLO.production(CLO_plength+1) = 2.3e-11.*exp(-200./atmosphere.atLevel.T(step.doy)).*variables.O3(timeind).*variables.CL(timeind);
rates.CLO.production(CLO_plength+2) = 3.60e-11*exp(-375./atmosphere.atLevel.T(step.doy)).*atmosphere.atLevel.HO2.nd(step.doy).*variables.CL(timeind).*day;
rates.CLO.production(CLO_plength+3) = 1.70e-13.*variables.HOCL(timeind).*atmosphere.atLevel.O.nd(step.doy).*day;
rates.CLO.production(CLO_plength+4) = 3.40e-12.*exp(-130./atmosphere.atLevel.T(step.doy)).*variables.HOCL(timeind).*variables.CL(timeind);
rates.CLO.production(CLO_plength+5) = 3.00e-12.*exp(-500./atmosphere.atLevel.T(step.doy)).*variables.HOCL(timeind).*atmosphere.atLevel.OH.nd(step.doy).*day;
rates.CLO.production(CLO_plength+6) = 3.60e-12.*exp(-840./atmosphere.atLevel.T(step.doy)).*variables.CLONO2(timeind).*atmosphere.atLevel.O.nd(step.doy).*day;
cl2o2_ko = 2.16e-27.*exp(8537./atmosphere.atLevel.T(step.doy));
rates.CLO.production(CLO_plength+7) = k2clo.*atmosphere.atLevel.CL2O2.nd(step.doy)./cl2o2_ko.*day.*2; % ko is the thermal equilibrium constant equation (JPL 15-10 page 3-1)

rates.CLO.destruction(CLO_dlength+2) = 2.80e-11*exp(85./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*atmosphere.atLevel.O.nd(step.doy).*day;
rates.CLO.destruction(CLO_dlength+3) = 7.40e-12*exp(260./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*atmosphere.atLevel.OH.nd(step.doy).*day;
rates.CLO.destruction(CLO_dlength+4) = 6.00e-13*exp(230./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*atmosphere.atLevel.OH.nd(step.doy).*day;
rates.CLO.destruction(CLO_dlength+5) = 2.60e-12*exp(290./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*atmosphere.atLevel.HO2.nd(step.doy).*day;
rates.CLO.destruction(CLO_dlength+6) = 6.40e-12*exp(290./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*atmosphere.atLevel.NO.nd(step.doy).*day;
rates.CLO.destruction(CLO_dlength+7) = rates.CLONO2.production(1);
rates.CLO.destruction(CLO_dlength+8) = 3.0e-11*exp(-2450./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*variables.CLO(timeind).*2;
rates.CLO.destruction(CLO_dlength+9) = 1.0e-12*exp(-1590./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*variables.CLO(timeind).*2;
rates.CLO.destruction(CLO_dlength+10) = 3.5e-13*exp(-1370./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*variables.CLO(timeind).*2;
rates.CLO.destruction(CLO_dlength+11) = 9.5e-13*exp(550./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*atmosphere.atLevel.BRO.nd(step.doy).*day;
rates.CLO.destruction(CLO_dlength+12) = 2.3e-12*exp(260./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*atmosphere.atLevel.BRO.nd(step.doy).*day;
rates.CLO.destruction(CLO_dlength+13) = 4.1e-13*exp(290./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*atmosphere.atLevel.BRO.nd(step.doy).*day;
rates.CLO.destruction(CLO_dlength+14) = 2.8e-11.*variables.CLO(timeind).*atmosphere.atLevel.SO.nd(step.doy).*day;
rates.CLO.destruction(CLO_dlength+15) = 3.2e-12.*exp(-115./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*atmosphere.atLevel.CH3O2.nd(step.doy);
% lifetime of ClO

lifetime = 1./((rates.CLO.destruction(CLO_dlength+7) + rates.CLO.destruction(CLO_dlength+6))./variables.CLO(timeind));


%% CL2  d(CL2)/dt = r89*CLO*CLO  + r100*CLONO2*CL  + r292*CLONO2*HCL  + r293*HOCL*HCL  + r297*CLONO2*HCL  + r298*HOCL*HCL
                % + r303*CLONO2*HCL  + r304*HOCL*HCL
                % - j21*CL2
CL2_plength = 0;
CL2_dlength = 1;

rates.CL2.production(CL2_plength+1) = 1.00e-12.*exp(-1590./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).^2;
rates.CL2.production(CL2_plength+1) = 6.50e-12.*exp(135./atmosphere.atLevel.T(step.doy)).*variables.CLONO2(timeind).*variables.CL(timeind);

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

rates.CL.production(CL_plength+1) = 1.50e-10.*O1D.*variables.HCL(timeind);
rates.CL.production(CL_plength+2) = 2.80e-11.*exp(85./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*atmosphere.atLevel.O.nd(step.doy).*day;
rates.CL.production(CL_plength+3) = 7.40e-12.*exp(270./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*atmosphere.atLevel.OH.nd(step.doy).*day;
rates.CL.production(CL_plength+4) = 3.30e-12.*exp(-115./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*atmosphere.atLevel.CH3O2.nd(step.doy);
rates.CL.production(CL_plength+5) = 6.40e-12.*exp(290./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*atmosphere.atLevel.NO.nd(step.doy).*day;
rates.CL.production(CL_plength+6) = 3.00e-11.*exp(-2450./atmosphere.atLevel.T(step.doy)).*2.*variables.CLO(timeind).*variables.CLO(timeind);
rates.CL.production(CL_plength+7) = 3.50e-13.*exp(-1370./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*variables.CLO(timeind);
rates.CL.production(CL_plength+8) = 1.80e-12.*exp(-250./atmosphere.atLevel.T(step.doy)).*variables.HCL(timeind).*atmosphere.atLevel.OH.nd(step.doy).*day;
rates.CL.production(CL_plength+9) = 1.00e-11.*exp(-3300./atmosphere.atLevel.T(step.doy)).*variables.HCL(timeind).*atmosphere.atLevel.O.nd(step.doy).*day;
rates.CL.production(CL_plength+10) = 2.30e-12.*exp(260./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*atmosphere.atLevel.BRO.nd(step.doy).*day;
rates.CL.production(CL_plength+11) = 2.40e-12.*exp(-1250./atmosphere.atLevel.T(step.doy)).*atmosphere.atLevel.OH.nd(step.doy).*atmosphere.atLevel.CH3CL.nd(step.doy).*day;
rates.CL.production(CL_plength+12) = 1.64e-12.*exp(-1520./atmosphere.atLevel.T(step.doy)).*3.*atmosphere.atLevel.OH.nd(step.doy).*atmosphere.atLevel.CH3CCL3.nd(step.doy).*day;
rates.CL.production(CL_plength+13) = 2.80e-11.*variables.CLO(timeind).*atmosphere.atLevel.SO.nd(step.doy);

rates.CL.destruction(CL_dlength+1) = 2.30e-11.*exp(-200./atmosphere.atLevel.T(step.doy)).*variables.O3(timeind).*variables.CL(timeind).*1.015; % This 1.015 term is to make the code stable. It has no physical basis
rates.CL.destruction(CL_dlength+2) = 3.05e-11.*exp(-2270./atmosphere.atLevel.T(step.doy)).*variables.CL(timeind).*atmosphere.atLevel.H2.nd(step.doy);
rates.CL.destruction(CL_dlength+3) = 1.10e-11.*exp(-980./atmosphere.atLevel.T(step.doy)).*variables.CL(timeind).*atmosphere.atLevel.H2O2.nd(step.doy);
rates.CL.destruction(CL_dlength+4) = 1.40e-11.*exp(270./atmosphere.atLevel.T(step.doy)).*variables.CL(timeind).*atmosphere.atLevel.HO2.nd(step.doy).*day;
rates.CL.destruction(CL_dlength+5) = 1.40e-11.*exp(270./atmosphere.atLevel.T(step.doy)).*variables.CL(timeind).*atmosphere.atLevel.CH2O.nd(step.doy).*day;
rates.CL.destruction(CL_dlength+6) = 3.60e-11.*exp(-375./atmosphere.atLevel.T(step.doy)).*variables.CL(timeind).*atmosphere.atLevel.HO2.nd(step.doy).*day;
rates.CL.destruction(CL_dlength+7) = 7.30e-12.*exp(-1280./atmosphere.atLevel.T(step.doy)).*variables.CL(timeind).*atmosphere.atLevel.CH4.nd(step.doy);
rates.CL.destruction(CL_dlength+8) = 3.40e-12.*exp(-130./atmosphere.atLevel.T(step.doy)).*variables.CL(timeind).*variables.HOCL(timeind);
rates.CL.destruction(CL_dlength+9) = 6.50e-12.*exp(135./atmosphere.atLevel.T(step.doy)).*variables.CL(timeind).*variables.CLONO2(timeind);
rates.CL.destruction(CL_dlength+10) = 2.17e-11.*exp(-1130./atmosphere.atLevel.T(step.doy)).*variables.CL(timeind).*atmosphere.atLevel.CH3CL.nd(step.doy).*day;
rates.CL.destruction(CL_dlength+11) = 7.30e-12.*exp(-1280./atmosphere.atLevel.T(step.doy)).*variables.CL(timeind).*atmosphere.atLevel.CH3BR.nd(step.doy);
rates.CL.destruction(CL_dlength+12) = 3.40e-12.*exp(-130./atmosphere.atLevel.T(step.doy)).*variables.CL(timeind).*atmosphere.atLevel.CH2BR2.nd(step.doy);
rates.CL.destruction(CL_dlength+13) = 6.50e-12.*exp(135./atmosphere.atLevel.T(step.doy)).*variables.CL(timeind).*atmosphere.atLevel.CHBR3.nd(step.doy);
rates.CL.destruction(CL_dlength+14) = 2.17e-11.*exp(-1130./atmosphere.atLevel.T(step.doy)).*variables.CL(timeind).*atmosphere.atLevel.C2H6.nd(step.doy);


%% CL2O2 r91*M*CLO*CLO
          %         - j24*CL2O2  - r92*M*CL2O2
CL2O2_dlength = length(rates.CL2O2.destruction); 
CL2O2_plength = 0;
rates.CL2O2.production(CL2O2_plength+1) = rates.CLO.destruction(CLO_dlength+1)./2;

rates.CL2O2.destruction(CL2O2_dlength+1) = rates.CLO.production(CLO_plength+7)./2;

%% HOCL
%  r290*CLONO2  + r296*CLONO2  + r301*CLONO2  + r84*CLO*HO2  + r99*CLONO2*OH
%                   - j25*HOCL  - r95*O*HOCL  - r96*CL*HOCL  - r97*OH*HOCL  - r293*HCL*HOCL  - r298*HCL*HOCL
%                   - r304*HCL*HOCL

HOCL_dlength = length(rates.HOCL.destruction); 
HOCL_plength = 0;
rates.HOCL.production(HOCL_plength+1) = rates.CLO.destruction(CLO_dlength+5);
rates.HOCL.production(HOCL_plength+2) = rates.CLONO2.destruction(CLONO2_dlength+2);

rates.HOCL.destruction(HOCL_dlength+1) =  rates.CLO.production(CLO_plength+3); % O * HOCL
rates.HOCL.destruction(HOCL_dlength+2) =  rates.CLO.production(CLO_plength+4); % CL * HOCL
rates.HOCL.destruction(HOCL_dlength+3) =  rates.CLO.production(CLO_plength+5); % OH * HOCL

% d33 = 2.60e-12*exp(290./atmosphere.atLevel.T(step.doy)).*atmosphere.atLevel.HO2.nd(step.doy).*day;
% d34 = 3.00e-12.*exp(-500./atmosphere.atLevel.T(step.doy)).*atmosphere.atLevel.OH.nd(step.doy).*day;
% if day ~= 0
%     rates.CLOtest.production = variables.HOCL(timeind)./(d33./(rates.HOCL.destruction(1)./variables.HOCL(timeind)+d34));
% else
%     rates.CLOtest.production = 0;
% end
% 
% %% I should do CLO    
%     



end