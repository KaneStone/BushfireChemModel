function [photo,rates,sza] = photolysis(inputs,step,atmosphere,variables,photoload)

timeind = 1;

    % HO2NO2 pathway factor
    HO2NO2pwf = .3/.7;

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

    %photo.data(10) = photo.data(11).*.3
    %photo.data(11) = photo.data(11).*0;
    
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
    %photoNamlist = TUVnamelist;
    if inputs.photosave
        return
    end
    %fields = fieldnames(variables);
%     
    %photoReaction.O3.reactionID = [2;3];
    
    % O3
    rates.O3.destruction(1) = photo.data(2).*variables.O3(timeind);
    rates.O3.destruction(2) = photo.data(3).*variables.O3(timeind);
    
    % O

    rates.O.production(1) = photo.data(1).*atmosphere.atLevel.O2.nd(step.doy).*2;
    rates.O.production(2) = rates.O3.destruction(2); %photo.data(3).*variables.O3(timeind);
    rates.O.production(3) = photo.data(4).*variables.HO2(timeind);
    rates.O.production(4) = photo.data(6).*variables.NO2(timeind);
    rates.O.production(5) = photo.data(8).*variables.NO3(timeind);
    rates.O.production(6) = photo.data(64).*variables.CLO(timeind);
    rates.O.production(7) = photo.data(95).*variables.BRO(timeind);
    
    
%     photoReaction.O.reactionID = [1;1;3;4;6;8;64];
%     photoReaction.O.vars = {'O2','O2','O3','HO2','NO2','NO3','CLO'};
            
%     for k = 1:length(photoReaction.O.reactionID)
%         
%         if sum(strcmp(vars,photoReaction.O.vars{k}))
%             rates.O.production(k) = photo.data(photoReaction.O.reactionID(k)).*variables.(photoReaction.O.vars{k})(timeind);
%         else
%             rates.O.production(k) = photo.data(photoReaction.O.reactionID(k)).*atmosphere.atLevel.(photoReaction.O.vars{k}).nd(step.doy);
%         end
%     end
%     
    % O1D
    rates.O1D.production(1) = rates.O3.destruction(1); %photo.data(2).*variables.O3(timeind);
    rates.O1D.production(2) = photo.data(9).*atmosphere.atLevel.N2O.nd(step.doy);
    
%     photoReaction.O1D.reactionID = [2;9];
%     photoReaction.O1D.vars = {'O3','N2O'};
%     for k = 1:length(photoReaction.O1D.reactionID)        
%         if sum(strcmp(vars,photoReaction.O1D.vars{k}))
%             rates.O1D.production(k) = photo.data(photoReaction.O1D.reactionID(k)).*variables.(photoReaction.O1D.vars{k})(timeind);
%         else
%             rates.O1D.production(k) = photo.data(photoReaction.O1D.reactionID(k)).*atmosphere.atLevel.(photoReaction.O1D.vars{k}).nd(step.doy);
%         end
%     end
       
    % CLONO2 
    
     rates.CLONO2.destruction(1) = photo.data(73).*variables.CLONO2(timeind);
     rates.CLONO2.destruction(2) = photo.data(74).*variables.CLONO2(timeind);
    
%     photoReaction.CLONO2.reactionID = [73;74];
%     for k = 1:length(photoReaction.CLONO2.reactionID)
%         rates.CLONO2.destruction(k) = photo.data(photoReaction.CLONO2.reactionID(k)).*variables.CLONO2(timeind);
%     end
    
    % HCL
    rates.HCL.destruction(1) = photo.data(68).*variables.HCL(timeind);
    
%     photoReaction.HCL.reactionID = [68];
%     for k = 1:length(photoReaction.HCL.reactionID)
%         rates.HCL.destruction(k) = photo.data(photoReaction.HCL.reactionID(k)).*variables.HCL(timeind);
%     end
    
    % OCLO
    rates.OCLO.destruction(1) = photo.data(66).*variables.OCLO(timeind);     
