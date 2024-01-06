function [rates,kout] = ratesControl(inputs,step,atmosphere,variables,photoload,kout)
    
    % photolysis
    [~,rates,~] = photolysis(inputs,step,atmosphere,variables,photoload);                        
    
    % gas phase rates
    %[rates] = gasphasecontrol(inputs,step,variables,atmosphere,i,rates,photo.data,climScaleFactor);
    [rates,kv] = gasphasecontrol_opt(step,variables,atmosphere,rates,kout);
    %[rates] = gasphasecontrol_opt2(step,variables,atmosphere,rates,kout);
    
    % heterogeneous rates
    [rates] = hetcontrol(inputs,step,variables,atmosphere,rates);
            
end