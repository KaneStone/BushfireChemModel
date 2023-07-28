function rates = gasphaserates(inputs,step,variables,dayaverage,atmosphere,i,rates,photo,climScaleFactor,SZAdiff,RN)

    if RN
        timeind = 1;
    else
        timeind = i;
    end

    
%   first need to calculate atomic oxygen
%    rates.O.production
% 2*j1*O2  + j3*O3  + j5*NO  + j6*NO2  + j8*N2O5  + j10*NO3  + j19*H2O  + j22*CLO  + j23*OCLO  + j30*BRO
%                + j53*CO2  + .18*j55*CH4  + j83*SO2  + j84*SO3  + j86*SO  + r4*N2*O1D  + r5*O2*O1D  + r52*O2*N
%                + r277*O2*S  + r280*O2*SO  + r37*H*HO2  + r41*OH*OH  + r53*N*NO  + r54*N*NO2
%                - r1*O2*M*O  - r2*O3*O  - 2*r3*M*O*O  - r38*OH*O  - r45*H2*O  - r46*HO2*O  - r49*H2O2*O  - r57*M*NO*O
%                - r60*NO2*O  - r61*M*NO2*O  - r68*NO3*O  - r81*CLO*O  - r94*HCL*O  - r95*HOCL*O  - r98*CLONO2*O
%                - r104*BRO*O  - r114*HBR*O  - r115*HOBR*O  - r116*BRONO2*O  - r134*CH2O*O  - r274*OCS*O

%     if SZA < 90 && SZA > 88
%         day = 1;
%     elseif SZA <= 88
%         day = 1.5;
%         dayoff = 0;
%     else
%         day = 0;
%         dayoff = 1.5;
%     end
day = climScaleFactor(round(step.hour.*1./inputs.hourstep+1)); % rounding to strip stray 0 decimals
daynormaltemp = (climScaleFactor - min(climScaleFactor))./(max(climScaleFactor)-min(climScaleFactor));
daynorm = daynormaltemp(round(step.hour.*1./inputs.hourstep+1));
SZAdiffout = SZAdiff(round(step.hour.*1./inputs.hourstep+1));

% O RATES
    

%     rates.O.production(1)
% 
%      rates.O.destruction(1) = 6e-34.*(atmosphere.atLevel.T(step.doy)./300).^-2.4.*...
%          atmosphere.atLevel.O2.nd(step.doy).*variables.O(timeind).*atmosphere.atLevel.M(step.doy).*day; %O2_O_M 
%      rates.O.destruction(2) = 8.00e-12.*exp(-2060./atmosphere.atLevel.T(step.doy)).*variables.O(timeind).*variables.O3(timeind).*day;
%      rates.O.destruction(3) = 1.8e-11.*exp(180./atmosphere.atLevel.T(step.doy)).*variables.O(timeind).*atmosphere.atLevel.OH.nd(step.doy).*day;
%      rates.O.destruction(4) = 3.00e-12.*exp(200./atmosphere.atLevel.T(step.doy)).*variables.O(timeind).*atmosphere.atLevel.HO2.nd(step.doy).*day;
%     test1 = 6e-34.*(atmosphere.atLevel.T(step.doy)./300).^-2.4.*...
%         atmosphere.atLevel.O2.nd(step.doy).*sum(rates.O.production).*atmosphere.atLevel.M(step.doy);
%     rates.O.destruction(2) = 8.00e-12.*exp(-2060./atmosphere.atLevel.T(step.doy)).*variables.O(timeind).*variables.O3(timeind);
%     test = 8.00e-12.*exp(-2060./atmosphere.atLevel.T(step.doy)).*sum(rates.O.production).*variables.O3(timeind)
%     
%     sum(rates.O.production)
    
kO1D_N2 = 2.15e-11.*exp(110./atmosphere.atLevel.T(step.doy)); %O1D_N2
kO1D_O2 = 3.30e-11.*exp(55./atmosphere.atLevel.T(step.doy)); %O1D_O2
O1D = photo(2).*variables.O3(timeind)./(kO1D_N2.*atmosphere.atLevel.N2.nd(step.doy) + kO1D_O2.*atmosphere.atLevel.O2.nd(step.doy));
%O1D = O1D*5000;



