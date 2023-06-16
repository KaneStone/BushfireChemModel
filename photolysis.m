function [photo,photoNamlist,rates] = photolysis(inputs,step,atmosphere,variables,j,i,photo,rates)

    % TUV code first
    createTUVinput(inputs,atmosphere,step)
    
    % run TUV code from matlab system command. (create bash script)
    system('/bin/zsh runTUV.sh');
    
    % read in TUV output
    TUVtemp = readinTUVoutput('/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushChemModel/TUV5.4/output/output.txt',118,208);
    photo.altitude = TUVtemp(:,1);
    photo.data(j,:) = TUVtemp(inputs.altitude+1,2:end);
    
    % createTUV namelist for separate molecules.
    photoNamlist = TUVnamelist;
    photoReaction.O3.reactionID = [2;3];
    
    rates.O3.destruction(1,j) = sum(photo.data(j,photoReaction.O3.reactionID).*variables.O3(i));
    
    
    photoReaction.O.reactionID = [1;3;6;8;10;64];
    photoReaction.O.vars = {'O2','O3','NO2','NO3','N2O5','CLO'};
    for k = 1:length(photoReaction.O.reactionID)
        rates.O.production(k) = photo.data(photoReaction.O.reactionID(k)).*atmosphere.atLevel.(photoReaction.O.vars{k}).nd(step.doy);
    end
    
end

    
