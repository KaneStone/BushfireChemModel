function [atmosphere,variables] = initializevars(inputs)


    % reading in ancil files, smoothing them or creating own, then initializing
    % variables ensuring chemical families have appropriate number densities 

    controlancil = load([inputs.ancildir,'variables/','climInControl.mat']);
    solancil = load([inputs.ancildir,'variables/','climInSolubility.mat']);        
    % switch inputs.runtype
    %     case {'solubility','doublelinear','doublelinear_wtsulf'}
    %         solancil = load([inputs.ancildir,'variables/','climInSolubility.mat']);        
    %     otherwise
    % end

    % extract temperature, pressure, and density
    atmosphere.T = controlancil.ancil.T;
    atmosphere.P = controlancil.ancil.P;
    atmosphere.M = controlancil.ancil.M;
%    atmosphere.V = controlancil.ancil.V.vmr;
    atmosphere.O3 = controlancil.ancil.O3.nd;
    atmosphere.altitude = 0:90;

    % remove temperature, pressure , and density from ancil fieldnames
    controlancil = rmfield(controlancil.ancil,{'T','P','M','altitude'});

    %% extract variables
    fieldnames = fields(controlancil);

    for i = 1:length(fieldnames)
        atmosphere.atLevel.(fieldnames{i}).nd = controlancil.(fieldnames{i}).nd(inputs.altitude+1,:);
        atmosphere.atLevel.(fieldnames{i}).vmr = controlancil.(fieldnames{i}).vmr(inputs.altitude+1,:);    
    end

    atmosphere.atLevel.T = atmosphere.T(inputs.altitude+1,:);
    atmosphere.atLevel.P = atmosphere.P(inputs.altitude+1,:);
    atmosphere.atLevel.M = atmosphere.M(inputs.altitude+1,:);    

    atmosphere.atLevel.O2.nd = atmosphere.atLevel.M.*.21;
    atmosphere.atLevel.N2.nd = atmosphere.atLevel.M.*.78;

    %% creating dummy variables for flux correction and input climatology species
    % WILL NOT WORK IF YOU GO ABOVE 25 KM or for NH, polar regions. Will need to
    % estimate a phase variable from climatology to be more consistent. FOr
    % example HNO3 is out of phase at 16 km.

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
    
    switch inputs.runtype        
        case 'solubility'

            atmosphere.dummySAD = solancil.ancil.SAD_SULFC.vmr(inputs.altitude+1,1:inputs.days);   % 1.5 is arbitrary 
            %atmosphere.dummySAD(366:end) = atmosphere.dummySAD(366:end)./8;
            atmosphere.aoc_aso4_ratio = solancil.ancil.aoc.vmr(inputs.altitude+1,1:inputs.days)./solancil.ancil.aso4.vmr(inputs.altitude+1,1:inputs.days);        
            atmosphere.radius = solancil.ancil.SULFRE.vmr(inputs.altitude+1,1:inputs.days).*1e-4;

            % 2020 had higher temperature early on.
            %atmosphere.atLevel.T(1:242) =  atmosphere.atLevel.T(242);
        case {'doublelinear','doublelinear_wtsulf'}
            atmosphere.dummySAD = solancil.ancil.SAD_SULFC.vmr(inputs.altitude+1,1:ceil(inputs.days));   % 1.5 is arbitrary 
            
%             atmosphere.dummySAD(end-9:end) = atmosphere.dummySAD(end-10);
%             atmosphere.dummySAD(2:10) = atmosphere.dummySAD(1);
            atmosphere.mixsulffrac = solancil.ancil.mixsulffrac.vmr(inputs.altitude+1,1:ceil(inputs.days));
            atmosphere.so4pure = solancil.ancil.so4pure.vmr(inputs.altitude+1,1:ceil(inputs.days));

            atmosphere.so4pure(26:46) = atmosphere.so4pure(25);
            atmosphere.mixsulffrac(26:46) = atmosphere.mixsulffrac(25);

            atmosphere.radius = solancil.ancil.SULFRE.vmr(inputs.altitude+1,1:ceil(inputs.days)).*1e-4;
            
            % 2020 had higher temperature early on.
            %atmosphere.atLevel.T(1:242) =  atmosphere.atLevel.T(242);
        case 'constantdoublelinear'
            atmosphere.dummySAD = solancil.ancil.SAD_SULFC.vmr(inputs.altitude+1,1:ceil(inputs.days));   % 1.5 is arbitrary 
            atmosphere.dummySAD(:) = atmosphere.dummySAD(5);