%% O3 RATES
    rates.O3.production(1)= 6e-34.*(atmosphere.atLevel.T(step.doy)./300).^-2.4.*...
        atmosphere.atLevel.O2.nd(step.doy).*atmosphere.atLevel.O.nd(step.doy).*atmosphere.atLevel.M(step.doy).*day; %O2_O_M 
% loss rates
%     if step.hour > 6 && step.hour < 18
%         rates.O3.destruction(2) = 0;
%     else
        rates.O3.destruction(2) = 8e-12.*exp(-2060./atmosphere.atLevel.T(step.doy)).*variables.O3(timeind).*atmosphere.atLevel.O.nd(step.doy).*day; %O_O3 
%     end
    %rates.O3.destruction(3) = 1e-10.*variables.O3(timeind).*atmosphere.atLevel.O1D.nd(step.doy);%O1D_O3 
    rates.O3.destruction(3) = 1e-10.*variables.O3(timeind).*O1D;%O1D_O3 
    rates.O3.destruction(10) = 1.40e-10.*exp(-470./atmosphere.atLevel.T(step.doy)).*variables.O3(timeind).*atmosphere.atLevel.H.nd(step.doy).*day;  %dH_O3 
    rates.O3.destruction(4) = 1.70e-12.*exp(-940./atmosphere.atLevel.T(step.doy)).*variables.O3(timeind).*atmosphere.atLevel.OH.nd(step.doy).*day; %OH_O3 
    rates.O3.destruction(5) = 1.0e-14.*exp(-490./atmosphere.atLevel.T(step.doy)).*variables.O3(timeind).*atmosphere.atLevel.HO2.nd(step.doy).*day; %HO2_O3 
    rates.O3.destruction(6) = 3e-12.*exp(-1500./atmosphere.atLevel.T(step.doy)).*variables.O3(timeind).*atmosphere.atLevel.NO.nd(step.doy).*day; %NO_O3 
    rates.O3.destruction(7) = 1.2e-13.*exp(-2450./atmosphere.atLevel.T(step.doy)).*variables.O3(timeind).*atmosphere.atLevel.NO2.nd(step.doy); %NO2_O3 
    rates.O3.destruction(8) = 2.30e-11.*exp(-200./atmosphere.atLevel.T(step.doy)).*variables.O3(timeind).*atmosphere.atLevel.CL.nd(step.doy).*day; %CL_O3
    %rates.O3.destruction(8) = 2.30e-11.*exp(-200./atmosphere.atLevel.T(step.doy)).*variables.O3(timeind).*dayaverage.CL(step.doy).*day; %CL_O3
    rates.O3.destruction(9) = 1.6e-11.*exp(-780./atmosphere.atLevel.T(step.doy)).*variables.O3(timeind).*atmosphere.atLevel.BR.nd(step.doy); %BR_O3
    
%% CLONO2 rates

% termolecular
k0=1.80e-31.*(300./(atmosphere.atLevel.T(step.doy))).^3.40; % low pressure limit
ki=1.50e-11.*(300./(atmosphere.atLevel.T(step.doy))).^1.90; % high pressure limit
x = .6;

xpo = k0.*atmosphere.atLevel.M(step.doy)./ki;
rate = k0.*atmosphere.atLevel.M(step.doy)./(1+xpo);
xpo = log10(xpo);
xpo = 1./(1+xpo.^2);
k2clono2 = rate.*x.^xpo;

if i == 280
    a = 1
end

%rates.CLONO2.production(1) = k2clono2.*atmosphere.atLevel.CLO.nd(step.doy).*atmosphere.atLevel.NO2.nd(step.doy).*day;
rates.CLONO2.production(1) = k2clono2.*variables.CLO(timeind).*atmosphere.atLevel.NO2.nd(step.doy);

