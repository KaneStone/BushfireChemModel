function [variables,kv] = raphsonnewton(inputs,i,atmosphere,step,variables,varNames,photoload,kout,climScaleFactor)

photoout = [];

for j = 1:length(varNames)
    varsVector(j) = variables.(varNames{j})(i);
end

[varsOut,ratesout] = backwards(varsVector,varNames);

for k = 1:length(varNames)
    variables.(varNames{k})(i+1) = varsOut(end,k);
end 

function [varsIteration,ratesout] = backwards(varsInitial,vars) % varsVector = yb, % ratessum = dy

    % backwards euler
    % initial guess is previous time step.
    
    %chrome-extension://efaidnbmnnnibpcajpcglclefindmkaj/https://personal.math.ubc.ca/~anstee/math104/newtonmethod.pdf   
    
    count = 1;
    varsIteration(count,:) = varsInitial; % first guess
    convergence = 0;
    eps = 1e-5; %percent
    %ratessum = zeros(1,length(vars));
    while ~convergence

        for k = 1:length(vars)
            varsIn.(vars{k}) = varsIteration(count,k);
        end
        
        [ratesout,kv] = ratesControl(inputs,step,atmosphere,varsIn,photoload,kout);
        %ratesout.CL.destruction(1)     
        for k = 1:length(varNames)
            ratessum(k) = double((sum(ratesout.(vars{k}).production) - sum(ratesout.(vars{k}).destruction)));                
        end
        
        % convert from struct to array
        
        G = varsIteration(count,:) - varsInitial - ratessum.*inputs.secondstep;
        if count == 1
            J = Jacobian(varsIteration(count,:),varsInitial,inputs,atmosphere,step,varNames,photoload,G,kout);
        elseif count > 1 && inputs.evolvingJ
            J = Jacobian(varsIteration(count,:),varsInitial,inputs,atmosphere,step,varNames,photoload,G,kout);
        end
        
        %removing very small J values
        J (abs(J) < 1e-8) = 1e-8; % not an ideal way of handling near zero derivatives, but easy and doesn't seem to cause problems
        
        % calculating iteration solution
        JG = J'\G';       
        varsIteration(count+1,:) = varsIteration(count,:)' - JG;                
                                
        % testing for convergence
        err(count,:) = (varsIteration(count+1,:) - varsIteration(count,:));
        convtest(count) = abs(sum(err(count,:))./sum(varsIteration(count+1,:))*100);
                
        if convtest(count) < eps
            convergence = 1;
            
            %making sure variables don't go below zero.
            varsIteration (varsIteration < 0) = .001;                   
        else
            count = count+1;
        end
        
        if count == inputs.maxiterations
            error('Not converging')
            % If this becomes a problem at some point will need to half
            % current time step and repeat solver. Sould converge in less
            % than 5 iterations though.
        end
    end          
end


end

