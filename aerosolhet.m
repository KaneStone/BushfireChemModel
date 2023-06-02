function aerosolhet(inputs,variables)

% Shi et al
% calculate water in partial pressure hPa
%variables.T = 200;
ph2o_hpa = variables.vmr.H2O .* variables.pressure; % pressure is in hPa;
%pHCl = variables.HCl .* variables.pressure ./ 1013.25;

wt_e0 = 18.452406985;
wt_e1 = 3505.1578807;
wt_e2 = 330918.55082;
wt_e3 = 12725068.262;

Tinv = 1./variables.T;

pzero_h2o = exp(wt_e0 - Tinv .* (wt_e1 + Tinv .* (wt_e2 - Tinv .* wt_e3)));

% water activity
aw = ph2o_hpa ./ pzero_h2o;

% h2so4 molality 

constants = awconstants(aw);

y1 = constants.a1.*(aw.^constants.b1) + constants.c1.*aw + constants.d1;
y2 = constants.a2.*(aw.^constants.b2) + constants.c2.*aw + constants.d2;

m_h2so4 = y1 + ((variables.T - 190) .* (y2 - y1)) / 70;

wrk = variables.T.*variables.T;
z1 =  .12364  - 5.6e-7.*wrk;
z2 = -.02954  + 1.814e-7.*wrk;
z3 =  2.343e-3 - variables.T.*1.487e-6 - 1.324e-8.*wrk;
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
switch inputs.HCLSolubility
    case 'control'
        x_h2so4 = wt ./ (wt + (100 - wt) .* 98 ./ 18); % mole fraction
        
        term1 = .094 - x_h2so4 .* (.61 - 1.2 .* x_h2so4);        
        term2 = (8515 - 10718 .* (x_h2so4.^.7)).*T_limiti;                
        H_hcl_h2so4 = term1 .* exp( -8.68 + term2); %(mol / l / atm)         
        M_hcl_h2so4 = H_hcl_h2so4.*variables.pp.HCl; %(mol/l/atm * atm) = mol/l        
        molar_h2so4 = den_h2so4.*wt./9.8;
    case 'solubility'
        hex_smoothing_strat = exp(28.986 - 33.458./(variables.T/100) - 18.135 .* log(variables.T/100));
        ratio_hcl = 1./(1./hex_smoothing_strat - 1);
        Ka = 10^5.9;        
        Mm_hex = 116.16;        
        hex_den = (-5.0083e-7 * variables.T.^2 - 5.2309e-4 .* variables.T + 1.1238) .* 1000; %(from Ghatee et al. 2013 [may not be applicable]) dx.doi.org/10.1021/ie3018675
        molarity = ratio_hcl .* 1./Mm_hex .* hex_den;
        H_hcl_h2so4 = molarity .* Ka;
        M_hcl_h2so4 = H_hcl_h2so4.*variables.pp.HCl; %(mol/l/atm * atm) = mol/l
        molar_h2so4 = den_h2so4.*wt./9.8; 
end

[rxt] = calchetrates(variables,wt,M_hcl_h2so4,molar_h2so4,aw);

end