% gas phase
CLONO2_dlength = length(rates.CLONO2.destruction);
rates.CLONO2.destruction(CLONO2_dlength+1) = 3.6e-12.*exp(-840./atmosphere.atLevel.T(step.doy)).*variables.CLONO2(timeind).*atmosphere.atLevel.O.nd(step.doy).*day;
rates.CLONO2.destruction(CLONO2_dlength+2) = 1.2e-12.*exp(-330./atmosphere.atLevel.T(step.doy)).*variables.CLONO2(timeind).*atmosphere.atLevel.OH.nd(step.doy).*day;
%rates.CLONO2.destruction(CLONO2_dlength+3) = 6.5e-12.*exp(-135./atmosphere.atLevel.T(step.doy)).*variables.CLONO2(timeind).*dayaverage.CL(step.doy).*day;
rates.CLONO2.destruction(CLONO2_dlength+3) = 6.5e-12.*exp(-135./atmosphere.atLevel.T(step.doy)).*variables.CLONO2(timeind).*atmosphere.atLevel.CL.nd(step.doy).*day;

%% HCL
%  r75*CL*H2  + r76*CL*H2O2  + r77*CL*HO2  + r79*CL*CH2O  + r80*CL*CH4  + r83*CLO*OH  + r96*HOCL*CL
%                  + 2*r117*CH3CL*CL  + r122*CH3BR*CL  + r127*CH2BR2*CL  + r128*CHBR3*CL  + r146*C2H6*CL
%                  - j26*HCL  - r30*O1D*HCL  - r93*OH*HCL  - r94*O*HCL  - r292*CLONO2*HCL  - r293*HOCL*HCL
%                  - r294*HOBR*HCL  - r297*CLONO2*HCL  - r298*HOCL*HCL  - r303*CLONO2*HCL  - r304*HOCL*HCL
%                  - r305*HOBR*HCL

rates.HCL.production(1) = 3.05e-11*exp(-2270./atmosphere.atLevel.T(step.doy)).*atmosphere.atLevel.H2.nd(step.doy).*atmosphere.atLevel.CL.nd(step.doy).*day;
%rates.HCL.production(1) = 3.05e-11*exp(-2270./atmosphere.atLevel.T(step.doy)).*atmosphere.atLevel.H2.nd(step.doy).*dayaverage.CL(step.doy).*day;
rates.HCL.production(2) = 1.1e-11*exp(-980./atmosphere.atLevel.T(step.doy)).*atmosphere.atLevel.H2O2.nd(step.doy).*atmosphere.atLevel.CL.nd(step.doy).*day;
rates.HCL.production(3) = 1.4e-11*exp(270./atmosphere.atLevel.T(step.doy)).*atmosphere.atLevel.HO2.nd(step.doy).*atmosphere.atLevel.CL.nd(step.doy).*day;
rates.HCL.production(4) = 7.30e-12*exp(-1280./atmosphere.atLevel.T(step.doy)).*atmosphere.atLevel.CH4.nd(step.doy).*atmosphere.atLevel.CL.nd(step.doy).*day;
rates.HCL.production(5) = 6.00e-13*exp(230./atmosphere.atLevel.T(step.doy)).*atmosphere.atLevel.CLO.nd(step.doy).*atmosphere.atLevel.OH.nd(step.doy).*day;
rates.HCL.production(6) = 3.40e-12*exp(-130./atmosphere.atLevel.T(step.doy)).*variables.HOCL(timeind).*atmosphere.atLevel.CL.nd(step.doy).*day;
rates.HCL.production(6) = 3.40e-12*exp(-130./atmosphere.atLevel.T(step.doy)).*variables.HOCL(timeind).*atmosphere.atLevel.CL.nd(step.doy).*day;
%rates.HCL.production(7) = 2.*2.17e-11*exp(-1130./atmosphere.atLevel.T(step.doy)).*atmosphere.atLevel.CH3CL.nd(step.doy).*dayaverage.CL(step.doy).*day;

