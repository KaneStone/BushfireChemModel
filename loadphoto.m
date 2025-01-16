function [photoout,photoload,photolength] = loadphoto(inputs)

    switch inputs.whichphoto
        case 'load'
            photoload = load(['output/TUVoutput/',abs(num2str(inputs.latitude)),inputs.hemisphere,'/',...
                num2str(inputs.altitude),'km_','0.25hourstep_photo.mat']);
            photolength = size(photoload.pout,1);        
            photoout = [];
        case 'inter'
            photoload = [];
            photolength = 1;
            photoout = zeros(inputs.timesteps,114,91);
    end
  
    if inputs.normalizedaylength || inputs.normalizeintensity
        % daylength normalization
        re = [7:15,74:75,102:103]; %NOY
        count1 = 1;
        count2 = 17281; % day length time 
        %summer
        
        max1 = max(photoload.pout(count2:count2+95,re),[],1);
        %winter
        %max1 = max(photoload.pout(17281:17281+95,:),[],1);
    
        %17281:17281+95
        
        if inputs.normalizedaylength
            for i = 1:inputs.days
                maxval = max(photoload.pout(count1:count1+95,re),[],1);
                test(count1:count1+95,:) = photoload.pout(count2:count2+95,re)./(max1./maxval);
                count1 = count1+96;            
            end
            photoload.pout(:,re) = test;
        end
        
        %% intensity normalization
        %re = [7:15,74:75,102:103]; % NOY
        re = [2:114]; % NOY
        max1 = max(photoload.pout(17281:17281+95,re),[],1);
        %equinox
        %8641:8641+95
        %winter
        %17281:17281+95
        count1 = 1;
        if inputs.normalizeintensity
            for i = 1:inputs.days
                maxval = max(photoload.pout(count1:count1+95,re),[],1);
                test2(count1:count1+95,:) = photoload.pout(count1:count1+95,re)./(maxval./max1);
                count1 = count1+96;            
            end
            photoload.pout(:,re) = test2;
        end
    end
end
