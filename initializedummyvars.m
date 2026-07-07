function atmosphere = initializedummyvars(inputs,atmosphere)

    atmosphere.dummyO3 = createdummyvariables(atmosphere.atLevel.O3.nd,3.6.*pi/3);
    atmosphere.dummyCLONO2 = createdummyvariables(atmosphere.atLevel.CLONO2.nd,3.6.*pi/3);
    atmosphere.dummyHCL = createdummyvariables(atmosphere.atLevel.HCL.nd,3.6.*pi/3);
    atmosphere.dummyHNO3 = createdummyvariables(atmosphere.atLevel.HNO3.nd,3.*pi/2);
    atmosphere.dummyN2O5 = createdummyvariables(atmosphere.atLevel.N2O5.nd,3.*pi/2);
    atmosphere.dummyCH2O = createdummyvariables(atmosphere.atLevel.CH2O.nd,pi/2); % testing
    atmosphere.dummyH = createdummyvariables(atmosphere.atLevel.H.nd,pi/2);
    atmosphere.dummyH2O = createdummyvariables(atmosphere.atLevel.H2O.nd,3.*pi/2);
    atmosphere.dummyH2Ovmr = atmosphere.dummyH2O.*inputs.k.*1e6./(atmosphere.atLevel.P(1:365).*100).*atmosphere.atLevel.T(1:365);
    atmosphere.dummyH2Ovmr = atmosphere.dummyH2Ovmr - (atmosphere.dummyH2Ovmr(1) - atmosphere.atLevel.H2O.vmr(1));      

    atmosphere.dummyCH3O2 = fitancil(atmosphere.atLevel.CH3O2.nd,.001); % testing
    atmosphere.dummyM = fitancil(atmosphere.atLevel.M,.1);
    atmosphere.dummyH2 = fitancil(atmosphere.atLevel.H2.nd,.001);
    atmosphere.dummyCO = fitancil(atmosphere.atLevel.CO.nd,.001);
    atmosphere.dummyO2 = atmosphere.dummyM.*.21;
    atmosphere.dummyN2 = atmosphere.dummyM.*.78;

    % smooth temperature
    Msmooth = movmean([atmosphere.atLevel.M(end-19:end),atmosphere.atLevel.M,atmosphere.atLevel.M(1:20)],20);
    atmosphere.dummyM = Msmooth(21:end-20); % this value changes
    
    atmosphere.dummyO2 = atmosphere.dummyM.*.21;
    atmosphere.dummyN2 = atmosphere.dummyM.*.78;        
    
    N2Osmooth = movmean([atmosphere.atLevel.N2O.nd(end-19:end),atmosphere.atLevel.N2O.nd,atmosphere.atLevel.N2O.nd(1:20)],20);
    atmosphere.dummyN2O = N2Osmooth(21:end-20); % this value changes
    
    CH4smooth = movmean([atmosphere.atLevel.CH4.nd(end-19:end),atmosphere.atLevel.CH4.nd,atmosphere.atLevel.CH4.nd(1:20)],20);
    atmosphere.dummyCH4 = CH4smooth(21:end-20); % this value changes

    % smooth temperature
    tempsmooth = movmean([atmosphere.atLevel.T(end-19:end),atmosphere.atLevel.T,atmosphere.atLevel.T(1:20)],20);
    atmosphere.atLevel.T = tempsmooth(21:end-20); % this value changes        

    % smooth pressure
    psmooth = movmean([atmosphere.atLevel.P(end-19:end),atmosphere.atLevel.P,atmosphere.atLevel.P(1:20)],20);
    atmosphere.atLevel.P = psmooth(21:end-20);        
    
    atmosphere.atLevel.H2O.nd(330:end) = atmosphere.atLevel.H2O.nd(330);
    H2Osmooth = movmean([atmosphere.atLevel.H2O.nd(end-19:end),atmosphere.atLevel.H2O.nd,atmosphere.atLevel.H2O.nd(1:20)],20);
    atmosphere.dummyH2O = H2Osmooth(21:end-20); % this value changes
    atmosphere.dummyH2Ovmr = atmosphere.dummyH2O.*inputs.k.*1e6./(atmosphere.atLevel.P.*100).*atmosphere.atLevel.T;
    atmosphere.dummyH2Ovmr = atmosphere.dummyH2Ovmr - (atmosphere.dummyH2Ovmr(1) - atmosphere.atLevel.H2O.vmr(1));      

end

function out = createdummyvariables(varin,phasein)
    ini = varin(1);
    amp = max(varin) - min(varin);
    dummyvar = ini + amp./2.*sin(2*pi./365.*(1:365) + phasein);
    startdiff = (dummyvar(1) - ini);
    out = dummyvar - startdiff;
end

function out = fitancil(varin,weight)
    wts = ones(1,365); wts(2:end-1) = weight;
    f=fit([1:365]',[varin(1:364),varin(1)]','poly3','Weights',wts);
    out = f(1:366);
end