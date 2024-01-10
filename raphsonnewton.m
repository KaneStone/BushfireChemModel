function [variables,kv] = raphsonnewton(inputs,i,atmosphere,step,variables,varNames,photoload,kout)

    % implicit backwards euler solver using raphson newton iterative method
    %chrome-extension://efaidnbmnnnibpcajpcglclefindmkaj/https://personal.math.ubc.ca/~anstee/math104/newtonmethod.pdf   
    
    varsInitial = zeros(1,length(varNames));
    ratesSum = zeros(1,length(varNames));
    err = zeros(inputs.maxiterations,length(varNames));
    convTest = zeros(1,inputs.maxiterations);
    for j = 1:length(varNames)
        varsInitial(j) = variables.(varNames{j})(i);
    end

    count = 1;
    varsIteration(count,:) = varsInitial; % first guess
    convergence = 0;
    eps = 1e-5; % convergence error threshold (percent)
    
    while ~convergence

        for l = 1:length(varNames)
            varsIn.(varNames{l}) = varsIteration(count,l);
        end
        
        [ratesout,kv] = ratescontrol(inputs,step,atmosphere,varsIn,photoload,kout,0);
           
        for l = 1:length(varNames)
            ratesSum(l) = double((sum(ratesout.(varNames{l}).production) - sum(ratesout.(varNames{l}).destruction)));                
        end
        
        % convert from struct to array
        
        G = varsIteration(count,:) - varsInitial - ratesSum.*inputs.secondstep;
        if count == 1
            J = jacobian(varsIteration(count,:),varsInitial,inputs,atmosphere,step,varNames,photoload,G,kout);
        elseif count > 1 && inputs.evolvingJ
            J = jacobian(varsIteration(count,:),varsInitial,inputs,atmosphere,step,varNames,photoload,G,kout);
        end
        
        % removing very small J values
        % not an ideal way of handling near zero derivatives, but easy and
        % doesn't seem to cause problems (produces very small changes in
        % conserved families (CLY, etc)
        J (abs(J) < 1e-8) = 1e-8; 
        
        % calculating iteration solution
        JG = J'\G';       
        varsIteration(count+1,:) = varsIteration(count,:)' - JG;                
                                
        % testing for convergence
        err(count,:) = (varsIteration(count+1,:) - varsIteration(count,:));
        convTest(count) = abs(sum(err(count,:))./sum(varsIteration(count+1,:))*100);
                
        if convTest(count) < eps
            convergence = 1;
            
            %making sure variables don't go below zero.
            varsIteration (varsIteration < 0) = .001;      
            
            for k = 1:length(varNames)
                variables.(varNames{k})(i+1) = varsIteration(end,k);
            end 
            
        else
            count = count+1;
        end
        
        if count == inputs.maxiterations
            error('Not converging')
            % If this becomes a problem at some point will need to half
            % current time step and repeat solver. Should converge in less
            % than 5 iterations though.
        end
    end          
end