HCL_dlength = length(rates.HCL.destruction);
rates.HCL.destruction(HCL_dlength+1) = 1.5e-10.*O1D.*variables.HCL(timeind);
rates.HCL.destruction(HCL_dlength+2) = 1.8e-12.*exp(-250./atmosphere.atLevel.T(step.doy)).*atmosphere.atLevel.OH.nd(step.doy).*variables.HCL(timeind).*day;
rates.HCL.destruction(HCL_dlength+3) = 1.0e-11.*exp(-3300./atmosphere.atLevel.T(step.doy)).*atmosphere.atLevel.O.nd(step.doy).*variables.HCL(timeind).*day;


%% CLO
% j23*OCLO  + j28*CLONO2  + r92*M*CL2O2  + r92*M*CL2O2  + r74*CL*O3  + r78*CL*HO2  + r95*HOCL*O
%                  + r96*HOCL*CL  + r97*HOCL*OH  + r98*CLONO2*O  + r285*SO*OCLO
%                  - j22*CLO  - r81*O*CLO  - r82*OH*CLO  - r83*OH*CLO  - r84*HO2*CLO  - r85*CH3O2*CLO  - r86*NO*CLO
%                  - r87*M*NO2*CLO  - 2*r88*CLO*CLO  - 2*r89*CLO*CLO  - 2*r90*CLO*CLO  - 2*r91*M*CLO*CLO  - r109*BRO*CLO
%                  - r110*BRO*CLO  - r111*BRO*CLO  - r283*SO*CLO

CLO_plength = length(rates.CLO.production);
CLO_dlength = length(rates.CLO.destruction);

% termolecular
k0=1.90e-32.*(300./(atmosphere.atLevel.T(step.doy))).^3.6; % low pressure limit
ki=3.7e-12.*(300./(atmosphere.atLevel.T(step.doy))).^1.6; % high pressure limit
x = .6;

xpo = k0.*atmosphere.atLevel.M(step.doy)./ki;
rate = k0.*atmosphere.atLevel.M(step.doy)./(1+xpo);
xpo = log10(xpo);
xpo = 1./(1+xpo.^2);
k2clo = rate.*x.^xpo;

rates.CLO.destruction(CLO_dlength+1) = k2clo.*variables.CLO(timeind).*variables.CLO(timeind);

if i == 2000
    a = 1
end
%rates.CLO.production(HCL_plength+1) = 2.* 
%rates.CLO.production(CLO_plength+1) = 2.3e-11.*exp(-200./atmosphere.atLevel.T(step.doy)).*atmosphere.atLevel.O3.nd(step.doy).*atmosphere.atLevel.CL.nd(step.doy).*day;
rates.CLO.production(CLO_plength+1) = 2.3e-11.*exp(-200./atmosphere.atLevel.T(step.doy)).*variables.O3(timeind).*atmosphere.atLevel.CL.nd(step.doy).*day;
%rates.CLO.production(CLO_plength+1) = 2.3e-11.*exp(-200./atmosphere.atLevel.T(step.doy)).*variables.O3(timeind).*dayaverage.CL(step.doy).*day;
rates.CLO.production(CLO_plength+2) = 3.60e-11*exp(-375./atmosphere.atLevel.T(step.doy)).*atmosphere.atLevel.HO2.nd(step.doy).*atmosphere.atLevel.CL.nd(step.doy).*day;
%rates.CLO.production(CLO_plength+2) = 3.60e-11*exp(-375./atmosphere.atLevel.T(step.doy)).*atmosphere.atLevel.HO2.nd(step.doy).*dayaverage.CL(step.doy).*day;
rates.CLO.production(CLO_plength+3) = 1.70e-13.*variables.HOCL(timeind).*atmosphere.atLevel.O.nd(step.doy).*day;
%rates.CLO.production(CLO_plength+4) = 3.40e-12.*exp(-130./atmosphere.atLevel.T(step.doy)).*variables.HOCL(timeind).*atmosphere.atLevel.CL.nd(step.doy).*day;
rates.CLO.production(CLO_plength+4) = 3.40e-12.*exp(-130./atmosphere.atLevel.T(step.doy)).*variables.HOCL(timeind).*atmosphere.atLevel.CL.nd(step.doy).*day;
rates.CLO.production(CLO_plength+5) = 3.00e-12.*exp(-500./atmosphere.atLevel.T(step.doy)).*variables.HOCL(timeind).*atmosphere.atLevel.OH.nd(step.doy).*day;
rates.CLO.production(CLO_plength+6) = 3.60e-12.*exp(-840./atmosphere.atLevel.T(step.doy)).*variables.CLONO2(timeind).*atmosphere.atLevel.O.nd(step.doy).*day;
cl2o2_ko = 2.16e-27.*exp(8537./atmosphere.atLevel.T(step.doy));
%rates.CLO.production(CLO_plength+7) = rates.CLO.destruction(CLO_dlength+1)./ko; % ko is the thermal equilibrium constant equation (JPL 15-10 page 3-1)
rates.CLO.production(CLO_plength+7) = k2clo.*atmosphere.atLevel.CL2O2.nd(step.doy)./cl2o2_ko.*day.*2; % ko is the thermal equilibrium constant equation (JPL 15-10 page 3-1)

