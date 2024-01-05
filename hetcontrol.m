function [rates] = hetcontrol(inputs,step,variables,atmosphere,rates)

    timeind = 1;

    % Shi et al
    % calculate water in partial pressure hPa
    %variables.T = 200;
    Pin = atmosphere.atLevel.P(step.doy);
    Tin = atmosphere.atLevel.T(step.doy);
    ph2o_hpa = atmosphere.dummyH2Ovmr(step.doy).*Pin; % pressure is in hPa;
    %pHCl = variables.HCl .* variables.pressure ./ 1013.25;

    wt_e0 = 18.452406985;
    wt_e1 = 3505.1578807;
    wt_e2 = 330918.55082;
    wt_e3 = 12725068.262;

    Tinv = 1./Tin;

    pzero_h2o = exp(wt_e0 - Tinv .* (wt_e1 + Tinv .* (wt_e2 - Tinv .* wt_e3)));

    % water activity
    aw = ph2o_hpa ./ pzero_h2o;

    % h2so4 molality 

    constants = awconstants(aw);

    y1 = constants.a1.*(aw.^constants.b1) + constants.c1.*aw + constants.d1;
    y2 = constants.a2.*(aw.^constants.b2) + constants.c2.*aw + constants.d2;

    m_h2so4 = y1 + ((Tin - 190) .* (y2 - y1)) / 70;

    wrk = Tin.^2;
    z1 =  .12364  - 5.6e-7.*wrk;
    z2 = -.02954  + 1.814e-7.*wrk;
    z3 =  2.343e-3 - Tin.*1.487e-6 - 1.324e-8.*wrk;
    %-----------------------------------------------------------------------
    %     ... where mol_h2so4 is molality in mol/kg
    %-----------------------------------------------------------------------
    den_h2so4 = 1 + m_h2so4.*(z1 + z2.*sqrt(m_h2so4) + z3.*m_h2so4);

    % weight percent and mole fraction
    wt = 9800 .* m_h2so4 ./ (98 * m_h2so4 + 1000);
    %wt (wt > 70) = NaN;
    %molar_h2so4 = den_h2so4.*wt./9.8; %mol/l
    %molar_h20 = den_h2so4.*(100-wt)./.18; %mol/l

    %% with hexanoic solubility
    
    %HCLvmr = 1./inputs.k*1e-6.*data(i).data.(vartemp).*data2(i).pressure./data(i).data.T;
    HCLatm = Tin./(100).*inputs.k.*variables.HCL(timeind)./1e-6 / 1013.25;
    
    CLONO2atm = Tin./(100).*inputs.k.*variables.CLONO2(timeind)./1e-6 /1013.25;
    
    
     x_h2so4 = wt ./ (wt + (100 - wt) .* 98 ./ 18); % mole fraction

    term1 = .094 - x_h2so4 .* (.61 - 1.2 .* x_h2so4);        
    term2 = (8515 - 10718 .* (x_h2so4.^.7)).*Tinv;                
    H_hcl_h2so4 = term1 .* exp( -8.68 + term2); %(mol / l / atm)         
    M_hcl = H_hcl_h2so4.*HCLatm; %(mol/l/atm * atm) = mol/l        
    molar_h2so4 = den_h2so4.*wt./9.8;
    
    switch inputs.runtype
        case 'control'
