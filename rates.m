function [rate,photo,photoout] = rates(inputs,step,atmosphere,variables,i,photoload,photoout,RN,vars,climScaleFactor)
    
    [photo,rate,SZA] = photolysis(inputs,step,atmosphere,variables,i,photoload,RN,vars);                
    %SZA2(i) = SZA;   
    
    if inputs.photosave
        photoout(i,:,:) = photo.dataall;
        SZA2(i) = SZA;
        inputs.timesteps - i;
        return
    end
    
    % gas phase rates
    [rate] = gasphasecontrol(inputs,step,variables,atmosphere,i,rate,photo.data,RN,climScaleFactor);
    
    % heterogeneous rates
    [rate] = hetcontrol(inputs,step,variables,atmosphere,i,rate,RN);
    
    
    
end