function family = chemicalfamilies(variables,family,i)

    % CLY is continuous
    family.CLY(i) = variables.CLONO2(i) + variables.HCL(i) + variables.CL(i) +...
        variables.CL2(i).*2 + variables.CL2O2(i).*2 + variables.HOCL(i) + ...
        variables.BRCL(i) + variables.CLO(i) + variables.OCLO(i);
    
    % BRY is continuous
    family.BRY(i) = variables.BRONO2(i) + variables.HBR(i) + variables.BR(i) +...
        variables.BRCL(i) + variables.HOBR(i) + variables.BRO(i);
    
    % I have N2O sto will get a slight increase over time in NOy
    family.NOY(i) = variables.BRONO2(i) + variables.CLONO2(i) + variables.HO2NO2(i) +...
        variables.NO3(i) + variables.NO(i) + variables.NO2(i) + variables.HNO3(i) + variables.N2O5(i).*2;
    
    % I dont have all HO species in so there wont be continuity here.
    family.HOY(i) = variables.HO2(i) + variables.OH(i) + variables.H2O2(i).*2 +...
        variables.HO2NO2(i) + variables.HNO3(i) + variables.HOBR(i) + variables.HOCL(i) + variables.HCL(i) + variables.HBR(i);

end