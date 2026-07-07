function [atmosphere,variables] = initializevars(inputs)


    % reading in ancil files, smoothing them or creating own, then initializing
    % variables ensuring chemical families have appropriate number densities 

    switch inputs.region
        case 'equator'
            controlancil = load([inputs.ancildir,'variables/','climInControlequator.mat']);
        case 'midlatitudes'
            controlancil = load([inputs.ancildir,'variables/','climInControl.mat']);
        case 'polarnorth'
            controlancil = load([inputs.ancildir,'variables/','climInControl.mat']);
        case 'polarwinter'
            controlancil = load([inputs.ancildir,'variables/','climInControl.mat']);
    end

    switch inputs.runtype
        case {'controldoublelinear','controldoublelinearnomix'}
            %solancil = load([inputs.ancildir,'variables/','climIncontrolorganics_withsoa.mat']);
            %solancil = load([inputs.ancildir,'variables/','climIncontrolnosoa.mat']);
            solancil = load([inputs.ancildir,'variables/','climIncontrolorganics_withoutsoainmixed.mat']);
        otherwise
            %solancil = load([inputs.ancildir,'variables/','climInSolubilitynosoa.mat']);        
            solancil = load([inputs.ancildir,'variables/','climInSolubilityorganics_withoutsoainmixed.mat']);        
    end
    solancil2 = load([inputs.ancildir,'variables/','climInSolubility.mat']);              

    % extract temperature, pressure, and density
    atmosphere.T = controlancil.ancil.T;
    atmosphere.P = controlancil.ancil.P;
    atmosphere.M = controlancil.ancil.M;
