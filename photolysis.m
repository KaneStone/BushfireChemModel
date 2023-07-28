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
%     photoReaction.O.reactionID = [1;1;3;6;8;10;64];
%     photoReaction.O.vars = {'O2','O2','O3','NO2','NO3','N2O5','CLO'};
%     for k = 1:length(photoReaction.O.reactionID)
%         rates.O.production(k) = photo.data(photoReaction.O.reactionID(k)).*atmosphere.atLevel.(photoReaction.O.vars{k}).nd(step.doy);
%     end
    
    % CLONO2
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
        if sum(contains(fields,photoReaction.CLO.vars{k}))
            rates.CLO.production(k) = photo.data(photoReaction.CLO.preactionID(k)).*variables.(photoReaction.CLO.vars{k})(timeind);
        else
            rates.CLO.production(k) = photo.data(photoReaction.CLO.preactionID(k)).*atmosphere.atLevel.(photoReaction.CLO.vars{k}).nd(step.doy);
        end
    end
    
    % CL2
    photoReaction.CL2.dreactionID = [62];    
    for k = 1:length(photoReaction.CL2.dreactionID)
        rates.CL2.destruction(k) = photo.data(photoReaction.CL2.dreactionID(k)).*variables.CL2(timeind);        
    end    
    
%     % CL
%     photoReaction.CL.preactionID = [62,63,64,67,68,69,73,74,75,103];    
%     photoReaction.CL.vars = {'CL2','CLO','CLO','CL2O2','HCL','HOCL','CLONO2','CLONO2','CCL4','BRCL'};
%     for k = 1:length(photoReaction.CL.preactionID)
%         fields = fieldnames(variables);
%         if sum(contains(fields,photoReaction.CL.vars{k}))
%             rates.CL.production(k) = photo.data(photoReaction.CL.preactionID(k)).*variables.(photoReaction.CL.vars{k})(timeind);
%         else
%             rates.CL.production(k) = photo.data(photoReaction.CL.preactionID(k)).*atmosphere.atLevel.(photoReaction.CL.vars{k}).nd(step.doy);
%         end
%     end    
    
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
    
end

    