%             x_h2so4 = wt ./ (wt + (100 - wt) .* 98 ./ 18); % mole fraction
% 
%             term1 = .094 - x_h2so4 .* (.61 - 1.2 .* x_h2so4);        
%             term2 = (8515 - 10718 .* (x_h2so4.^.7)).*Tinv;                
%             H_hcl_h2so4 = term1 .* exp( -8.68 + term2); %(mol / l / atm)         
%             M_hcl_h2so4 = H_hcl_h2so4.*HCLatm; %(mol/l/atm * atm) = mol/l        
%             molar_h2so4 = den_h2so4.*wt./9.8;
        case 'solubility'
            if atmosphere.aoc_aso4_ratio(step.doy) > .7
                hex_smoothing_strat = exp(28.986 - 33.458./(Tin/100) - 18.135 .* log(Tin/100));
                ratio_hcl = 1./(1./hex_smoothing_strat - 1);
                Ka = 10^5.9; % test is meant to be 5.9        
                Mm_hex = 116.16;        
                hex_den = (-5.0083e-7 * Tin.^2 - 5.2309e-4 .* Tin + 1.1238) .* 1000; %(from Ghatee et al. 2013 [may not be applicable]) dx.doi.org/10.1021/ie3018675
                molarity = ratio_hcl .* 1./Mm_hex .* hex_den;
                H_hcl_h2so4 = molarity .* Ka;
                M_hcl = H_hcl_h2so4.*HCLatm; %(mol/l/atm * atm) = mol/l
                %molar_h2so4 = den_h2so4.*wt./9.8; 
                
            end
        case 'doublelinear'
%             so4pure = apsul/(amix + asoa + apsul + appoa)
%             aso4mix = amix - apoa - abc - adst - aslt
%             mixsulffrac = aso4mix/(amix + asoa + appoa)
            
            mixedorgsulfratio = (1-atmosphere.mixsulffrac(step.doy))/atmosphere.mixsulffrac(step.doy);
            wt_withorg = 1./(1./wt + mixedorgsulfratio./100);
            wt_org = wt_withorg*mixedorgsulfratio;
            
            term1 = 60.51;
            term2 = .095.*wt_withorg;
            wrk   = wt_withorg.*wt_withorg;
            term3 = .0077.*wrk;
            term4 = 1.61e-5.*wt_withorg.*wrk;
            term5 = (1.76 + 2.52e-4 .* wrk) .* sqrt(Tin);
            term6 = -805.89 + (253.05.*(wt_withorg.^.076));
            term7 = sqrt(Tin);
            ah_hcl    = exp( term1 - term2 + term3 - term4 - term5 + term6./term7);
            ah_hcl (ah_hcl < 1) = 1;
            wt_water = 100 - wt_withorg - wt_org;
            x_org = wt_org./(wt_org + (wt_water.*116.16./18) + (wt_withorg.*116.16./98));
            x_h2so4water = 1 - x_org;            

            
%             H_hcl_hex = molarity.*(1+Ka./ah);
%             M_hcl_hex = H_hcl_hex.*pHCl_Tbin; %(mol/l/atm * atm) = mol/l
            
           % For solubility in h2so4/water in mixed aerosol.
           x_h2so4_newwt   = wt_withorg./(wt_withorg + (wt_water.*98./18.) + (wt_org.*98./116.));

           % For solubility in pure sulfate
           x_h2so4   = wt ./ (wt + ((100 - wt)*98./18));

           % partitioning for pure sulfate (so4pure)
           term1     = .094 - x_h2so4.*(.61 - 1.2.*x_h2so4);
           term2     = (8515 - 10718.*(x_h2so4.^.7)).*Tinv;
           H_hcl_h2so4     = term1 .* exp( -8.68 + term2 );
           M_hcl_h2so4     = H_hcl_h2so4.*HCLatm.*atmosphere.so4pure(step.doy);

           % partitioning for mixed aerosols (h2so4/water fraction in mixed)
