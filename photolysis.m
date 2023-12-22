function [photo,photoNamlist,rates,sza] = photolysis(inputs,step,atmosphere,variables,i,photoload,RN)

    if RN
        timeind = 1;
    else
        timeind = i;
    end

    switch inputs.whichphoto
        case 'inter'
            % TUV code first
            createTUVinput(inputs,atmosphere,step)

            % run TUV code from matlab system command. (create bash script)
            system('/bin/zsh runTUV.sh');

            % read in TUV output
            [TUVtemp,sza] = readinTUVoutput('/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushChemModel/TUV5.4/output/output.txt',118,208);
            photo.altitude = TUVtemp(:,1);
            photo.data = TUVtemp(inputs.altitude+1,2:end);
            photo.dataall = TUVtemp(:,1:end)';
    
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
    

    % createTUV namelist for separate molecules.
    photoNamlist = TUVnamelist;
    if inputs.photosave
        return
    end
%     
    photoReaction.O3.reactionID = [2;3];
    
    % O3
    rates.O3.destruction(1) = sum(photo.data(photoReaction.O3.reactionID).*variables.O3(timeind));
    
    % O
    photoReaction.O.reactionID = [1;1;3;6;8;10;64];
    photoReaction.O.vars = {'O2','O2','O3','NO2','NO3','N2O5','CLO','H2O'};
    for k = 1:length(photoReaction.O.reactionID)
        fields = fieldnames(variables);
        if sum(strcmp(fields,photoReaction.O.vars{k}))
            rates.O.production(k) = photo.data(photoReaction.O.reactionID(k)).*variables.(photoReaction.O.vars{k})(timeind);
        else
            rates.O.production(k) = photo.data(photoReaction.O.reactionID(k)).*atmosphere.atLevel.(photoReaction.O.vars{k}).nd(step.doy);
        end
    end
       
    % CLONO2 CORRECT
    photoReaction.CLONO2.reactionID = [73;74];
    for k = 1:length(photoReaction.CLONO2.reactionID)
        rates.CLONO2.destruction(k) = photo.data(photoReaction.CLONO2.reactionID(k)).*variables.CLONO2(timeind);
    end
    
    % HCL
    photoReaction.HCL.reactionID = [68];
    for k = 1:length(photoReaction.HCL.reactionID)
        rates.HCL.destruction(k) = photo.data(photoReaction.HCL.reactionID(k)).*variables.HCL(timeind);
    end
    
    % CLO
    photoReaction.CLO.dreactionID = [63,64];
    photoReaction.CLO.preactionID = [66,74];
   
    for k = 1:length(photoReaction.CLO.dreactionID)
            rates.CLO.destruction(k) = photo.data(photoReaction.CLO.dreactionID(k)).*variables.CLO(timeind);        
    end
    
    photoReaction.CLO.vars = {'OCLO','CLONO2'};
    for k = 1:length(photoReaction.CLO.preactionID)
        fields = fieldnames(variables);
        if sum(strcmp(fields,photoReaction.CLO.vars{k}))
            rates.CLO.production(k) = photo.data(photoReaction.CLO.preactionID(k)).*variables.(photoReaction.CLO.vars{k})(timeind);
        else
            rates.CLO.production(k) = photo.data(photoReaction.CLO.preactionID(k)).*atmosphere.atLevel.(photoReaction.CLO.vars{k}).nd(step.doy);
        end
    end
    
    % OCLO
    photoReaction.OCLO.dreactionID = 66;
    for k = 1:length(photoReaction.OCLO.dreactionID)
        rates.OCLO.destruction(k) = photo.data(photoReaction.OCLO.dreactionID(k)).*variables.OCLO(timeind);        
    end
    
    % BRCL
    photoReaction.BRCL.dreactionID = 103;
    for k = 1:length(photoReaction.BRCL.dreactionID)
        rates.BRCL.destruction(k) = photo.data(photoReaction.BRCL.dreactionID(k)).*variables.BRCL(timeind);        
    end
    
    % CL2
    photoReaction.CL2.dreactionID = [62];    
    for k = 1:length(photoReaction.CL2.dreactionID)
        rates.CL2.destruction(k) = photo.data(photoReaction.CL2.dreactionID(k)).*variables.CL2(timeind);        
    end    
    
    % CL
    photoReaction.CL.preactionID = [62,62,63,64,67,68,69,73,75,103];    
    photoReaction.CL.vars = {'CL2','CL2','CLO','CLO','CL2O2','HCL','HOCL','CLONO2','CCL4','BRCL'};
    
    for k = 1:length(photoReaction.CL.preactionID)
        if i == 1
            reaction_namelist.CL.production{k,1} = ['J ',photoNamlist{photoReaction.CL.preactionID(k)}];
        end        
        fields = fieldnames(variables);
        if sum(strcmp(fields,photoReaction.CL.vars{k}))
            rates.CL.production(k) = photo.data(photoReaction.CL.preactionID(k)).*variables.(photoReaction.CL.vars{k})(timeind);
        else
            rates.CL.production(k) = photo.data(photoReaction.CL.preactionID(k)).*atmosphere.atLevel.(photoReaction.CL.vars{k}).nd(step.doy);
        end
    end    
    
    %CL2O2
    photoReaction.CL2O2.dreactionID = 67;
    for k = 1:length(photoReaction.CL2O2.dreactionID)
        rates.CL2O2.destruction(k) = photo.data(photoReaction.CL2O2.dreactionID(k)).*variables.CL2O2(timeind);
    end
    
    %HOCL
    photoReaction.HOCL.dreactionID = 69;
    for k = 1:length(photoReaction.HOCL.dreactionID)
        rates.HOCL.destruction(k) = photo.data(photoReaction.HOCL.dreactionID(k)).*variables.HOCL(timeind);
    end
    
    % BRO
    photoReaction.BRO.preactionID = 101;
    photoReaction.BRO.dreactionID = 95;
    photoReaction.BRO.vars = {'BRONO2'};
    for k = 1:length(photoReaction.BRO.dreactionID)
        rates.BRO.destruction(k) = photo.data(photoReaction.BRO.dreactionID(k)).*variables.BRO(timeind);        
    end
    
    %production
    for k = 1:length(photoReaction.BRO.preactionID)
        rates.BRO.production(k) = photo.data(photoReaction.BRO.preactionID(k)).*atmosphere.atLevel.(photoReaction.BRO.vars{k}).nd(step.doy);     
    end
    
    
    % HOBR    
    photoReaction.HOBR.dreactionID = 96;
    
    for k = 1:length(photoReaction.HOBR.dreactionID)
        rates.HOBR.destruction(k) = photo.data(photoReaction.HOBR.dreactionID(k)).*variables.HOBR(timeind);        
    end
    
    % BRONO2
    photoReaction.BRONO2.dreactionID = [101,102];       
    for k = 1:length(photoReaction.BRONO2.dreactionID)
        rates.BRONO2.destruction(k) = photo.data(photoReaction.BRONO2.dreactionID(k)).*variables.BRONO2(timeind);        
    end        
    
    % BR
    photoReaction.BR.preactionID = [95,96,102,103,105,105,105,104];    
    photoReaction.BR.vars = {'BRO','HOBR','BRONO2','BRCL','CHBR3','CHBR3','CHBR3','CH3BR'};        
    %production
    for k = 1:length(photoReaction.BR.preactionID)
        rates.BR.production(k) = photo.data(photoReaction.BR.preactionID(k)).*atmosphere.atLevel.(photoReaction.BR.vars{k}).nd(step.doy);     
    end
    
    
    % NO2
    photoReaction.NO2.dreactionID = 6;
    photoReaction.NO2.preactionID = [8,11,13,14,74,101];
    photoReaction.NO2.vars = {'NO3','N2O5','HNO3','HO2NO2','CLONO2','BRONO2'};
    
    %production
    for k = 1:length(photoReaction.NO2.preactionID)
        fields = fieldnames(variables);
        if sum(strcmp(fields,photoReaction.NO2.vars{k}))
            rates.NO2.production(k) = photo.data(photoReaction.NO2.preactionID(k)).*variables.(photoReaction.NO2.vars{k})(timeind);
        else
            rates.NO2.production(k) = photo.data(photoReaction.NO2.preactionID(k)).*atmosphere.atLevel.(photoReaction.NO2.vars{k}).nd(step.doy);
        end
    end   
    
    %destruction
    for k = 1:length(photoReaction.NO2.dreactionID)
        rates.NO2.destruction(k) = photo.data(photoReaction.NO2.dreactionID(k)).*variables.NO2(timeind);
    end
    
    % NO    
    photoReaction.NO.preactionID = [6,7,10];
    photoReaction.NO.vars = {'NO2','NO3','N2O5'};    
    %production
    for k = 1:length(photoReaction.NO.preactionID)
        fields = fieldnames(variables);
        if sum(strcmp(fields,photoReaction.NO.vars{k}))
            rates.NO.production(k) = photo.data(photoReaction.NO.preactionID(k)).*variables.(photoReaction.NO.vars{k})(timeind);
        else
            rates.NO.production(k) = photo.data(photoReaction.NO.preactionID(k)).*atmosphere.atLevel.(photoReaction.NO.vars{k}).nd(step.doy);
        end
    end   
    %rates.NO.destruction(1) = 0;
    
    % NO3
    photoReaction.NO3.dreactionID = [7,8];
    photoReaction.NO3.preactionID = [10,11,14];
    photoReaction.NO3.vars = {'N2O5','N2O5','HO2NO2'};
    
    %production
    for k = 1:length(photoReaction.NO3.preactionID)
        fields = fieldnames(variables);
        if sum(strcmp(fields,photoReaction.NO3.vars{k}))
            rates.NO3.production(k) = photo.data(photoReaction.NO3.preactionID(k)).*variables.(photoReaction.NO3.vars{k})(timeind);
        else
            rates.NO3.production(k) = photo.data(photoReaction.NO3.preactionID(k)).*atmosphere.atLevel.(photoReaction.NO3.vars{k}).nd(step.doy);
        end
    end   
    
    %destruction
    for k = 1:length(photoReaction.NO3.dreactionID)
        rates.NO3.destruction(k) = photo.data(photoReaction.NO3.dreactionID(k)).*variables.NO3(timeind);
    end
    
    % N2O5
    photoReaction.N2O5.dreactionID = [10,11];
    
    %destruction
    for k = 1:length(photoReaction.N2O5.dreactionID)
        rates.N2O5.destruction(k) = photo.data(photoReaction.N2O5.dreactionID(k)).*variables.N2O5(timeind);
    end
    
    % HNO3
    photoReaction.HNO3.dreactionID = [13];
    
    %destruction
    for k = 1:length(photoReaction.HNO3.dreactionID)
        rates.HNO3.destruction(k) = photo.data(photoReaction.HNO3.dreactionID(k)).*variables.HNO3(timeind);
    end
    
    % HO2NO2
    photoReaction.HO2NO2.dreactionID = [14];
    
    %destruction
    for k = 1:length(photoReaction.HO2NO2.dreactionID)
        rates.HO2NO2.destruction(k) = photo.data(photoReaction.HO2NO2.dreactionID(k)).*variables.HO2NO2(timeind);
    end
    
    % OH
    % dont havae HO2NO2 -> OH + NO3, so will use reaction HON2NO2 -> HO2 +
    % NO2 divided by 2 as a proxy.
    photoReaction.OH.preactionID = [4,5,5,13,14];
    photoReaction.OH.vars = {'HO2','H2O2','H2O2','HNO3','HO2NO2'};
    %production
    for k = 1:length(photoReaction.OH.preactionID)
        if sum(strcmp(fields,photoReaction.OH.vars{k}))
            rates.OH.production(k) = photo.data(photoReaction.OH.preactionID(k)).*variables.(photoReaction.OH.vars{k})(timeind);
        else
            rates.OH.production(k) = photo.data(photoReaction.OH.preactionID(k)).*atmosphere.atLevel.(photoReaction.OH.vars{k}).nd(step.doy);
        end
        rates.OH.production(end) = rates.OH.production(end)./2;
    end
    
    % HO2        
    photoReaction.HO2.preactionID = [14];
    photoReaction.HO2.dreactionID = [4];
    photoReaction.HO2.vars = {'HO2NO2'};
    %production
    for k = 1:length(photoReaction.HO2.preactionID)
        if sum(strcmp(fields,photoReaction.HO2.vars{k}))
            rates.HO2.production(k) = photo.data(photoReaction.HO2.preactionID(k)).*variables.(photoReaction.HO2.vars{k})(timeind);
        else
            rates.HO2.production(k) = photo.data(photoReaction.HO2.preactionID(k)).*atmosphere.atLevel.(photoReaction.HO2.vars{k}).nd(step.doy);
        end        
    end
    
    %destruction
    for k = 1:length(photoReaction.HO2.preactionID)
        rates.HO2.destruction(k) = photo.data(photoReaction.HO2.dreactionID(k)).*variables.HO2(timeind);
    end
end

    
