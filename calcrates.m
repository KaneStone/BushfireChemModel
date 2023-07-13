function [rates,photo,photoout] = calcrates(inputs,step,atmosphere,variables,dayaverage,i,photoload,photoout,climScaleFactor,SZAdiff)


    [photo,TUVnamelist,rates,SZA] = photolysis(inputs,step,atmosphere,variables,i,photoload);                
    %SZA2(i) = SZA;   
    
    if inputs.photosave
        photoout(i,:,:) = photo.dataall;
        SZA2(i) = SZA;
        inputs.timesteps - i;
        return
    end
    
    % gas phase rates
    rates = gasphaserates(inputs,step,variables,dayaverage,atmosphere,i,rates,photo.data,climScaleFactor,SZAdiff);
    
end