%     photoReaction.OCLO.dreactionID = 66;
%     for k = 1:length(photoReaction.OCLO.dreactionID)
%         rates.OCLO.destruction(k) = photo.data(photoReaction.OCLO.dreactionID(k)).*variables.OCLO(timeind);        
%     end
    


    % CLO
    
    %rates.CLO.destruction(1) = photo.data(63).*variables.CLO(timeind);   
    rates.CLO.destruction(1) = photo.data(64).*variables.CLO(timeind);   
    
    rates.CLO.production(1) = rates.OCLO.destruction(1);
    rates.CLO.production(2) = rates.CLONO2.destruction(2); %photo.data(74).*variables.CLONO2(timeind);
    
%     photoReaction.CLO.dreactionID = 64; %[63,64] 63 is not really important.
%     photoReaction.CLO.preactionID = [66,74];
%    
%     for k = 1:length(photoReaction.CLO.dreactionID)
%             rates.CLO.destruction(k) = photo.data(photoReaction.CLO.dreactionID(k)).*variables.CLO(timeind);        
%     end
%     
%     photoReaction.CLO.vars = {'OCLO','CLONO2'};
%     for k = 1:length(photoReaction.CLO.preactionID)        
%         if sum(strcmp(vars,photoReaction.CLO.vars{k}))
%             rates.CLO.production(k) = photo.data(photoReaction.CLO.preactionID(k)).*variables.(photoReaction.CLO.vars{k})(timeind);
%         else
%             rates.CLO.production(k) = photo.data(photoReaction.CLO.preactionID(k)).*atmosphere.atLevel.(photoReaction.CLO.vars{k}).nd(step.doy);
%         end
%     end
    
    % BRCL
    rates.BRCL.destruction(1) = photo.data(103).*variables.BRCL(timeind);        
%     photoReaction.BRCL.dreactionID = 103;
%     for k = 1:length(photoReaction.BRCL.dreactionID)
%         rates.BRCL.destruction(k) = photo.data(photoReaction.BRCL.dreactionID(k)).*variables.BRCL(timeind);        
%     end
    
    % CL2
    rates.CL2.destruction(1) = photo.data(62).*variables.CL2(timeind);   
%     photoReaction.CL2.dreactionID = [62];    
%     for k = 1:length(photoReaction.CL2.dreactionID)
%         rates.CL2.destruction(k) = photo.data(photoReaction.CL2.dreactionID(k)).*variables.CL2(timeind);        
%     end    
    

    %CL2O2
    rates.CL2O2.destruction(1) = photo.data(67).*variables.CL2O2(timeind);
%     photoReaction.CL2O2.dreactionID = 67;
%     for k = 1:length(photoReaction.CL2O2.dreactionID)
%         rates.CL2O2.destruction(k) = photo.data(photoReaction.CL2O2.dreactionID(k)).*variables.CL2O2(timeind);
%     end

    %HOCL
    rates.HOCL.destruction(1) = photo.data(69).*variables.HOCL(timeind);
%     photoReaction.HOCL.dreactionID = 69;
%     for k = 1:length(photoReaction.HOCL.dreactionID)
%         rates.HOCL.destruction(k) = photo.data(photoReaction.HOCL.dreactionID(k)).*variables.HOCL(timeind);
%     end
    
    % CL
%     photoReaction.CL.preactionID = [62,62,64,67,69,73,103];    
%     photoReaction.CL.vars = {'CL2','CL2','CLO','CL2O2','HOCL','CLONO2','BRCL'};
%     
%     for k = 1:length(photoReaction.CL.preactionID)
% %         if i == 1
% %             reaction_namelist.CL.production{k,1} = ['J ',photoNamlist{photoReaction.CL.preactionID(k)}];
% %         end                
%         if sum(strcmp(vars,photoReaction.CL.vars{k}))
%             rates.CL.production(k) = photo.data(photoReaction.CL.preactionID(k)).*variables.(photoReaction.CL.vars{k})(timeind);
%         else
%             rates.CL.production(k) = photo.data(photoReaction.CL.preactionID(k)).*atmosphere.atLevel.(photoReaction.CL.vars{k}).nd(step.doy);
%         end
%     end        
    
