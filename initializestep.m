function step = initializestep(inputs,i,photolength)

    step.stephour = inputs.hourstep.*(i-1);
    step.doy = inputs.dayssincestartofyear + floor(step.stephour/24)+1;
    step.date = datetime(inputs.startdate) + step.doy - inputs.dayssincestartofyear - 1;
    %step.hour = step.stephour-24.*(step.doy-1);
    step.day = day(step.date);
    step.month = month(step.date);
    step.year = year(step.date);
    step.doy = step.doy - 365.*(step.year - inputs.yearstart);
    step.i = i;
    stepPerPhoto = inputs.timesteps./photolength;  
    % I think this works to make photolysis repeat after a year, doesn't work
    % to allow to start at a different start date.
    % need to find start time step difference from start of year
    step.photoInd = ceil((i + inputs.stepssincestartofyear - inputs.timesteps.*(step.year - inputs.yearstart))./stepPerPhoto); 
    %step.photoInd = ceil((i - inputs.timesteps.*(step.year - inputs.yearstart))./stepPerPhoto); 

end