%    atmosphere.V = controlancil.ancil.V.vmr;
    atmosphere.O3 = controlancil.ancil.O3.nd;
    atmosphere.TCO = sum(atmosphere.O3,'omitnan').*1e9./2.6868e20;
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

    atmosphere = initializedummyvars(inputs, atmosphere);
    
    %% changing variables depending on run case
    switch inputs.runtype        
        case 'solubility'
            % Nature paper solubility case
            atmosphere.dummySAD = solancil.ancil.SAD_SULFC.vmr(inputs.altitude+1,1:inputs.days);   % 1.5 is arbitrary             
            atmosphere.aoc_aso4_ratio = solancil.ancil.aoc.vmr(inputs.altitude+1,1:inputs.days)./solancil.ancil.aso4.vmr(inputs.altitude+1,1:inputs.days);        
            atmosphere.radius = solancil.ancil.SULFRE.vmr(inputs.altitude+1,1:inputs.days).*1e-4;

        case {'doublelinear','doublelinear_wtsulf','linearnomix','controldoublelinear','controldoublelinearnomix'}
            % cases where HCL solubility is linearly added together based
            % on mass fraction of organics in aerosol

            atmosphere.dummySAD = solancil.ancil.SAD_SULFC.vmr(inputs.altitude+1,1:ceil(inputs.days));   % 1.5 is arbitrary             
            atmosphere.mixsulffrac = solancil.ancil.mixsulffrac.vmr(inputs.altitude,1:ceil(inputs.days));
            atmosphere.so4pure = solancil.ancil.so4pure.vmr(inputs.altitude,1:ceil(inputs.days));
            atmosphere.aocfrac = solancil.ancil.aocfrac.vmr(inputs.altitude,1:ceil(inputs.days));            
            atmosphere.radius = solancil.ancil.SULFRE.vmr(inputs.altitude+1,1:ceil(inputs.days)).*1e-4;
                        
        case 'controllinearnomix'
            atmosphere.dummySAD(:) = 1e-8;
            if strcmp(inputs.radius,'ancil')
                atmosphere.radius = controlancil.SULFRE.vmr(inputs.altitude+1,:).*1e-4; % cm; 
                atmosphere.radius = repmat(atmosphere.radius,1,2);
                %atmosphere.radius = atmosphere.radius(1:ceil(inputs.days));
            else
                atmosphere.radius = inputs.radius;
            end

            atmosphere.aocfrac = repmat(solancil.ancil.aocfrac.vmr(inputs.altitude,1),1,ceil(inputs.days));            
        case 'constantlinearnomix'
            % case where HCL solubility is linearly added base on mass
            % fraction of organics in aerosol and values are held constant

            daytouse = 40;
            atmosphere.dummySAD = solancil.ancil.SAD_SULFC.vmr(inputs.altitude+1,1:ceil(inputs.days));   % 1.5 is arbitrary             
            atmosphere.dummySAD(:) = 1e-8;
            atmosphere.mixsulffrac = solancil.ancil.mixsulffrac.vmr(inputs.altitude+1,1:ceil(inputs.days));
            atmosphere.so4pure = solancil.ancil.so4pure.vmr(inputs.altitude+1,1:ceil(inputs.days));
            atmosphere.aocfrac = solancil.ancil.aocfrac.vmr(inputs.altitude,1:ceil(inputs.days));            
            atmosphere.mixsulffrac(:) = .05;
            atmosphere.so4pure(:) = .05;
            atmosphere.aocfrac(:) = .5;

            % atmosphere.atLevel.T(:) = 214;
            % atmosphere.atLevel.P(:) = 6;
            atmosphere.dummyH2Ovmr(:) = atmosphere.atLevel.H2O.vmr(daytouse);
            atmosphere.dummyH2O(:) = atmosphere.atLevel.H2O.nd(daytouse);
            atmosphere.dummyCH4(:) = atmosphere.atLevel.CH4.nd(daytouse);                        

            atmosphere.radius = solancil.ancil.SULFRE.vmr(inputs.altitude+1,1:ceil(inputs.days)).*1e-4;
            atmosphere.radius(:) = atmosphere.radius(daytouse);

        case 'enhancedCL2'
            % case for testing lower stratosphere enhanced CL2 during day
            % time

            daytouse = 40;
            atmosphere.dummySAD = solancil.ancil.SAD_SULFC.vmr(inputs.altitude+1,1:ceil(inputs.days));   % 1.5 is arbitrary 
            %atmosphere.dummySAD(:) = atmosphere.dummySAD(1);
            atmosphere.dummySAD(:) = 5e-8;
            atmosphere.mixsulffrac = solancil.ancil.mixsulffrac.vmr(inputs.altitude+1,1:ceil(inputs.days));
            atmosphere.so4pure = solancil.ancil.so4pure.vmr(inputs.altitude+1,1:ceil(inputs.days));
            atmosphere.aocfrac = solancil.ancil.aocfrac.vmr(inputs.altitude,1:ceil(inputs.days));            
            atmosphere.mixsulffrac(:) = .05;
            atmosphere.so4pure(:) = .05;
            atmosphere.aocfrac(:) = 0;

            atmosphere.atLevel.T(:) = 220;
            % atmosphere.atLevel.P(:) = 6;
            % atmosphere.dummyH2Ovmr(:) = atmosphere.atLevel.H2O.vmr(daytouse);
            % atmosphere.dummyH2O(:) = atmosphere.atLevel.H2O.nd(daytouse);
            % atmosphere.dummyCH4(:) = atmosphere.atLevel.CH4.nd(daytouse);    
            atmosphere.dummyH2Ovmr(:) = 1e-5;
            % atmosphere.dummyH2O(:) = atmosphere.atLevel.H2O.nd(daytouse);
            % atmosphere.dummyCH4(:) = atmosphere.atLevel.CH4.nd(daytouse);    

            % atmosphere.so4pure(26:46) = atmosphere.so4pure(25);
            % atmosphere.mixsulffrac(26:46) = atmosphere.mixsulffrac(25);

            atmosphere.radius = solancil.ancil.SULFRE.vmr(inputs.altitude+1,1:ceil(inputs.days)).*1e-4;
            atmosphere.radius(:) = atmosphere.radius(daytouse);
        case 'constantcontrol'
            % case using constant values for control run

            daytouse = 1;
            atmosphere.dummySAD = solancil.ancil.SAD_SULFC.vmr(inputs.altitude+1,1:ceil(inputs.days));   % 1.5 is arbitrary 
            %atmosphere.dummySAD(:) = atmosphere.dummySAD(1);
            atmosphere.dummySAD(:) = 1e-8;
            atmosphere.mixsulffrac = solancil.ancil.mixsulffrac.vmr(inputs.altitude+1,1:ceil(inputs.days));
            atmosphere.so4pure = solancil.ancil.so4pure.vmr(inputs.altitude+1,1:ceil(inputs.days));
                        
            atmosphere.mixsulffrac(:) = .5;
            atmosphere.so4pure(:) = .3;
            atmosphere.atLevel.P(:) = 65;
            atmosphere.atLevel.T(:) = 214;
            % this
            atmosphere.dummyH2Ovmr(:) = atmosphere.atLevel.H2O.vmr(daytouse);
            atmosphere.dummyH2O(:) = atmosphere.atLevel.H2O.nd(daytouse);
            atmosphere.dummyCH4(:) = atmosphere.atLevel.CH4.nd(daytouse);           

            atmosphere.radius = solancil.ancil.SULFRE.vmr(inputs.altitude+1,1:ceil(inputs.days)).*1e-4;
            atmosphere.radius(:) = atmosphere.radius(daytouse);
        case '2xorganics'
             atmosphere.dummySAD = solancil.ancil.SAD_SULFC.vmr(inputs.altitude+1,1:ceil(inputs.days)).*4;   % 1.5 is arbitrary 
            atmosphere.mixsulffrac = solancil.ancil.mixsulffrac.vmr(inputs.altitude+1,1:ceil(inputs.days))./4;
            atmosphere.so4pure = solancil.ancil.so4pure.vmr(inputs.altitude+1,1:ceil(inputs.days))./4;            

            atmosphere.radius = solancil.ancil.SULFRE.vmr(inputs.altitude+1,1:ceil(inputs.days)).*1e-4;
            
            % 2020 had higher temperature early on.
            %atmosphere.atLevel.T(1:242) =  atmosphere.atLevel.T(242);
        case {'control','ghcl'}

            SADini = .9e-8;%.7
            atmosphere.dummySAD = (SADini+1e-9 + SADini./40.*sin(2*pi./365.*(1:365)+pi.*1.1));                        
            atmosphere.dummySAD = repmat(atmosphere.dummySAD, 1,2);      
            %atmosphere.dummySAD(:) = 1e-8.*2
            if strcmp(inputs.region,'polarwinter')
                atmosphere.atLevel.T(:) = 210;
                atmosphere.atLevel.P(:) = 200;
                % atmosphere.atLevel.HCL.nd = atmosphere.atLevel.HCL.nd/2;
                atmosphere.atLevel.CLONO2.nd = atmosphere.atLevel.CLONO2.nd.*2;
                atmosphere.atLevel.HOCL.nd = atmosphere.atLevel.HOCL.nd.*10;
                atmosphere.atLevel.HOBR.nd = atmosphere.atLevel.HOBR.nd./3;
                atmosphere.dummyH2Ovmr(:) = 15e-6;
                SADini = 1.5e-8;%.7
                atmosphere.dummySAD = (SADini+1e-9 + SADini./40.*sin(2*pi./365.*(1:365)+pi.*1.1));                        
                atmosphere.dummySAD = repmat(atmosphere.dummySAD, 1,2);      
            end
            if strcmp(inputs.radius,'ancil')
                atmosphere.radius = controlancil.SULFRE.vmr(inputs.altitude+1,:).*1e-4; % cm; 
                atmosphere.radius = repmat(atmosphere.radius,1,2);
                %atmosphere.radius = atmosphere.radius(1:ceil(inputs.days));
            else
                atmosphere.radius = inputs.radius;
            end

            %atmosphere.radius(:) = atmosphere.radius(:)+atmosphere.radius(:)./2;

        case 'Hunga'         
            
            % Hunga-Tonga pulse of water vapor and aerosol surface area and
            % radius at day 190 is constant, i.e. remains until the end of the
            % year. This pulse is only setup for 21 km currently. To setup
            % for other altitudes use supplementary figure S3 to estimate
            % surface area, H2O, and radius anomalies. 

            SADini = .9e-8;
            atmosphere.dummySAD = (SADini+1e-9 + SADini./40.*sin(2*pi./365.*(1:365)+pi.*1.1));  

            % increasing aerosol chemical surface area
            atmosphere.dummySAD(190:end) = atmosphere.dummySAD(190:end)+5e-8;
            
            % Use monthly 2022 temperature data at 45S to interpolate onto daily temperature grid. Data from WACCM model simulations
            monthtemps = [215.055441932141, 215.568443982536, 214.461859807604, 213.359479872438,...
                213.017318175080, 212.232093731955, 211.423060160350, 211.552241021724, 213.590188009631,...
                214.743488141370, 214.875345028124, 214.348034524305];
            atmosphere.atLevel.T = interp1(1:12,monthtemps,1+11/365:11/365:12);

            %at day 190 add in 2e-6 vmr water vapour
            atmosphere.dummyH2Ovmr(190:end) = atmosphere.dummyH2Ovmr(190:end)+2e-6;
            dummyh2Otemp = atmosphere.dummyH2O(1);
            atmosphere.dummyH2O = atmosphere.dummyH2Ovmr(1:365)./(inputs.k.*1e6).*(atmosphere.atLevel.P(1:365).*100)./atmosphere.atLevel.T;
            atmosphere.dummyH2O = atmosphere.dummyH2O - (atmosphere.dummyH2O(1) - dummyh2Otemp);
            atmosphere.radius = controlancil.SULFRE.vmr(inputs.altitude+1,:).*1e-4; % cm; 

            % increase radius of aerosols
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
        case 'assumedhetchem'
            atmosphere.dummySAD = solancil.ancil.SAD_SULFC.vmr(inputs.altitude+1,1:ceil(inputs.days)); 

            atmosphere.mixsulffrac = solancil.ancil.mixsulffrac.vmr(inputs.altitude,1:ceil(inputs.days));
            atmosphere.so4pure = solancil.ancil.so4pure.vmr(inputs.altitude,1:ceil(inputs.days));
            atmosphere.aocfrac = solancil.ancil.aocfrac.vmr(inputs.altitude,1:ceil(inputs.days));

            atmosphere.radius = solancil.ancil.SULFRE.vmr(inputs.altitude+1,1:ceil(inputs.days)).*1e-4;
        case 'fullparameterization'
            % case where I input different estimates to simulate changes in
            % viscosity by temperature, linearize by surface area instead
            % of mass, etc.

            % testing variables to start
            daytouse = 40;
            atmosphere.dummySAD = solancil.ancil.SAD_SULFC.vmr(inputs.altitude+1,1:ceil(inputs.days));   % 1.5 is arbitrary             
            atmosphere.dummySAD(:) = 1e-8;
            atmosphere.mixsulffrac = solancil.ancil.mixsulffrac.vmr(inputs.altitude+1,1:ceil(inputs.days));
            atmosphere.so4pure = solancil.ancil.so4pure.vmr(inputs.altitude+1,1:ceil(inputs.days));
            atmosphere.aocfrac = solancil.ancil.aocfrac.vmr(inputs.altitude,1:ceil(inputs.days));            
            atmosphere.mixsulffrac(:) = .05;
            atmosphere.so4pure(:) = .05;
            atmosphere.aocfrac(:) = .5;

            % atmosphere.atLevel.T(:) = 214;
            % atmosphere.atLevel.P(:) = 6;
            atmosphere.dummyH2Ovmr(:) = atmosphere.atLevel.H2O.vmr(daytouse);
            atmosphere.dummyH2O(:) = atmosphere.atLevel.H2O.nd(daytouse);
            atmosphere.dummyCH4(:) = atmosphere.atLevel.CH4.nd(daytouse);                        

            atmosphere.radius = solancil.ancil.SULFRE.vmr(inputs.altitude+1,1:ceil(inputs.days)).*1e-4;
            atmosphere.radius(:) = atmosphere.radius(daytouse);
            
    end    
    %% initialize variables

    % initializing vars to input ancil data will ensure CLY, BRY etc will start
    % with appropriate number densities (may take a few days to reach
    % equilibrium)
    variables.O3 = atmosphere.dummyO3(inputs.dayssincestartofyear+1);
    % variables.CLONO2 = atmosphere.dummyCLONO2(inputs.dayssincestartofyear+1);
    % variables.HCL = atmosphere.dummyHCL(inputs.dayssincestartofyear+1);
    variables.CLONO2 = atmosphere.atLevel.CLONO2.nd(inputs.dayssincestartofyear+1);
    variables.HCL = atmosphere.atLevel.HCL.nd(inputs.dayssincestartofyear+1);
    variables.HNO3 = atmosphere.dummyHNO3(inputs.dayssincestartofyear+1);
    variables.O1D = atmosphere.atLevel.O1D.nd(inputs.dayssincestartofyear+1);
    variables.CLO = atmosphere.atLevel.CLO.nd(inputs.dayssincestartofyear+1);
    variables.HOCL = atmosphere.atLevel.HOCL.nd(inputs.dayssincestartofyear+1);
    variables.OCLO = atmosphere.atLevel.OCLO.nd(inputs.dayssincestartofyear+1);
    variables.BRCL = atmosphere.atLevel.BRCL.nd(inputs.dayssincestartofyear+1);
    variables.O = atmosphere.atLevel.O.nd(inputs.dayssincestartofyear+1);
    variables.CL = atmosphere.atLevel.CL.nd(inputs.dayssincestartofyear+1);
    variables.CL2 = atmosphere.atLevel.CL2.nd(inputs.dayssincestartofyear+1);
    variables.CL2O2 = atmosphere.atLevel.CL2O2.nd(inputs.dayssincestartofyear+1);
    variables.NO = atmosphere.atLevel.NO.nd(inputs.dayssincestartofyear+1);
    variables.NO2 = atmosphere.atLevel.NO2.nd(inputs.dayssincestartofyear+1);
    variables.NO3 = atmosphere.atLevel.NO3.nd(inputs.dayssincestartofyear+1);
    variables.N2O5 = atmosphere.atLevel.N2O5.nd(inputs.dayssincestartofyear+1);
    variables.OH = atmosphere.atLevel.OH.nd(inputs.dayssincestartofyear+1);
    variables.HO2 = atmosphere.atLevel.HO2.nd(inputs.dayssincestartofyear+1);
    variables.H2O2 = atmosphere.atLevel.H2O2.nd(inputs.dayssincestartofyear+1);
    variables.HO2NO2 = atmosphere.atLevel.HO2NO2.nd(inputs.dayssincestartofyear+1);
    variables.BRO = atmosphere.atLevel.BRO.nd(inputs.dayssincestartofyear+1);
    variables.HBR = atmosphere.atLevel.HBR.nd(inputs.dayssincestartofyear+1);
    variables.HOBR = atmosphere.atLevel.HOBR.nd(inputs.dayssincestartofyear+1);
    variables.BRONO2 = atmosphere.atLevel.BRONO2.nd(inputs.dayssincestartofyear+1);
    variables.BR = atmosphere.atLevel.BR.nd(inputs.dayssincestartofyear+1);    

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

end
