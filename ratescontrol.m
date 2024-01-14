function [rates,kv] = ratescontrol(inputs,step,atmosphere,variables,photoload,kout,jacobian)
    
    % photolysis
    [~,rates,~,kv] = photolysis(inputs,step,atmosphere,variables,photoload,jacobian);                        
    
    % gas phase rates    
    [rates,kv] = gasphasecontrol(inputs,step,variables,atmosphere,rates,kout,kv);    
    
    % heterogeneous rates
    [rates,kv] = hetcontrol(inputs,step,variables,atmosphere,rates,kv,jacobian);
            
end