%     photoReaction.CL.preactionID = [62,62,64,67,69,73,103];    
%     photoReaction.CL.vars = {'CL2','CL2','CLO','CL2O2','HOCL','CLONO2','BRCL'};
    
    %tic;
    rates.CL.production(1) = rates.CL2.destruction(1).*2;% photo.data(62).*variables.CL2(timeind);
    %rates.CL.production(2) = photo.data(62).*variables.CL2(timeind);
    rates.CL.production(2) = rates.CLO.destruction(1); %photo.data(64).*variables.CLO(timeind);
    rates.CL.production(3) = rates.CL2O2.destruction(1).*2; %photo.data(67).*variables.CL2O2(timeind);
    rates.CL.production(4) = rates.HOCL.destruction(1); %photo.data(69).*variables.HOCL(timeind);
    rates.CL.production(5) = rates.CLONO2.destruction(1); %photo.data(73).*variables.CLONO2(timeind);
    rates.CL.production(6) = rates.BRCL.destruction(1); %photo.data(103).*variables.BRCL(timeind);        
    %toc;
          
    
    % BRONO2
    
    rates.BRONO2.destruction(1) = photo.data(101).*variables.BRONO2(timeind);        
    rates.BRONO2.destruction(2) = photo.data(102).*variables.BRONO2(timeind);        
    
%     photoReaction.BRONO2.dreactionID = [101,102];       
%     for k = 1:length(photoReaction.BRONO2.dreactionID)
%     
%     end        
    
    % BRO
    
    rates.BRO.destruction(1) = photo.data(95).*variables.BRO(timeind);        
    
    rates.BRO.production(1) = rates.BRONO2.destruction(1);     
    
%     photoReaction.BRO.preactionID = 101;
%     photoReaction.BRO.dreactionID = 95;
%     photoReaction.BRO.vars = {'BRONO2'};
%     for k = 1:length(photoReaction.BRO.dreactionID)
%         rates.BRO.destruction(k) = photo.data(photoReaction.BRO.dreactionID(k)).*variables.BRO(timeind);        
%     end
%     
%     %production
%     for k = 1:length(photoReaction.BRO.preactionID)
%         rates.BRO.production(k) = photo.data(photoReaction.BRO.preactionID(k)).*atmosphere.atLevel.(photoReaction.BRO.vars{k}).nd(step.doy);     
%     end
%     
    
    % HOBR    
    rates.HOBR.destruction(1) = photo.data(96).*variables.HOBR(timeind);  
    
%     photoReaction.HOBR.dreactionID = 96;
%     
%     for k = 1:length(photoReaction.HOBR.dreactionID)
%         rates.HOBR.destruction(k) = photo.data(photoReaction.HOBR.dreactionID(k)).*variables.HOBR(timeind);        
%     end
    

    
    % BR
    
     rates.BR.production(1) = rates.BRO.destruction(1);
     rates.BR.production(2) = rates.HOBR.destruction(1);
     rates.BR.production(3) = rates.BRONO2.destruction(2);
     rates.BR.production(4) = rates.BRCL.destruction(1);
    
% %     photoReaction.BR.preactionID = [95,96,102,103,105,105,105,104];    
% %     photoReaction.BR.vars = {'BRO','HOBR','BRONO2','BRCL','CHBR3','CHBR3','CHBR3','CH3BR'};        
%     photoReaction.BR.preactionID = [95,96,102,103];    
%     photoReaction.BR.vars = {'BRO','HOBR','BRONO2','BRCL'};        
%     %production
%     for k = 1:length(photoReaction.BR.preactionID)
%         rates.BR.production(k) = photo.data(photoReaction.BR.preactionID(k)).*atmosphere.atLevel.(photoReaction.BR.vars{k}).nd(step.doy);     
%     end            
    
    % N2O5
    %photoReaction.N2O5.dreactionID = 11;
    rates.N2O5.destruction(1) = photo.data(11).*variables.N2O5(timeind);
    
%     %destruction
%     for k = 1:length(photoReaction.N2O5.dreactionID)
%         rates.N2O5.destruction(k) = photo.data(photoReaction.N2O5.dreactionID(k)).*variables.N2O5(timeind);
%     end        

    % HNO3
    
    rates.HNO3.destruction(1) = photo.data(13).*variables.HNO3(timeind);
    
