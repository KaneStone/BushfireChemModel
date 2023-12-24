function [rates,photo,photoout] = rates(inputs,step,atmosphere,variables,i,photoload,photoout,RN)
    
    [photo,~,rates,SZA] = photolysis(inputs,step,atmosphere,variables,i,photoload,RN);                
    %SZA2(i) = SZA;   
    
    if inputs.photosave
        photoout(i,:,:) = photo.dataall;
        SZA2(i) = SZA;
        inputs.timesteps - i;
        return
    end
    
    % gas phase rates
    [rates] = gasphasecontrol(step,variables,atmosphere,i,rates,photo.data,RN);
    
    % heterogeneous rates
    [rates] = hetcontrol(inputs,step,variables,atmosphere,i,rates,RN);
    
end