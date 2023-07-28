function [variables_be] = raphsonnewton(inputs,i,rates,photo,atmosphere,step,variables_be,dayaverage,vars,climScaleFactor,SZAdiff,photoload)

% setup backwards euler for variables that have very short lifetimes such
% as CL
photoout = [];
dayaverage = [];

ratescat = zeros(length(vars),30);

for j = 1:length(vars)
    
    % This will be for G calculation
    [rates,~,~] = calcrates(inputs,step,atmosphere,variables_be,dayaverage,i,photoload,photoout,climScaleFactor,SZAdiff,0);
    
    % Need to calculate Jacobian
    % Need to calculate rates but for only a change in one variable
    
    ratessum(j) = (sum(rates.(vars{j}).production) - sum(rates.(vars{j}).destruction));
    rateslength = length(rates.(vars{j}).production) + length(rates.(vars{j}).destruction);
    ratescat(j,1:rateslength) = [rates.(vars{j}).production,rates.(vars{j}).destruction];
    
    varsVector(j) = variables_be.(vars{j})(i);
        
    % pass through variables, and then setup variables and rates vector
    % then recreate variables and rates vectors to pass into rates code
end

varsOut = backwards(i,varsVector,ratessum,ratescat);
varsOut (varsOut < 0) = 0;
for k = 1:length(vars)
    variables_be.(vars{k})(i+1) = varsOut(k);
end


%xb(i+1) = backwards(i,xb,dx);

    

function [varsOut] = backwards(i,varsVector,ratessum,ratescat) % varsVector = yb, % ratessum = dy

    % backwards euler
    % initial guess be previous time step
    %chrome-extension://efaidnbmnnnibpcajpcglclefindmkaj/https://personal.math.ubc.ca/~anstee/math104/newtonmethod.pdf
    %  dy/dt = S(t,y)        
    
    conv = 0;
    count = 1;
    varsIteration(1,:) = varsVector;    
    while ~conv                
        
        if i == 18
            a = 1
        end
        
        if count == 1
            %G(count,:) = (varsIteration(count,:) - varsVector)./inputs.secondstep - ratessum;
            %G(count,:) = varsIteration(count,:) - varsVector - ratessum.*inputs.secondstep;
            G(count,:) = varsIteration(count,:) - varsVector - ratescat.*inputs.secondstep;
            G = double(G);
            gzero = G(count,:) == 0;     
            J(count,gzero) = 0;            
            J(count,~gzero) = G(count,~gzero).^-1;
            
            varsIteration(count+1,:) = varsIteration(count,:) - J(count,:).*G(count,:);
            for k = 1:length(vars)
                varsIn.(vars{k}) = varsIteration(count+1,k);
            end
            [ratesout,~,~] = calcrates(inputs,step,atmosphere,varsIn,dayaverage,i,photoload,photoout,climScaleFactor,SZAdiff,1);
            
            for k = 1:length(vars)
                ratessum(k) = double((sum(ratesout.(vars{k}).production) - sum(ratesout.(vars{k}).destruction)));                
            end
                            
        else
            
            G(count,:) = varsIteration(count,:) - varsIteration(count-1,:) - ratessum.*inputs.secondstep;
            %G(count,:) = (varsIteration(count,:) - varsIteration(count-1,:))./inputs.secondstep - ratessum;
            G = double(G);
            gzero = G(count,:) == 0;            
            gmone = G(count,:) == -1;
            gcombine = logical(gzero+gmone);
            J(count,gcombine) = 0;
            J(count,~gcombine) = [G(count,~gcombine) - G(count-1,~gcombine)].^-1;
            
            J (J == Inf) = 0;
                                                                        
            varsIteration(count+1,:) = varsIteration(count,:) - J(count,:).*G(count,:);
            
            for k = 1:length(vars)
                varsIn.(vars{k}) = varsIteration(count+1,k);
            end
            
            %[dy1(count,:),dx1(count,:)] = calcrates(y1(count+1),x1(count+1));
            [ratesout,~,~] = calcrates(inputs,step,atmosphere,varsIn,dayaverage,i,photoload,photoout,climScaleFactor,SZAdiff,1);
            
            for k = 1:length(vars)
                ratessum(k) = (sum(ratesout.(vars{k}).production) - sum(ratesout.(vars{k}).destruction));                
            end
            
        end
         count = count+1;
         if count == 7
             conv = 1;
             varsOut = varsIteration(count,:);
%              ybout = y1(end);
%              xbout = x1(end);
         end
        
    end

end


end