%     photoReaction.HNO3.dreactionID = 13;
%     
%     %destruction
%     for k = 1:length(photoReaction.HNO3.dreactionID)
%         rates.HNO3.destruction(k) = photo.data(photoReaction.HNO3.dreactionID(k)).*variables.HNO3(timeind);
%     end
    
    % HO2NO2
    
    rates.HO2NO2.destruction(1) = photo.data(14).*variables.HO2NO2(timeind);% to account for second photolysis pathway that isnt in TUV
    rates.HO2NO2.destruction(2) = photo.data(14).*variables.HO2NO2(timeind).*HO2NO2pwf;
    
%     photoReaction.HO2NO2.dreactionID = 14;
%     
%     %destruction
%     for k = 1:length(photoReaction.HO2NO2.dreactionID)
%         rates.HO2NO2.destruction(k) = photo.data(photoReaction.HO2NO2.dreactionID(k)).*variables.HO2NO2(timeind).*1.5;
%     end

    % NO3
    
    rates.NO3.destruction(1) = photo.data(7).*variables.NO3(timeind);
    rates.NO3.destruction(2) = photo.data(8).*variables.NO3(timeind);
    
    rates.NO3.production(1) = rates.N2O5.destruction(1);
    rates.NO3.production(2) = rates.CLONO2.destruction(1);
    rates.NO3.production(3) = rates.BRONO2.destruction(2);
    rates.NO3.production(4) = rates.HO2NO2.destruction(2); %.5 to account for second photolysis pathway that isnt in TUV
    
    
%     photoReaction.NO3.dreactionID = [7,8];
%     photoReaction.NO3.preactionID = [11,73,102,14]; %using HO2NO2 -> NO2 becuase dont have NO3 data here.
%     photoReaction.NO3.vars = {'N2O5','CLONO2','BRONO2','HO2NO2'};
%     
%     %production
%     for k = 1:length(photoReaction.NO3.preactionID)        
%         if sum(strcmp(vars,photoReaction.NO3.vars{k}))
%             rates.NO3.production(k) = photo.data(photoReaction.NO3.preactionID(k)).*variables.(photoReaction.NO3.vars{k})(timeind);
%         else
%             rates.NO3.production(k) = photo.data(photoReaction.NO3.preactionID(k)).*atmosphere.atLevel.(photoReaction.NO3.vars{k}).nd(step.doy);
%         end        
%     end   
%     rates.NO3.production(end) = rates.NO3.production(end).*.5;
%     
%     %destruction
%     for k = 1:length(photoReaction.NO3.dreactionID)
%         rates.NO3.destruction(k) = photo.data(photoReaction.NO3.dreactionID(k)).*variables.NO3(timeind);
%     end
    
    % NO2
    rates.NO2.destruction(1) = photo.data(6).*variables.NO2(timeind);
    
    rates.NO2.production(1) = rates.NO3.destruction(2);
    rates.NO2.production(2) = rates.N2O5.destruction(1);
    rates.NO2.production(3) = rates.HNO3.destruction(1);
    rates.NO2.production(4) = rates.CLONO2.destruction(2);
    rates.NO2.production(5) = rates.BRONO2.destruction(1);
    rates.NO2.production(6) = rates.HO2NO2.destruction(1);
    
%     photoReaction.NO2.dreactionID = 6;
%     photoReaction.NO2.preactionID = [8,11,13,74,101,14];
%     photoReaction.NO2.vars = {'NO3','N2O5','HNO3','CLONO2','BRONO2','HO2NO2'};
%     
%     %production
%     for k = 1:length(photoReaction.NO2.preactionID)        
%         if sum(strcmp(vars,photoReaction.NO2.vars{k}))
%             rates.NO2.production(k) = photo.data(photoReaction.NO2.preactionID(k)).*variables.(photoReaction.NO2.vars{k})(timeind);
%         else
%             rates.NO2.production(k) = photo.data(photoReaction.NO2.preactionID(k)).*atmosphere.atLevel.(photoReaction.NO2.vars{k}).nd(step.doy);
%         end
%     end   
%     %rates.NO2.production(end) = rates.NO2.production(end).*.7;
%     %destruction
%     for k = 1:length(photoReaction.NO2.dreactionID)
%         rates.NO2.destruction(k) = photo.data(photoReaction.NO2.dreactionID(k)).*variables.NO2(timeind);
%     end
%     

    % NO    
    
    rates.NO.production(1) = rates.NO2.destruction(1);
    rates.NO.production(2) = rates.NO3.destruction(1);
    
