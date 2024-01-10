function step = initializestep(inputs,i,photolength)

    step.stephour = inputs.hourstep.*(i-1);
    step.doy = inputs.dayssincestartofyear + floor(step.stephour/24)+1;
    step.hour = step.stephour-24.*(step.doy-inputs.dayssincestartofyear-1);
    step.date = datetime(inputs.startdate) + step.doy - inputs.dayssincestartofyear - 1;
    step.day = day(step.date);
    step.month = month(step.date);
    step.year = year(step.date);    
    step.i = i;
    stepPerPhoto = inputs.timesteps./photolength;  
    step.photoInd = ceil((i + inputs.stepssincestartofyear - inputs.timesteps.*(step.year - inputs.yearstart))./stepPerPhoto); 
    step.doy = step.doy - 365.*(step.year - inputs.yearstart);
            
end
