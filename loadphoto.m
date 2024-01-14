function [photoout,photoload,photolength] = loadphoto(inputs)

    switch inputs.whichphoto
        case 'load'
%             photoload = load(['output/TUVoutput/',abs(num2str(inputs.latitude)),inputs.hemisphere,'/',...
%                 num2str(inputs.altitude),'km_','0.25hourstep_photo.mat']);
            photoload = load(['output/TUVoutput/temp/stitched/',...
                num2str(inputs.altitude),'km_','0.25hourstep_photo.mat']);
            photolength = size(photoload.pout,1);        
            photoout = [];
        case 'inter'
            photoload = [];
            photolength = 1;
            photoout = zeros(inputs.timesteps,114,91);
    end
  
end