rates.CLO.destruction(CLO_dlength+2) = 2.80e-11*exp(85./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*atmosphere.atLevel.O.nd(step.doy).*day;
rates.CLO.destruction(CLO_dlength+3) = 7.40e-12*exp(260./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*atmosphere.atLevel.OH.nd(step.doy).*day;
rates.CLO.destruction(CLO_dlength+4) = 6.00e-13*exp(230./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*atmosphere.atLevel.OH.nd(step.doy).*day;
rates.CLO.destruction(CLO_dlength+5) = 2.60e-12*exp(290./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*atmosphere.atLevel.HO2.nd(step.doy).*day;
rates.CLO.destruction(CLO_dlength+6) = 6.40e-12*exp(290./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*atmosphere.atLevel.NO.nd(step.doy).*day;
%rates.CLO.destruction(CLO_dlength+7) = rates.CLONO2.production(1);
rates.CLO.destruction(CLO_dlength+7) = k2clono2.*variables.CLO(timeind).*atmosphere.atLevel.NO2.nd(step.doy);
rates.CLO.destruction(CLO_dlength+8) = 3.0e-11*exp(-2450./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*variables.CLO(timeind);
rates.CLO.destruction(CLO_dlength+9) = 1.0e-12*exp(-1590./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*variables.CLO(timeind);
rates.CLO.destruction(CLO_dlength+10) = 3.5e-13*exp(-1370./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*variables.CLO(timeind);

% lifetime of ClO

lifetime = 1./((rates.CLO.destruction(CLO_dlength+7) + rates.CLO.destruction(CLO_dlength+6))./variables.CLO(timeind));


%% CL2  d(CL2)/dt = r89*CLO*CLO  + r100*CLONO2*CL  + r292*CLONO2*HCL  + r293*HOCL*HCL  + r297*CLONO2*HCL  + r298*HOCL*HCL
                % + r303*CLONO2*HCL  + r304*HOCL*HCL
                % - j21*CL2
CL2_plength = 0;
CL2_dlength = 1;

rates.CL2.production(CL2_plength+1) = 1.00e-12.*exp(-1590./atmosphere.atLevel.T(step.doy)).*2.*variables.CLO(timeind);
rates.CL2.production(CL2_plength+1) = 6.50e-12.*exp(135./atmosphere.atLevel.T(step.doy)).*variables.CLONO2(timeind).*atmosphere.atLevel.CL.nd(step.doy).*day;
%rates.CL2.production(CL2_plength+1) = 6.50e-12.*exp(135./atmosphere.atLevel.T(step.doy)).*variables.CLONO2(timeind).*dayaverage.CL(step.doy).*day;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

% if i == 1
%     a = 1;
% %     lifetime = 1./(sum(rates.CL.destruction)./variables.CL(timeind));
% end
% 
% d2 = 2.30e-11.*exp(-200./atmosphere.atLevel.T(step.doy)).*variables.O3(timeind);
% d3 = 2.80e-11.*exp(85./atmosphere.atLevel.T(step.doy)).*atmosphere.atLevel.O.nd(step.doy).*day;
% d4 = 6.40e-12.*exp(290./atmosphere.atLevel.T(step.doy)).*atmosphere.atLevel.NO.nd(step.doy).*day;
% 
% CLtest = d2./(d3+d4+(rates.CLO.destruction(1)+rates.CLO.destruction(2))./variables.CLO(timeind));
% if isnan(CLtest) || CLtest == 0
%     rates.CL.production(1) = 0;
% else
%     rates.CL.production(1) = variables.CLO(timeind)./CLtest;
%     if SZAdiffout <= 0 && rates.CL.production(1) < variables.CL(timeind)
%         rates.CL.production(1) = variables.CL(timeind).*daynorm;    
% %     elseif SZAdiffout >= 0 && rates.CL.production(1) > variables.CL(timeind)
% %         rates.CL.production(1) = variables.CL(timeind).*daynorm;  
% %     end
%     end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%d3/*O + d4*NO + Jclo

% CL_plength = length(rates.CL.production); 
% CL_dlength = 0;
% % if i == 500
% %     lifetime = 1./(sum(rates.CL.destruction)./variables.CL(timeind));
% % end
% %rates.CL.production(CL_plength+1) = 1.00e-12.*exp(-1590./atmosphere.atLevel.T(step.doy)).*2.*variables.CLO(timeind);
% rates.CL.production(CL_plength+1) = 1.50e-10.*O1D.*variables.HCL(timeind);
% rates.CL.production(CL_plength+2) = 2.80e-11.*exp(85./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*atmosphere.atLevel.O.nd(step.doy).*day;
% rates.CL.production(CL_plength+3) = 7.40e-12.*exp(270./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*atmosphere.atLevel.OH.nd(step.doy).*day;
% rates.CL.production(CL_plength+4) = 3.30e-12.*exp(-115./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*atmosphere.atLevel.CH3O2.nd(step.doy);
% rates.CL.production(CL_plength+5) = 6.40e-12.*exp(290./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*atmosphere.atLevel.NO.nd(step.doy).*day;
% rates.CL.production(CL_plength+6) = 3.00e-11.*exp(-2450./atmosphere.atLevel.T(step.doy)).*2.*variables.CLO(timeind).*variables.CLO(timeind);
% rates.CL.production(CL_plength+7) = 3.50e-13.*exp(-1370./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*variables.CLO(timeind);
% rates.CL.production(CL_plength+8) = 1.80e-12.*exp(-250./atmosphere.atLevel.T(step.doy)).*variables.HCL(timeind).*atmosphere.atLevel.OH.nd(step.doy).*day;
% rates.CL.production(CL_plength+9) = 1.00e-11.*exp(-3300./atmosphere.atLevel.T(step.doy)).*variables.HCL(timeind).*atmosphere.atLevel.O.nd(step.doy).*day;
% rates.CL.production(CL_plength+10) = 2.30e-12.*exp(260./atmosphere.atLevel.T(step.doy)).*variables.CLO(timeind).*atmosphere.atLevel.BRO.nd(step.doy).*day;
% rates.CL.production(CL_plength+11) = 2.40e-12.*exp(-1250./atmosphere.atLevel.T(step.doy)).*atmosphere.atLevel.OH.nd(step.doy).*atmosphere.atLevel.CH3CL.nd(step.doy).*day;
% rates.CL.production(CL_plength+12) = 1.64e-12.*exp(-1520./atmosphere.atLevel.T(step.doy)).*3.*atmosphere.atLevel.OH.nd(step.doy).*atmosphere.atLevel.CH3CCL3.nd(step.doy).*day;
% rates.CL.production(CL_plength+13) = 2.80e-11.*variables.CLO(timeind).*atmosphere.atLevel.SO.nd(step.doy);
% 
% rates.CL.destruction(CL_dlength+1) = 2.30e-11.*exp(-200./atmosphere.atLevel.T(step.doy)).*variables.O3(timeind).*variables.CL(timeind);
% rates.CL.destruction(CL_dlength+2) = 3.05e-11.*exp(-2270./atmosphere.atLevel.T(step.doy)).*variables.CL(timeind).*atmosphere.atLevel.H2.nd(step.doy);
% rates.CL.destruction(CL_dlength+3) = 1.10e-11.*exp(-980./atmosphere.atLevel.T(step.doy)).*variables.CL(timeind).*atmosphere.atLevel.H2O2.nd(step.doy);
% rates.CL.destruction(CL_dlength+4) = 1.40e-11.*exp(270./atmosphere.atLevel.T(step.doy)).*variables.CL(timeind).*atmosphere.atLevel.HO2.nd(step.doy).*day;
% rates.CL.destruction(CL_dlength+5) = 3.60e-11.*exp(-375./atmosphere.atLevel.T(step.doy)).*variables.CL(timeind).*atmosphere.atLevel.HO2.nd(step.doy).*day;
% rates.CL.destruction(CL_dlength+6) = 7.30e-12.*exp(-1280./atmosphere.atLevel.T(step.doy)).*variables.CL(timeind).*atmosphere.atLevel.CH4.nd(step.doy);
% rates.CL.destruction(CL_dlength+7) = 3.40e-12.*exp(-130./atmosphere.atLevel.T(step.doy)).*variables.CL(timeind).*variables.HOCL(timeind);
% rates.CL.destruction(CL_dlength+8) = 6.50e-12.*exp(135./atmosphere.atLevel.T(step.doy)).*variables.CL(timeind).*variables.CLONO2(timeind);
% rates.CL.destruction(CL_dlength+9) = 2.17e-11.*exp(-1130./atmosphere.atLevel.T(step.doy)).*variables.CL(timeind).*atmosphere.atLevel.CH3CL.nd(step.doy);
% 
% 
% if i == 4000
%     lifetime = 1./(sum(rates.CL.destruction)./variables.CL(timeind));
% end

%rates.CL.destruction(CL_dlength+10) = 8.10e-11.*exp(-30./atmosphere.atLevel.T(step.doy)).*variables.CL(timeind).*atmosphere.atLevel.CH2O.nd(step.doy);
% rates.CL.destruction(CL_dlength+11) = 1.4e-11.*exp(-1030./atmosphere.atLevel.T(step.doy)).*variables.CL(timeind).*atmosphere.atLevel.CH3BR.nd(step.doy);
% rates.CL.destruction(CL_dlength+12) = 1.4e-11.*exp(-1030./atmosphere.atLevel.T(step.doy)).*variables.CL(timeind).*atmosphere.atLevel.CH3BR.nd(step.doy);
%% CL2O2 r91*M*CLO*CLO
          %         - j24*CL2O2  - r92*M*CL2O2
CL2O2_dlength = length(rates.CL2O2.destruction); 
CL2O2_plength = 0;
rates.CL2O2.production(CL2O2_plength+1) = rates.CLO.destruction(CLO_dlength+1);

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

if i == 500
    %HOCLlifetime = 1./(sum(rates.HOCL.destruction)./variables.HOCL(timeind))
end

d33 = 2.60e-12*exp(290./atmosphere.atLevel.T(step.doy)).*atmosphere.atLevel.HO2.nd(step.doy).*day;
d34 = 3.00e-12.*exp(-500./atmosphere.atLevel.T(step.doy)).*atmosphere.atLevel.OH.nd(step.doy).*day;
if day ~= 0
    rates.CLOtest.production = variables.HOCL(timeind)./(d33./(rates.HOCL.destruction(1)./variables.HOCL(timeind)+d34));
else
    rates.CLOtest.production = 0;
end

%% I should do CLO    
    
%     if SZA < 90
%         rates.O3.destruction = rates.O3.destruction.*0;
%     else
%         rates.O3.destruction = rates.O3.destruction.*2;
%     end
    
    %O3diff = sum(rates.O3.production).*60*60*24 - sum(rates.O3.destruction).*60*60*24;
    %O3test(timeind) = O3test(step.doy) + O3diff;


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