%            term1     = .094 - x_h2so4_newwt*(.61 - 1.2*x_h2so4_newwt);
%            term2     = (8515. - 10718.*(x_h2so4_newwt.^.7))*Tinv;
%            H_hcl_h2so4_newwt     = term1 * exp( -8.68 + term2 );
%            M_hcl_h2so4_newwt     = H_hcl_h2so4_newwt.*HCLatm.*x_h2so4water;
           
           term1     = .094 - x_h2so4*(.61 - 1.2*x_h2so4);
           term2     = (8515. - 10718.*(x_h2so4.^.7))*Tinv;
           H_hcl_h2so4_newwt     = term1 * exp( -8.68 + term2 );
           M_hcl_h2so4_newwt     = H_hcl_h2so4_newwt.*HCLatm.*x_h2so4water;

           % Estimating H_hcl from mole fraction solubiltiy of HCl in hexanoic acid
           % from solubility data series page 204 (https://srdata.nist.gov/solubility/IUPAC/SDS-42/SDS-42.pdf)
           x_hcl        = exp(28.986 - 33.458/(Tin./100) - 18.135.*log(Tin/100));
           ratio_hcl    = 1./(1./x_hcl - 1);

           % Density values from Ghatee et al. 2013 dx.doi.org/10.1021/ie3018675 (scales reasonably at colder temperatures)  
           den_hex      = (-5.0083e-7.*Tin.^2. - 5.2309e-4.*Tin + 1.1238).*1000;

           % Dissociation constant at 100C is 10^5.9 for HCl gas in water (Trummel et al. 2016 doi:10.1021/acs.jpca.6b02253)
           % Dissociation constant should increase for colder temperatures, but unfortunately do not have these values.                             
           % H_hcl        = ratio_hcl/116.16*den_hex*7.9433e5 or ratio_hcl/116.16*den_hex*(1 + 7.9433e5/ah_hcl) if
           % accounting for acidity
           % H* = H(1+Ka/ah) Williams et al. 1995 https://doi.org/10.1029/95JD00218

           % partitioning for mixed aerosols (organics in mixed) and using fraction of aerosols that are mixed (1-so4pure)
           H_hcl        = ratio_hcl./116.16.*den_hex.*(1 + 7.9433e5./ah_hcl);
           M_hcl        = M_hcl_h2so4 + (H_hcl.*HCLatm.*x_org + M_hcl_h2so4_newwt).*(1.-atmosphere.so4pure(step.doy));
            % calculate acidity and new wt percent
            
            % calculate double linear M values. thats it!
            if step.i == 2000
                a = 1
            end
    end

    %SAD = 1e-8;% atmosphere.atLevel.SAD.vmr(step.doy);
        
    %aw = .01;    
    [kout] = hetrates(variables,Tin,CLONO2atm,HCLatm,atmosphere.dummySAD(step.doy),wt,M_hcl,molar_h2so4,aw,timeind,atmosphere.radius(step.doy));
    
    % N2O5 + H2O -> 2*HNO3
    rates.N2O5.destruction(end+1) = kout.hetN2O5;
    rates.HNO3.production(end+1) = kout.hetN2O5.*2;
    
    % CLONO2 + H2O -> HOCL + HNO3
    rates.CLONO2.destruction(end+1) = kout.hetCLONO2_H2O;
    rates.HOCL.production(end+1) = kout.hetCLONO2_H2O;
    rates.HNO3.production(end+1) = kout.hetCLONO2_H2O;    

    % CLONO2 + HCL -> CL2 + HNO3
    rates.CLONO2.destruction(end+1) = kout.hetCLONO2_HCL;
    rates.HCL.destruction(end+1) = kout.hetCLONO2_HCL;
    rates.CL2.production(end+1) = kout.hetCLONO2_HCL;
    rates.HNO3.production(end+1) = kout.hetCLONO2_HCL;
    
    % HOCL + HCL -> CL2 + H2O
    rates.HOCL.destruction(end+1) = kout.hetHOCL_HCL;
    rates.HCL.destruction(end+1) = kout.hetHOCL_HCL;
    rates.CL2.production(end+1) = kout.hetHOCL_HCL;
    
    % HOBR + HCL -> BRCL + H2O
    rates.HOBR.destruction(end+1) = kout.hetHOBR_HCL;
    rates.HCL.destruction(end+1) = kout.hetHOBR_HCL;
    rates.BRCL.production(end+1) = kout.hetHOBR_HCL;
    
    % BRONO2 + H2O -> HNO3 + HOBR
    rates.BRONO2.destruction(end+1) = kout.hetBRONO2_H2O;
    rates.HOBR.production(end+1) = kout.hetBRONO2_H2O;
    rates.HNO3.production(end+1) = kout.hetBRONO2_H2O;
    
end