% %     photoReaction.NO.preactionID = [6,7,10];
% %     photoReaction.NO.vars = {'NO2','NO3','N2O5'};    
%     photoReaction.NO.preactionID = [6,7];
%     photoReaction.NO.vars = {'NO2','NO3'};    
%     %production
%     for k = 1:length(photoReaction.NO.preactionID)        
%         if sum(strcmp(vars,photoReaction.NO.vars{k}))
%             rates.NO.production(k) = photo.data(photoReaction.NO.preactionID(k)).*variables.(photoReaction.NO.vars{k})(timeind);
%         else
%             rates.NO.production(k) = photo.data(photoReaction.NO.preactionID(k)).*atmosphere.atLevel.(photoReaction.NO.vars{k}).nd(step.doy);
%         end
%     end   
%     %rates.NO.destruction(1) = 0;
    
       
    % HO2        
    
    rates.HO2.destruction(1) = photo.data(4).*variables.HO2(timeind);
    
    rates.HO2.production(1) = rates.HO2NO2.destruction(1);
    
%     photoReaction.HO2.preactionID = [14];
%     photoReaction.HO2.dreactionID = [4];
%     photoReaction.HO2.vars = {'HO2NO2'};
%     %production
%     for k = 1:length(photoReaction.HO2.preactionID)
%         if sum(strcmp(vars,photoReaction.HO2.vars{k}))
%             rates.HO2.production(k) = photo.data(photoReaction.HO2.preactionID(k)).*variables.(photoReaction.HO2.vars{k})(timeind);
%         else
%             rates.HO2.production(k) = photo.data(photoReaction.HO2.preactionID(k)).*atmosphere.atLevel.(photoReaction.HO2.vars{k}).nd(step.doy);
%         end        
%     end
%     
%     %destruction
%     for k = 1:length(photoReaction.HO2.dreactionID)
%         rates.HO2.destruction(k) = photo.data(photoReaction.HO2.dreactionID(k)).*variables.HO2(timeind);
%     end
%     %rates.HO2.destruction(end) = rates.HO2.destruction(end)./2;
    
    
    % H2O2        
    
    rates.H2O2.destruction(1) = photo.data(5).*variables.H2O2(timeind);
    
%     photoReaction.H2O2.dreactionID = 5;            
%     %destruction
%     for k = 1:length(photoReaction.H2O2.dreactionID)
%         rates.H2O2.destruction(k) = photo.data(photoReaction.H2O2.dreactionID(k)).*variables.H2O2(timeind);
%     end
    

    % OH
    % dont havae HO2NO2 -> OH + NO3, so will use reaction HON2NO2 -> HO2 +
    % NO2 divided by 2 as a proxy.

    rates.OH.production(1) = rates.HO2.destruction(1);
    rates.OH.production(2) = rates.H2O2.destruction(1).*2;
    rates.OH.production(3) = rates.HNO3.destruction(1);
    rates.OH.production(4) = rates.HOBR.destruction(1);
    rates.OH.production(5) = rates.HOCL.destruction(1);
    rates.OH.production(6) = rates.HO2NO2.destruction(2); %.5 to account for second photolysis pathway that isnt in TUV
    
%     photoReaction.OH.preactionID = [4,5,5,13,14];
%     photoReaction.OH.vars = {'HO2','H2O2','H2O2','HNO3','HO2NO2'};
%     %production
%     for k = 1:length(photoReaction.OH.preactionID)
%         if sum(strcmp(vars,photoReaction.OH.vars{k}))
%             rates.OH.production(k) = photo.data(photoReaction.OH.preactionID(k)).*variables.(photoReaction.OH.vars{k})(timeind);
%         else
%             rates.OH.production(k) = photo.data(photoReaction.OH.preactionID(k)).*atmosphere.atLevel.(photoReaction.OH.vars{k}).nd(step.doy);
%         end        
%     end
%     rates.OH.production(end) = rates.OH.production(end).*.5;
        
end

    
