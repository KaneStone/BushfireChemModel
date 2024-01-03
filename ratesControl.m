function [rates] = ratesControl(inputs,step,atmosphere,variables,photoload,kout)
    
    % photolysis
    [~,rates,~] = photolysis(inputs,step,atmosphere,variables,photoload);                        
    
    % gas phase rates
    %[rates] = gasphasecontrol(inputs,step,variables,atmosphere,i,rates,photo.data,climScaleFactor);
    [rates] = gasphasecontrol_opt(step,variables,atmosphere,rates,kout);
    
    % heterogeneous rates
    [rates] = hetcontrol(inputs,step,variables,atmosphere,rates);
            
end