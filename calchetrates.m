function [rxt] = calchetrates(variables,wt,M_hcl_h2so4,molar_h2so4,aw)
%w1 = wt;
%wt = wt2;

T_limit = variables.T;
T_limiti = 1./T_limit;

aconst    = 169.5 + wt.*(5.18 - wt.*(.0825 - 3.27e-3.*wt));
tzero     = 144.11 + wt.*(.166 - wt.*(.015 - 2.18e-4.*wt));
vis_h2so4 = aconst./(T_limit.^1.43) .* exp( 448./(T_limit - tzero) );

term1 = 60.51;
term2 = .095.*wt;
wrk   = wt.*wt;
term3 = .0077.*wrk;
term4 = 1.61e-5.*wt.*wrk;
term5 = (1.76 + 2.52e-4 .* wrk) .* sqrt(T_limit);
term6 = -805.89 + (253.05.*(wt.^.076));
term7 = sqrt(T_limit);
ah    = exp( term1 - term2 + term3 - term4 - term5 + term6./term7);


wrk = .25.*variables.vmr.SAD;

% CLONO2 + H2O
%rad_sulf = vmr.SULFRE.*1e-4;%5e-7;
rad_sulf = 1e-7;%5e-7;
sf = 1;
%R =287; %J K-1 kg-1
R = 8.31; % J K-1 mol-1

