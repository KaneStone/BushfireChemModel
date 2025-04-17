function J = jacobiangear(varsIteration,varsInitial,inputs,atmosphere,step,varNames,photoload,G,kout,alpha,beta,in)
    % calculate jacobian, this is an expensive function  to run so
    % recommend setting inputs.evolvingJ = 0 as calculating the jacobian
    % every iteration only leads to very minor improvements.
    
    G2 = zeros(size(varsIteration,2));
    J = zeros(size(varsIteration,2));
    for i = 1:size(varsIteration,2)
        varsIterationIn = varsIteration;
        varsIterationIn(i) = varsIterationIn(i) + varsIterationIn(i)./100;

        for k = 1:length(varNames)
            varsIn.(varNames{k}) = varsIterationIn(k);
        end

        [ratesout,~] = ratescontrol(inputs,step,atmosphere,varsIn,photoload,kout,1);    

        for k = 1:length(varNames)
            ratessum(i,k) = double((sum(ratesout.(varNames{k}).production) - ...
                sum(ratesout.(varNames{k}).destruction)));                
        end
        if in > 4
            G2(i,:) = varsIterationIn - sum(alpha'.*varsInitial) - beta.*ratessum(i,:).*inputs.secondstep;     
            %J(i,:) = (G2(i,:)-G)./(varsIterationIn(i) - sum(alpha'.*varsInitial(:,i)));
            J(i,:) = (G2(i,:)-G)./(varsIterationIn(i) - varsInitial(end,i));
        else
            G2(i,:) = varsIterationIn - varsInitial - ratessum(i,:).*inputs.secondstep;     
            J(i,:) = (G2(i,:)-G)./(varsIterationIn(i) - varsInitial(i));
        end
        
    end
    %J = sparse(J);
end