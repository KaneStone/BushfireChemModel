function [variables_be,ratesout] = raphsonnewton(inputs,i,atmosphere,step,variables_be,vars,photoload,climScaleFactor)

photoout = [];

for j = 1:length(vars)
    varsVector(j) = variables_be.(vars{j})(i);
end

[varsOut,ratesout] = backwards(i,varsVector,vars);

for k = 1:length(vars)
    variables_be.(vars{k})(i+1) = varsOut(end,k);
end 

function [varsIteration,ratesout] = backwards(i,varsIteration,vars) % varsVector = yb, % ratessum = dy

    % backwards euler
    % initial guess be previous time step
    
    %chrome-extension://efaidnbmnnnibpcajpcglclefindmkaj/https://personal.math.ubc.ca/~anstee/math104/newtonmethod.pdf
    %  dy/dt = S(t,y)        
    
    count = 1;
    varsIteration(count+1,:) = varsIteration(count,:);
    convergence = 0;
    eps = 1e-5;%1e-5; %percent
    while ~convergence

        for k = 1:length(vars)
            varsIn.(vars{k}) = varsIteration(count+1,k);
        end
        
        [ratesout,~,~] = rates(inputs,step,atmosphere,varsIn,i,photoload,photoout,1,vars,climScaleFactor);
        %ratesout.CL.destruction(1)     
        for k = 1:length(vars)
            ratessum(k) = double((sum(ratesout.(vars{k}).production) - sum(ratesout.(vars{k}).destruction)));                
        end
        
        % convert from struct to array
        
        G = varsIteration(count+1,:) - varsIteration(1,:) - ratessum.*inputs.secondstep;
        if count == 1
            J = Jacobian(varsIteration(count:count+1,:),varsIteration(1,:),inputs,atmosphere,step,vars,photoload,G,i,climScaleFactor);
        elseif count > 1 && inputs.evolvingJ
            J = Jacobian(varsIteration(count:count+1,:),varsIteration(1,:),inputs,atmosphere,step,vars,photoload,G,i,climScaleFactor);
        end
        
        %removing very small J values
        J (abs(J) < 1e-5) = 1e-5;
        
        % calculating iteration solution
        JG = J'\G';       
        varsIteration(count+2,:) = varsIteration(count+1,:)' - JG;                
                                
        % testing for convergence
        err(count,:) = (varsIteration(count+2,:) - varsIteration(count+1,:));
        convtest(count) = abs(sum(err(count,:))./sum(varsIteration(count+2,:))*100);
                
        if convtest(count) < eps
            convergence = 1;
            
            %making sure variables don't go below zero.
            varsIteration (varsIteration < 0) = .001;                   
        else
            count = count+1;
        end
        
        if count == 50
            error('Not converging')
            % If this becomes a problem at some point will need to half
            % current time step and repeat solver. 
        end
    end          
end


end