%             atmosphere.dummySAD(end-9:end) = atmosphere.dummySAD(end-10);
%             atmosphere.dummySAD(2:10) = atmosphere.dummySAD(1);
            atmosphere.mixsulffrac = solancil.ancil.mixsulffrac.vmr(inputs.altitude+1,1:ceil(inputs.days));
            atmosphere.so4pure = solancil.ancil.so4pure.vmr(inputs.altitude+1,1:ceil(inputs.days));
            
            atmosphere.mixsulffrac(:) = atmosphere.mixsulffrac(40);    
            atmosphere.so4pure(:) = atmosphere.so4pure(40);

            atmosphere.atLevel.T(:) = 214;
            atmosphere.atLevel.H2O.vmr(:) = atmosphere.atLevel.H2O.vmr(40);
            atmosphere.atLevel.H2O.nd(:) = atmosphere.atLevel.H2O.nd(40);
            atmosphere.atLevel.CH4.nd(:) = atmosphere.atLevel.CH4.nd(1);

            % atmosphere.so4pure(26:46) = atmosphere.so4pure(25);
            % atmosphere.mixsulffrac(26:46) = atmosphere.mixsulffrac(25);

            atmosphere.radius = solancil.ancil.SULFRE.vmr(inputs.altitude+1,1:ceil(inputs.days)).*1e-4;
            atmosphere.radius(:) = atmosphere.radius(40);
        case '2xorganics'
             atmosphere.dummySAD = solancil.ancil.SAD_SULFC.vmr(inputs.altitude+1,1:ceil(inputs.days)).*4;   % 1.5 is arbitrary 
%             atmosphere.dummySAD(end-9:end) = atmosphere.dummySAD(end-10);
%             atmosphere.dummySAD(2:10) = atmosphere.dummySAD(1);
            atmosphere.mixsulffrac = solancil.ancil.mixsulffrac.vmr(inputs.altitude+1,1:ceil(inputs.days))./4;
            atmosphere.so4pure = solancil.ancil.so4pure.vmr(inputs.altitude+1,1:ceil(inputs.days))./4;

            %atmosphere.so4pure(26:46) = atmosphere.so4pure(25);
            %atmosphere.mixsulffrac(26:46) = atmosphere.mixsulffrac(25);

            atmosphere.radius = solancil.ancil.SULFRE.vmr(inputs.altitude+1,1:ceil(inputs.days)).*1e-4;
            
            % 2020 had higher temperature early on.
            %atmosphere.atLevel.T(1:242) =  atmosphere.atLevel.T(242);
        case {'control','ghcl'}

            SADini = .9e-8;%.7
            atmosphere.dummySAD = (SADini+1e-9 + SADini./40.*sin(2*pi./365.*(1:365)+pi.*1.1));            
            atmosphere.dummySAD = repmat(atmosphere.dummySAD, 1,2);
            atmosphere.dummySAD = atmosphere.dummySAD(1:ceil(inputs.days));
            
            %atmosphere.dummySAD = solancil.ancil.SAD_SULFC.vmr(inputs.altitude+1,1:ceil(inputs.days));   % 1.5 is arbitrary 
            if strcmp(inputs.radius,'ancil')
                atmosphere.radius = controlancil.SULFRE.vmr(inputs.altitude+1,:).*1e-4; % cm; 
                atmosphere.radius = repmat(atmosphere.radius,1,2);
                atmosphere.radius = atmosphere.radius(1:ceil(inputs.days));
            else
                atmosphere.radius = inputs.radius;
            end
        case 'Hunga'

            SADini = .9e-8;
            atmosphere.dummySAD = (SADini+1e-9 + SADini./40.*sin(2*pi./365.*(1:365)+pi.*1.1));            
            atmosphere.dummySAD(190:end) = atmosphere.dummySAD(190:end)+5e-8;
            

            monthtemps = [215.055441932141, 215.568443982536, 214.461859807604, 213.359479872438,...
                213.017318175080, 212.232093731955, 211.423060160350, 211.552241021724, 213.590188009631,...
                214.743488141370, 214.875345028124, 214.348034524305];
            atmosphere.atLevel.T = interp1(1:12,monthtemps,1+11/365:11/365:12);

            atmosphere.dummyH2Ovmr(190:end) = atmosphere.dummyH2Ovmr(190:end)+2e-6;
            dummyh2Otemp = atmosphere.dummyH2O(1);
            atmosphere.dummyH2O = atmosphere.dummyH2Ovmr(1:365)./(inputs.k.*1e6).*(atmosphere.atLevel.P(1:365).*100)./atmosphere.atLevel.T;
            atmosphere.dummyH2O = atmosphere.dummyH2O - (atmosphere.dummyH2O(1) - dummyh2Otemp);
            atmosphere.radius = controlancil.SULFRE.vmr(inputs.altitude+1,:).*1e-4; % cm; 
            atmosphere.radius(190:end) = atmosphere.radius(190:end).*2;
        
        case 'glassy'
            atmosphere.dummySADsolid = solancil.ancil.SAD_SULFC.vmr(inputs.altitude+1,1:ceil(inputs.days))-controlancil.SAD_SULFC.vmr(inputs.altitude+1,1:ceil(inputs.days));   % 1.5 is arbitrary 
            atmosphere.dummySADsolid (atmosphere.dummySADsolid < 0) = 0;
            SADini = .9e-8;%.7
            atmosphere.dummySAD = (SADini+1e-9 + SADini./40.*sin(2*pi./365.*(1:365)+pi.*1.1));            
            atmosphere.dummySAD = repmat(atmosphere.dummySAD, 1,2);
            atmosphere.dummySAD = atmosphere.dummySAD(1:ceil(inputs.days));
            