av_clono2 = (8.*R.*T_limit.*1000./(pi*98)).^.5 * 100; % (kg m2 s-2) (K-1) (kg-1) (K) (mol-1 kg) (kg m2 s-2 mol-1
av_hocl = (8.*R.*T_limit.*1000./(pi*52.5)).^.5 * 100; %(kg m2 s-2) (K-1) (mol-1) (K) (mol-
av_hobr = (8.*R.*T_limit.*1000./(pi*96.9)).^.5 * 100; %(kg m2 s-2) (K-1) (mol-1) (K) (mol-

C_cnt         = 1474.*sqrt(T_limit); % no
S_cnt         = .306 + 24.*T_limiti; % no
term1         = exp(-S_cnt.*molar_h2so4); % no
H_cnt         = 1.6e-6 .* exp( 4710.*T_limiti ).*term1; % no
D_cnt         = 5.e-8.*T_limit ./ vis_h2so4; % no
k_h           = 1.22e12.*exp( -6200.*T_limiti ); % no
k_h2o         = 1.95e10.*exp( -2800.*T_limiti ); % no
k_hydr        = (k_h2o + k_h.*ah).*aw; % no
k_hcl         = 7.9e11.*ah.*D_cnt.*M_hcl_h2so4; % maybe
rdl_cnt       = sqrt( D_cnt./(k_hydr + k_hcl) ); % no
term1         = 1./tanh( rad_sulf./rdl_cnt ); % no
term2         = rdl_cnt./rad_sulf; % no
f_cnt         = term1 - term2; % no

%     if f_cnt > 0
term1         = 4.*H_cnt*.082.*T_limit;
term2         = sqrt( D_cnt.*k_hydr );
Gamma_b_h2o   = term1.*term2./C_cnt;
term1         = sqrt( 1 + k_hcl./k_hydr );
Gamma_cnt_rxn = f_cnt.*Gamma_b_h2o.*term1;
Gamma_b_hcl   = Gamma_cnt_rxn.*k_hcl./(k_hcl + k_hydr);
term1         = exp( -1374.*T_limiti );
Gamma_s       = 66.12.*H_cnt.*M_hcl_h2so4.*term1;

term1      = .612.*(Gamma_s+Gamma_b_hcl).*variables.pp.ClONO2./variables.pp.HCl;
Fhcl       = 1./(1 + term1);

Gamma_s_prime     = Fhcl.*Gamma_s;
Gamma_b_hcl_prime = Fhcl.*Gamma_b_hcl;
term1         = Gamma_cnt_rxn.*k_hydr;
term2         = k_hcl + k_hydr;
Gamma_b       = Gamma_b_hcl_prime + (term1./term2);
term1         = 1 ./ (Gamma_s_prime + Gamma_b);
gprob_cnt     = 1 ./ (1 + term1);
term1         = Gamma_s_prime + Gamma_b_hcl_prime;
term2         = Gamma_s_prime + Gamma_b;
gprob_cnt_hcl = gprob_cnt .* term1./term2;
gprob_cnt_h2o = gprob_cnt - gprob_cnt_hcl;
rxt.clono2_h2o = wrk.*av_clono2.*gprob_cnt_h2o;

% clodeni = 1./(vmr.CLONO2.*ad_Tbin
% hcl = 1./(vmr.HCL.*ad_Tbin

%% ClONO2 + HCl
if variables.nd.HCL > level.CLONO2
    rxt.clono2_hcl = wrk.*av_clono2.*gprob_cnt_hcl.*(1./variables.nd.HCl);
else     
    rxt.clono2_hcl = wrk.*av_clono2.*gprob_cnt_hcl.*(1./variables.nd.ClONO2);
end
     
%% HOCL + HCl
D_hocl          = 6.4e-8.*T_limit./vis_h2so4;
k_hocl_hcl      = 1.25e9.*ah.*D_hocl.*M_hcl_h2so4;
C_hocl          = 2009.*sqrt(T_limit);
S_hocl          = .0776 + 59.18.*T_limiti;
term1           = exp( -S_hocl.*molar_h2so4 );
H_hocl          = 1.91e-6 .* exp( 5862.4.*T_limiti ).*term1;
term1           = 4.*H_hocl.*.082.*T_limit;
term2           = sqrt( D_hocl.*k_hocl_hcl );
Gamma_hocl_rxn  = term1.*term2./C_hocl;
rdl_hocl        = sqrt( D_hocl./k_hocl_hcl );
term1           = 1./tanh( rad_sulf./rdl_hocl );
term2           = rdl_hocl./rad_sulf;
f_hocl          = term1 - term2;

term1           = 1 ./ (f_hocl.*Gamma_hocl_rxn.*Fhcl);
gprob_hocl_hcl  = 1 ./ (1. + term1);

rxt.hocl_hcl    = wrk.*av_hocl.*gprob_hocl_hcl.*(1./level.HCL);
%figure; plot(nanmean(gprob_hocl_hcl)), title('gprob_hocl_hcl')
%figure; plot(nanmean(gprob_cnt_hcl)), title('gprob_cnt_hcl')
%% HOBr + HCl
C_hobr          = 1477.*sqrt(T_limit);
D_hobr          = 9.e-9;
k_wasch         = .125.*exp(.542.*wt - 6440.*T_limiti + 10.3);

H_hobr          = exp( -9.86 + 5427.*T_limiti );
k_dl            = 7.5e14.*D_hobr.*2;                       

k_hobr_hcl = NaN(size(k_wasch));
k_hobr_hcl(k_wasch >= k_dl) = k_dl .* M_hcl_h2so4(k_wasch >= k_dl);
k_hobr_hcl(k_wasch < k_dl) = k_wasch(k_wasch < k_dl) .* M_hcl_h2so4(k_wasch < k_dl);

term1           = 4.*H_hobr.*.082.*T_limit;
term2           = sqrt(D_hobr.*k_hobr_hcl);
tmp             = rad_sulf./term2;
Gamma_hobr_rxn  = term1.*term2./C_hobr;
rdl_hobr        = sqrt(D_hobr./k_hobr_hcl);
if tmp < 1e2 
    term1           = 1./tanh(rad_sulf./rdl_hobr);
else
    term1           = 1;
end
term2           = rdl_hobr./rad_sulf;
f_hobr          = term1 - term2;
if(f_hobr > 0)
    term1            = 1 ./ (f_hobr.*Gamma_hobr_rxn);
    gprob_hobr_hcl   = 1 ./ (1 + term1);
else
    gprob_hobr_hcl  = 0;
end

% if ( hclvmr > hobrvmr ) then
rxt.hobr_hcl = wrk.*av_hobr.*gprob_hobr_hcl.*1./level.HCL;
%figure; plot(nanmean(gprob_hobr_hcl)); title('gprob_hobr_hcl');
% else
% rxt(i,k,rid_het6) = max( 0._r8,wrk*av_hobr*gprob_hobr_hcl(i,k) )*hobrdeni
% end if

end