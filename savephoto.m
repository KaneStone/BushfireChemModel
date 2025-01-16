function savephoto(inputs,photoout)

    % save photodata if running in inter photo mode
    if inputs.photosave    
        if ~exist([inputs.outputdir,'TUVoutput/',abs(num2str(inputs.latitude)),inputs.hemisphere,'/'],'dir') 
            mkdir([inputs.outputdir,'TUVoutput/',abs(num2str(inputs.latitude)),inputs.hemisphere,'/']);
        end
        for i = 1:size(photoout,3)
            pout = photoout(:,:,i);
            save([inputs.outputdir,'TUVoutput/',abs(num2str(inputs.latitude)),inputs.hemisphere,'/',...
                num2str(i-1),'km','_',num2str(inputs.hourstep),'hourstep','_photo.mat'],'pout')
        end
    end
    
end