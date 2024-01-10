function [rates,kv] = ratescontrol(inputs,step,atmosphere,variables,photoload,kout,jacobian)
    
    % photolysis
    [~,rates,~,kv] = photolysis(inputs,step,atmosphere,variables,photoload,jacobian);                        
    
    % gas phase rates    
    [rates,kv] = gasphasecontrol(step,variables,atmosphere,rates,kout,kv,jacobian);    
    
    % heterogeneous rates
    [rates,kv] = hetcontrol(inputs,step,variables,atmosphere,rates,kv,jacobian);
            
end