function [varsOut] = raphsonnewton(inputs,i,rates,photo,atmosphere,step,variables_be,dayaverage,vars,climScaleFactor,SZAdiff,photoload)

% setup backwards euler for variables that have very short lifetimes such
% as CL
photoout = [];
dayaverage = [];

for j = 1:length(vars)

    ratessum(j) = (sum(rates.(vars{j}).production) - sum(rates.(vars{j}).destruction)).*inputs.secondstep;
    
    varsVector(j) = variables_be.(vars{j})(i);
        
    % pass through variables, and then setup variables and rates vector
    % then recreate variables and rates vectors to pass into rates code
end

varsOut = backwards(i,varsVector,ratessum);

%xb(i+1) = backwards(i,xb,dx);

    

function [varsOut] = backwards(i,varsVector,ratessum) % varsVector = yb, % ratessum = dy

    % backwards euler
    % initial guess be previous time step
    %chrome-extension://efaidnbmnnnibpcajpcglclefindmkaj/https://personal.math.ubc.ca/~anstee/math104/newtonmethod.pdf
    %  dy/dt = S(t,y)        
    
    conv = 0;
    count = 1;
    varsIteration(1,:) = varsVector;    
    while ~conv                
        
        if count == 1
            G(count,:) = varsIteration(count,:) - varsVector - ratessum.*inputs.secondstep;
            G = double(G);
            gzero = G(count,:) == 0;     
            J(count,gzero) = 0;            
            J(count,~gzero) = G(count,~gzero).^-1;
            
            varsIteration(count+1,:) = varsIteration(count,:) - J(count,:).*G(count,:);
            for k = 1:length(vars)
                varsIn.(vars{k}) = varsIteration(count+1,k);
            end
            [ratesout,~,~] = calcrates(inputs,step,atmosphere,varsIn,dayaverage,i,photoload,photoout,climScaleFactor,SZAdiff);
            
            for k = 1:length(vars)
                ratessum(k) = (sum(ratesout.(vars{k}).production) - sum(ratesout.(vars{k}).destruction));                
            end
                            
        else
            
            G(count,:) = varsIteration(count,:) - varsIteration(count-1,:) - ratessum.*inputs.secondstep;
            G = double(G);
            gzero = G(count,:) == 0;            
            J(count,gzero) = 0;
            J(count,~gzero) = [G(count,~gzero) - G(count-1,~gzero)].^-1;
                                                                        
            varsIteration(count+1,:) = varsIteration(count,:) - J(count,:).*G(count,:);
            
            for k = 1:length(vars)
                varsIn.(vars{k}) = varsIteration(count+1,k);
            end
            
            %[dy1(count,:),dx1(count,:)] = calcrates(y1(count+1),x1(count+1));
            [ratesout,~,~] = calcrates(inputs,step,atmosphere,varsIn,dayaverage,i,photoload,photoout,climScaleFactor,SZAdiff);
            
            for k = 1:length(vars)
                ratessum(k) = (sum(ratesout.(vars{k}).production) - sum(ratesout.(vars{k}).destruction));                
            end
            
        end
         count = count+1;
         if count == 10
             conv = 1;
             varsOut.(vars{k}) = varsIteration(count,k);
%              ybout = y1(end);
%              xbout = x1(end);
         end
        
    end

end


end

