function [variables_be] = raphsonnewton(inputs,i,rates,photo,atmosphere,step,variables_be,dayaverage,vars,climScaleFactor,SZAdiff,photoload)

% setup backwards euler for variables that have very short lifetimes such
% as CL
photoout = [];
dayaverage = [];

% ratescat = zeros(length(vars),30);
% 
% for j = 1:length(vars)
%     
%     % This will be for G calculation
%     [rates,~,~] = calcrates(inputs,step,atmosphere,variables_be,dayaverage,i,photoload,photoout,climScaleFactor,SZAdiff,0);
%     
%     % Need to calculate Jacobian
%     % Need to calculate rates but for only a change in one variable
%     
%     ratessum(j) = (sum(rates.(vars{j}).production) - sum(rates.(vars{j}).destruction));
%     rateslength = length(rates.(vars{j}).production) + length(rates.(vars{j}).destruction);
%     ratescat(j,1:rateslength) = [rates.(vars{j}).production,rates.(vars{j}).destruction];
%     
%     varsVector(j) = variables_be.(vars{j})(i);
%         
%     % pass through variables, and then setup variables and rates vector
%     % then recreate variables and rates vectors to pass into rates code
% end

for j = 1:length(vars)
    varsVector(j) = variables_be.(vars{j})(i);
end

varsOut = backwards(i,varsVector,vars);
% varsOut (varsOut < 0) = 0;
for k = 1:length(vars)
    variables_be.(vars{k})(i+1) = varsOut(end,k);
end


%xb(i+1) = backwards(i,xb,dx);

    

function [varsIteration] = backwards(i,varsIteration,vars) % varsVector = yb, % ratessum = dy

    % backwards euler
    % initial guess be previous time step
    %chrome-extension://efaidnbmnnnibpcajpcglclefindmkaj/https://personal.math.ubc.ca/~anstee/math104/newtonmethod.pdf
    %  dy/dt = S(t,y)        

    % calculate G
    % calculate J
    % calculate varsIteration
    count = 1;
    varsIteration(count+1,:) = varsIteration(count,:);
    conv = 0;
    eps = .1; %percent
    while conv == 0       
        
        for k = 1:length(vars)
            varsIn.(vars{k}) = varsIteration(count+1,k);
        end
        
        [ratesout,~,~] = calcrates(inputs,step,atmosphere,varsIn,dayaverage,i,photoload,photoout,climScaleFactor,SZAdiff,1);
%             
        for k = 1:length(vars)
            ratessum(k) = double((sum(ratesout.(vars{k}).production) - sum(ratesout.(vars{k}).destruction)));                
        end
        
        % convert from struct to array
        
        G = varsIteration(count+1,:) - varsIteration(count,:) - ratessum.*inputs.secondstep;
        J = Jacobian(varsIteration(count:count+1,:),varsIteration(1,:),inputs,atmosphere,step,dayaverage,vars,climScaleFactor,SZAdiff,photoload,G,i);
        %J (J < 1) = 0;

        JG = J'\G';
        %JG = inv(J)*G;
        %JG (isnan(JG)) = 0;
%         JG (JG == -Inf) = 0;
%         JG (JG == Inf) = 0;
        varsIteration(count+2,:) = varsIteration(count+1,:)' - JG;
        err(count,:) = (varsIteration(count+2,:) - varsIteration(count+1,:));
        convtest(count) = abs(sum(err(count,:))./sum(varsIteration(count+2,:))*100);
        if convtest(count) < eps
            conv = 1;
        else
            count = count+1;
        end
        %count = count+1;
%         if count == 10
%             conv = 1;
%         end
    end
        
    
%     conv = 0;
%     count = 1;
%     varsIteration(1,:) = varsVector;    
        
%         if count == 1
%             %G(count,:) = (varsIteration(count,:) - varsVector)./inputs.secondstep - ratessum;
%             G(count,:) = varsIteration(count,:) - varsVector - ratessum.*inputs.secondstep;
%             %G(count,:) = varsIteration(count,:) - varsVector - ratescat.*inputs.secondstep;
%             G = double(G);
%             
%             % jacobian
%             J = Jacobian(varsVector,inputs,atmosphere,step,dayaverage,vars,climScaleFactor,SZAdiff,photoload,G,i);
%             
% %             gzero = G(count,:) == 0;     
% %             J(count,gzero) = 0;            
% %             J(count,~gzero) = G(count,~gzero).^-1;
%             
%             %varsIteration(count+1,:) = varsIteration(count,:) - J(count,:).*G(count,:);
%             JG = J\G';
%             JG (isnan(JG)) = 0;
%             varsIteration(count+1,:) = varsIteration(count,:)' - JG;
%             for k = 1:length(vars)
%                 varsIn.(vars{k}) = varsIteration(count+1,k);
%             end
%             [ratesout,~,~] = calcrates(inputs,step,atmosphere,varsIn,dayaverage,i,photoload,photoout,climScaleFactor,SZAdiff,1);
%             
%             for k = 1:length(vars)
%                 ratessum(k) = double((sum(ratesout.(vars{k}).production) - sum(ratesout.(vars{k}).destruction)));                
%             end
%                             
%         else
%             
%             G(count,:) = varsIteration(count,:) - varsIteration(count-1,:) - ratessum.*inputs.secondstep;
%             %G(count,:) = (varsIteration(count,:) - varsIteration(count-1,:))./inputs.secondstep - ratessum;
%             
%             J = Jacobian(varsIteration(count,:),inputs,atmosphere,step,dayaverage,vars,climScaleFactor,SZAdiff,photoload,G(count,:),i);   
%             JG = J\G(count,:)';
%             JG (isnan(JG)) = 0;
%                          
%             if count == 2
%                 a = 1;
%             end
%             
%             varsIteration(count+1,:) = varsIteration(count,:)' - JG;
%             
%             for k = 1:length(vars)
%                 varsIn.(vars{k}) = varsIteration(count+1,k);
%             end
%             
%             %[dy1(count,:),dx1(count,:)] = calcrates(y1(count+1),x1(count+1));
%             [ratesout,~,~] = calcrates(inputs,step,atmosphere,varsIn,dayaverage,i,photoload,photoout,climScaleFactor,SZAdiff,1);
%             
%             for k = 1:length(vars)
%                 ratessum(k) = (sum(ratesout.(vars{k}).production) - sum(ratesout.(vars{k}).destruction));                
%             end
%             
%         end
%          count = count+1;
%          if count == 7
%              conv = 1;
%              varsOut = varsIteration(count,:);
% %              ybout = y1(end);
% %              xbout = x1(end);
%          end
        
%     end

end


end

