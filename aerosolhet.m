function aerosolhet(inputs,variables)

% Shi et al
% calculate water in partial pressure hPa
%variables.T = 200;
ph2o_hpa = variables.H2O .* variables.pressure; % pressure is in hPa;
pHCl = variables.HCl .* variables.pressure ./ 1013.25;

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
x_h2so4 = wt ./ (wt + (100 - wt) .* 98 ./ 18); % mole fraction

molar_h2so4 = den_h2so4.*wt./9.8; %mol/l
molar_h20 = den_h2so4.*(100-wt)./.18; %mol/l

term1 = .094 - x_h2so4 .* (.61 - 1.2 * x_h2so4);
term2 = (8515 - 10718 .* (x_h2so4.^.7)).*Tinv;
H_hcl_h2so4 = term1 .* exp( -8.68 + term2); %(mol / l / atm)
M_hcl_h2so4 = H_hcl_h2so4.*pHCl; %(mol/l/atm * atm) = mol/l

end