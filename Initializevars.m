function variables = Initializevars(inputs)

    % initializing variables at time step 1
    variables.altitude = 1:inputs.modeltop;
    variables.pressure = table2array(readinancil('/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/ChemModel/ancil/Melbourne_pressure_monthly.dat'));
    variables.pressure = variables.pressure(1:inputs.modeltop,2:end);
    variables.T = table2array(readinancil('/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/ChemModel/ancil/Melbourne_temperature_monthly.dat'));
    variables.T = variables.T(1:inputs.modeltop,2:end);
    variables.O3.nd = table2array(readinancil('/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/ChemModel/ancil/Melbourne_ozone_monthly.dat'));    
    variables.O3.nd = variables.O3.nd(1:inputs.modeltop,2:end);
    variables.O3.vmr = variables.O3.nd.*inputs.boltz.*variables.T./(variables.pressure.*1e-6);                 
    
    variables.O3.vmr = variables.O3.vmr(20,1);
    variables.O3.nd = variables.O3.nd(20,1);
    variables.pressure = variables.pressure(20,1);
    variables.T = variables.T(20,1);
    switch inputs.region
        case 'midlatitudes'            
            variables.HCl = .75.*1e-9; 
            variables.ClONO2 = .75.*1e-10; 
            variables.ClO = .75.*1e-11;
            variables.HOCl = .75.*1e-12;
            variables.H2O = 4.*1e-6;
        case 'southpole'            
            variables.HCl = [.5 .75 1].*1e-9; 
            variables.ClONO2 = [.5 .75 1].*1e-10; 
            variables.ClO = [.5 .75 1].*1e-11;
            variables.HOCl = [.5 .75 1].*1e-12;
    end
    
    %%
    
    % I also need temperature profile, density profile, wavelength profile

end
