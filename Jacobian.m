function J = Jacobian(varsIteration,varsInitial,inputs,atmosphere,step,varNames,photoload,G,kout)

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
            ratessum(i,k) = double((sum(ratesout.(varNames{k}).production) - sum(ratesout.(varNames{k}).destruction)));                
        end
        G2(i,:) = varsIterationIn - varsInitial - ratessum(i,:).*inputs.secondstep;     
        J(i,:) = (G2(i,:)-G)./(varsIterationIn(i) - varsInitial(i));
    end

end