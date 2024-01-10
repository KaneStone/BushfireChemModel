function [photo,rates,sza,kv] = photolysis(inputs,step,atmosphere,variables,photoload,jacobian)

    kv = [];
    % HO2NO2 pathway factor
    HO2NO2pwf = .3/.7;

    switch inputs.whichphoto
        case 'inter'
            % TUV code first
            createTUVinput(inputs,atmosphere,step)

            % run TUV code from matlab system command. (create bash script)
            system('/bin/zsh runTUV.sh');

            % read in TUV output
            [TUVtemp,sza] = readinTUVoutput('TUV5.4/output/output.txt',118,208);
            photo.altitude = TUVtemp(:,1);
            photo.data = TUVtemp(inputs.altitude,2:end);
            photo.dataall = TUVtemp(:,1:end)';                
            rates = [];
        case 'load'                        
            
            photo.data = photoload.pout(step.photoInd,2:end); % remove first column which is altitude data
            sza = [];
            
    end
    
%     % TUV code first
%     createTUVinput(inputs,atmosphere,step)
%     
%     % run TUV code from matlab system command. (create bash script)
%     system('/bin/zsh runTUV.sh');
%     
%     % read in TUV output
%     [TUVtemp,sza] = readinTUVoutput('/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushChemModel/TUV5.4/output/output.txt',118,208);
%     photo.altitude = TUVtemp(:,1);
%     photo.data = TUVtemp(inputs.altitude+1,2:end);
    
    if inputs.photosave
        return
    end
    
    % O3
    rates.O3.destruction(1) = photo.data(2).*variables.O3;
    rates.O3.destruction(2) = photo.data(3).*variables.O3;
    
    % O
    rates.O.production(1) = photo.data(1).*atmosphere.atLevel.O2.nd(step.doy).*2;
    rates.O.production(2) = rates.O3.destruction(2); 
    rates.O.production(3) = photo.data(4).*variables.HO2;
    rates.O.production(4) = photo.data(6).*variables.NO2;
    rates.O.production(5) = photo.data(8).*variables.NO3;
    rates.O.production(6) = photo.data(64).*variables.CLO;
    rates.O.production(7) = photo.data(95).*variables.BRO;
    
    % O1D
    rates.O1D.production(1) = rates.O3.destruction(1); 
    rates.O1D.production(2) = photo.data(9).*atmosphere.atLevel.N2O.nd(step.doy);
    rates.O1D.production(3) = photo.data(63).*variables.CLO;
       
    % CLONO2 
     rates.CLONO2.destruction(1) = photo.data(73).*variables.CLONO2;
     rates.CLONO2.destruction(2) = photo.data(74).*variables.CLONO2;
    
    % HCL
    rates.HCL.destruction(1) = photo.data(68).*variables.HCL;

    % OCLO
    rates.OCLO.destruction(1) = photo.data(66).*variables.OCLO;     

    % CLO
    rates.CLO.destruction(1) = rates.O.production(6);   
    rates.CLO.destruction(2) = rates.O1D.production(3);
    
    rates.CLO.production(1) = rates.OCLO.destruction(1);
    rates.CLO.production(2) = rates.CLONO2.destruction(2); 

    % BRCL
    rates.BRCL.destruction(1) = photo.data(103).*variables.BRCL;        

    % CL2
    rates.CL2.destruction(1) = photo.data(62).*variables.CL2;   

    %CL2O2
    rates.CL2O2.destruction(1) = photo.data(67).*variables.CL2O2;

    %HOCL
    rates.HOCL.destruction(1) = photo.data(69).*variables.HOCL;
    
    % CL
    rates.CL.production(1) = rates.CL2.destruction(1).*2;
    rates.CL.production(2) = rates.CLO.destruction(1); 
    rates.CL.production(3) = rates.CLO.destruction(2); 
    rates.CL.production(4) = rates.CL2O2.destruction(1).*2;
    rates.CL.production(5) = rates.HOCL.destruction(1);
    rates.CL.production(6) = rates.CLONO2.destruction(1); 
    rates.CL.production(7) = rates.BRCL.destruction(1);        
    rates.CL.production(8) = rates.HCL.destruction(1);

    % BRONO2
    rates.BRONO2.destruction(1) = photo.data(101).*variables.BRONO2;        
    rates.BRONO2.destruction(2) = photo.data(102).*variables.BRONO2;        

    % BRO  
    rates.BRO.destruction(1) = rates.O.production(7);        
    
    rates.BRO.production(1) = rates.BRONO2.destruction(1);     
    
    % HOBR    
    rates.HOBR.destruction(1) = photo.data(96).*variables.HOBR;  
    
    % BR
    rates.BR.production(1) = rates.BRO.destruction(1);
    rates.BR.production(2) = rates.HOBR.destruction(1);
    rates.BR.production(3) = rates.BRONO2.destruction(2);
    rates.BR.production(4) = rates.BRCL.destruction(1);

    % N2O5
    rates.N2O5.destruction(1) = photo.data(11).*variables.N2O5;
     

    % HNO3
    rates.HNO3.destruction(1) = photo.data(13).*variables.HNO3;
    
    % HO2NO2
    rates.HO2NO2.destruction(1) = photo.data(14).*variables.HO2NO2.*1./HO2NO2pwf;% to account for second photolysis pathway that isnt in TUV
    rates.HO2NO2.destruction(2) = photo.data(14).*variables.HO2NO2;

    % NO3
    rates.NO3.destruction(1) = photo.data(7).*variables.NO3;
    rates.NO3.destruction(2) = rates.O.production(5);
    
    rates.NO3.production(1) = rates.N2O5.destruction(1);
    rates.NO3.production(2) = rates.CLONO2.destruction(1);
    rates.NO3.production(3) = rates.BRONO2.destruction(2);
    rates.NO3.production(4) = rates.HO2NO2.destruction(2); 
    
    % NO2
    rates.NO2.destruction(1) = rates.O.production(4);
    
    rates.NO2.production(1) = rates.NO3.destruction(2);    
    rates.NO2.production(2) = rates.N2O5.destruction(1);
    rates.NO2.production(3) = rates.HNO3.destruction(1);
    rates.NO2.production(4) = rates.CLONO2.destruction(2);
    rates.NO2.production(5) = rates.BRONO2.destruction(1);
    rates.NO2.production(6) = rates.HO2NO2.destruction(1);

    % NO    
    rates.NO.production(1) = rates.NO2.destruction(1);
    rates.NO.production(2) = rates.NO3.destruction(1); 
       
    % HO2        
    rates.HO2.destruction(1) = rates.O.production(3);

    rates.HO2.production(1) = rates.HO2NO2.destruction(1);
    
    
    % H2O2        
    rates.H2O2.destruction(1) = photo.data(5).*variables.H2O2;
    

    % OH
    rates.OH.production(1) = rates.HO2.destruction(1);
    rates.OH.production(2) = rates.H2O2.destruction(1).*2;
    rates.OH.production(3) = rates.HNO3.destruction(1);
    rates.OH.production(4) = rates.HOBR.destruction(1);
    rates.OH.production(5) = rates.HOCL.destruction(1);
    rates.OH.production(6) = rates.HO2NO2.destruction(2);

    if inputs.outputrates && ~jacobian
        kv.jO3_O1D_O2 = rates.O3.destruction(1);
        kv.jO3_O3P_O2 = rates.O3.destruction(2);
        kv.jO2_2O = rates.O.production(1);        
        
        kv.jNO2_NO_O = rates.O.production(4);
        kv.jNO3_O3P_NO2 = rates.O.production(5);
        kv.jNO3_NO_O2 = rates.NO3.destruction(1);
        kv.jN2O_O1D = rates.O1D.production(2);
        kv.jN2O5_NO2_NO3 = rates.N2O5.destruction(1);
        kv.jHNO3_OH_NO2 = rates.HNO3.destruction(1);
        kv.jHO2NO2_HO2_NO2 = rates.HO2NO2.destruction(2);
        kv.jHO2NO2_HO_NO3 = rates.HO2NO2.destruction(1);
        
        kv.jCLO_O3P_CL = rates.O.production(6);                
        kv.jCLO_O1D_CL = rates.O1D.production(3);                
        kv.jCLONO2_CL_NO3 = rates.CLONO2.destruction(1);
        kv.jCLONO2_CLO_NO2 = rates.CLONO2.destruction(2);
        kv.jHCL_CL_H = rates.HCL.destruction(1);
        kv.jOCLO_O_CLO = rates.OCLO.destruction(1);
        kv.jCL2_2CL = rates.CL2.destruction(1);
        % actually produces CL + CLOO, but CLOO will immediately either
        % photolyze or reac with M to produce CL + O2
        kv.jCL2O2_CL_2CL = rates.CL2O2.destruction(1);  
        kv.jHOCL_HO_CL = rates.HOCL.destruction(1);
        
        kv.jBRO_O3P_BR = rates.O.production(7);
        kv.jBRCL_BR_CL = rates.BRCL.destruction(1);        
        kv.jBRONO2_BRO_NO2 = rates.BRONO2.destruction(1);
        kv.jBRONO2_BR_NO3 = rates.BRONO2.destruction(2);                
        kv.jHOBR_OH_BR = rates.HOBR.destruction(1);
        
        kv.jHO2_OH_O = rates.O.production(3);
        kv.H2O2_2OH = rates.H2O2.destruction(1);
    end
    
end

    
