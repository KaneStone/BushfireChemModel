function step = initializestep(inputs,i,photolength)

    step.stephour = inputs.hourstep.*(i-1);
    step.daysincebegin = inputs.dayssincestartofyear + floor(step.stephour/24)+1;
    step.hour = step.stephour-24.*(step.daysincebegin-inputs.dayssincestartofyear-1);
    step.date = datetime(inputs.startdate) + step.daysincebegin - inputs.dayssincestartofyear - 1;
    step.day = day(step.date);
    step.month = month(step.date);
    step.year = year(step.date);    
    step.i = i;
    stepPerPhoto = inputs.timesteps./inputs.runlength./photolength;  
    step.photoInd = ceil((i + inputs.stepssincestartofyear - inputs.timesteps./inputs.runlength.*(step.year - inputs.yearstart))./stepPerPhoto); 
    step.doy = step.daysincebegin - 365.*(step.year - inputs.yearstart);
            
end
