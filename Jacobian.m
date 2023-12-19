function J = Jacobian(varsVector,varsVecIni,inputs,atmosphere,step,dayaverage,vars,climScaleFactor,SZAdiff,photoload,G,timestep_ind)

photoout = [];
dayaverage = [];

for i = 1:size(varsVector,2)
    varsVector_in = varsVector(2,:);
    varsVector_in(i) = varsVector_in(i)+varsVector_in(i)./1;
    
    for k = 1:length(vars)
        varsIn.(vars{k}) = varsVector_in(k);
    end
    
    
    [ratesout,~,~] = calcrates(inputs,step,atmosphere,varsIn,dayaverage,timestep_ind,photoload,photoout,climScaleFactor,SZAdiff,1);
    
    for k = 1:length(vars)
        ratessum(i,k) = double((sum(ratesout.(vars{k}).production) - sum(ratesout.(vars{k}).destruction)));                
    end
    G2(i,:) = varsVector_in - varsVecIni - ratessum(i,:).*inputs.secondstep; % I think varsVector initial is wrong here.
    J(i,:) = (G2(i,:)-G)./(varsVector_in(i) - varsVector(2,i));
end

%J_ij = %dayGi/dayyj
% G = yn+1 - yn - dt*S(tn+1,yn+1)

% steps
% Change each variable in the y vector by a small amount (say 1%)
% calculate rates
% calculate the change in G
% produce square jacobian





end