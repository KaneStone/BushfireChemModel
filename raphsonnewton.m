function [variables_be,ratesout] = raphsonnewton(inputs,i,atmosphere,step,variables_be,vars,photoload)

photoout = [];

for j = 1:length(vars)
    varsVector(j) = variables_be.(vars{j})(i);
end

[varsOut,ratesout] = backwards(i,varsVector,vars);
% varsOut (varsOut < 0) = 0;

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
    conv = 0;
    eps = .01; %percent
    while conv == 0       
        if i == 15
            a = 1
        end
        for k = 1:length(vars)
            varsIn.(vars{k}) = varsIteration(count+1,k);
        end
        
        [ratesout,~,~] = rates(inputs,step,atmosphere,varsIn,i,photoload,photoout,1);
%             
        for k = 1:length(vars)
            ratessum(k) = double((sum(ratesout.(vars{k}).production) - sum(ratesout.(vars{k}).destruction)));                
        end
        
        % convert from struct to array
        
        G = varsIteration(count+1,:) - varsIteration(count,:) - ratessum.*inputs.secondstep;
        if count == 1
            J = Jacobian(varsIteration(count:count+1,:),varsIteration(1,:),inputs,atmosphere,step,vars,photoload,G,i);
        elseif inputs.evolvingJ
            J = Jacobian(varsIteration(count:count+1,:),varsIteration(1,:),inputs,atmosphere,step,vars,photoload,G,i);
        end
        
        JG = J'\G';
       
        varsIteration(count+2,:) = varsIteration(count+1,:)' - JG;                
        
        err(count,:) = (varsIteration(count+2,:) - varsIteration(count+1,:));
        convtest(count) = abs(sum(err(count,:))./sum(varsIteration(count+2,:))*100);
        if convtest(count) < eps
            conv = 1;
            
        else
            count = count+1;
        end
        if count == 50
            error('Not converging')
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
%             [ratesout,~,~] = rates(inputs,step,atmosphere,varsIn,dayaverage,i,photoload,photoout,climScaleFactor,SZAdiff,1);
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
%             %[dy1(count,:),dx1(count,:)] = rates(y1(count+1),x1(count+1));
%             [ratesout,~,~] = rates(inputs,step,atmosphere,varsIn,dayaverage,i,photoload,photoout,climScaleFactor,SZAdiff,1);
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