%             atmosphere.dummySAD(end-9:end) = atmosphere.dummySAD(end-10);
%             atmosphere.dummySAD(2:10) = atmosphere.dummySAD(1);
            atmosphere.mixsulffrac = solancil.ancil.mixsulffrac.vmr(inputs.altitude+1,1:ceil(inputs.days));
            atmosphere.so4pure = solancil.ancil.so4pure.vmr(inputs.altitude+1,1:ceil(inputs.days));

            atmosphere.so4pure(26:46) = atmosphere.so4pure(25);
            atmosphere.mixsulffrac(26:46) = atmosphere.mixsulffrac(25);

            atmosphere.radius = solancil.ancil.SULFRE.vmr(inputs.altitude+1,1:ceil(inputs.days)).*1e-4;

    end    
    %% initialize variables

    % initializing vars to input ancil data will ensure CLY, BRY etc will start
    % with appropriate number densities (may take a few days to reach
    % equilibrium)
    variables.O3 = atmosphere.dummyO3(1);
    variables.CLONO2 = atmosphere.dummyCLONO2(1);
    variables.HCL = atmosphere.dummyHCL(1);
    variables.HNO3 = atmosphere.dummyHNO3(1);
    variables.O1D = atmosphere.atLevel.O1D.nd(1);
    variables.CLO = atmosphere.atLevel.CLO.nd(1);
    variables.HOCL = atmosphere.atLevel.HOCL.nd(1);
    variables.OCLO = atmosphere.atLevel.OCLO.nd(1);
    variables.BRCL = atmosphere.atLevel.BRCL.nd(1);
    variables.O = atmosphere.atLevel.O.nd(1);
    variables.CL = atmosphere.atLevel.CL.nd(1);
    variables.CL2 = atmosphere.atLevel.CL2.nd(1);
    variables.CL2O2 = atmosphere.atLevel.CL2O2.nd(1);
    variables.NO = atmosphere.atLevel.NO.nd(1);
    variables.NO2 = atmosphere.atLevel.NO2.nd(1);
    variables.NO3 = atmosphere.atLevel.NO3.nd(1);
    variables.N2O5 = atmosphere.atLevel.N2O5.nd(1);
    variables.OH = atmosphere.atLevel.OH.nd(1);
    variables.HO2 = atmosphere.atLevel.HO2.nd(1);
    variables.H2O2 = atmosphere.atLevel.H2O2.nd(1);
    variables.HO2NO2 = atmosphere.atLevel.HO2NO2.nd(1);
    variables.BRO = atmosphere.atLevel.BRO.nd(1);
    variables.HBR = atmosphere.atLevel.HBR.nd(1);
    variables.HOBR = atmosphere.atLevel.HOBR.nd(1);
    variables.BRONO2 = atmosphere.atLevel.BRONO2.nd(1);
    variables.BR = atmosphere.atLevel.BR.nd(1);    

    if inputs.methanechemistry
        variables.CH2O = atmosphere.atLevel.CH2O.nd(1);
        variables.CH3O2 = atmosphere.atLevel.CH3O2.nd(1);
        variables.CH3OOH = atmosphere.atLevel.CH3OOH.nd(1);
        variables.CH3OH = atmosphere.atLevel.CH3OH.nd(1);
    end
    
    % diagnostics for debugging to make sure appropriate total family
    % concentrations are accurates. Because CLY, BRY, NOy are conserved if the
    % initial amount is too low or too high it will ALWAYS be too low or too high 
    ancilCLY =  atmosphere.atLevel.CL.nd(1) + atmosphere.atLevel.CL2.nd(1).*2 + ...
        atmosphere.atLevel.CLONO2.nd(1) + atmosphere.atLevel.HOCL.nd(1) + atmosphere.atLevel.CLO.nd(1) + ...
        atmosphere.atLevel.HCL.nd(1) + atmosphere.atLevel.OCLO.nd(1) + atmosphere.atLevel.BRCL.nd(1) + atmosphere.atLevel.CL2O2.nd(1).*2;

    initCLY = variables.CL(1) + variables.CL2(1).*2 + ...
        variables.CLONO2(1) + variables.HOCL(1) + variables.CLO(1) + ...
        variables.HCL(1) + variables.OCLO(1) + variables.BRCL(1) + variables.CL2O2(1).*2;

    ancilNO2 =  atmosphere.atLevel.BRONO2.nd(1) + atmosphere.atLevel.CLONO2.nd(1) + atmosphere.atLevel.HO2NO2.nd(1) +...
            atmosphere.atLevel.NO3.nd(1) + atmosphere.atLevel.NO.nd(1) + atmosphere.atLevel.NO2.nd(1) + atmosphere.atLevel.HNO3.nd(1) + atmosphere.atLevel.N2O5.nd(1).*2;

    initNO2 = variables.BRONO2(1) + variables.CLONO2(1) + variables.HO2NO2(1) +...
            variables.NO3(1) + variables.NO(1) + variables.NO2(1) + variables.HNO3(1) + variables.N2O5(1).*2;

    ancilHOY = atmosphere.atLevel.HO2.nd(1) + atmosphere.atLevel.OH.nd(1) + atmosphere.atLevel.H2O2.nd(1).*2 +...
            atmosphere.atLevel.HO2NO2.nd(1) + atmosphere.atLevel.HNO3.nd(1) + atmosphere.atLevel.HOBR.nd(1) + atmosphere.atLevel.HOCL.nd(1) + atmosphere.atLevel.HCL.nd(1) + atmosphere.atLevel.HBR.nd(1);        

    initHOY = variables.HO2(1) + variables.OH(1) + variables.H2O2(1).*2 +...
            variables.HO2NO2(1) + variables.HNO3(1) + variables.HOBR(1) + variables.HOCL(1) + variables.HCL(1) + variables.HBR(1);    

    ancilBRY = atmosphere.atLevel.BRONO2.nd(1) + atmosphere.atLevel.HBR.nd(1) + atmosphere.atLevel.BR.nd(1) +...
            atmosphere.atLevel.BRCL.nd(1) + atmosphere.atLevel.HOBR.nd(1) + atmosphere.atLevel.BRO.nd(1);    

    initBRY = variables.BRONO2(1) + variables.HBR(1) + variables.BR(1) +...
            variables.BRCL(1) + variables.HOBR(1) + variables.BRO(1);

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

end
