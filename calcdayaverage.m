function [dayAverage,daycount] = calcdayaverage(inputs,variables,dayAverage,daycount,vars,i)

    if i == daycount*24/inputs.hourstep        
        for k = 1:length(vars)
            dayAverage.(vars{k})(daycount) = mean(variables.(vars{k})(1+(daycount-1)*24/inputs.hourstep:daycount*24/inputs.hourstep));
        end        
        daycount = daycount+1;        
    end

end    