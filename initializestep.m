function step = initializestep(inputs,i,photolength)

step.stephour = inputs.hourstep.*(i-1);
step.doy = floor(step.stephour/24)+1;
step.date = datetime('1-Jan-2020')+step.doy-1;
step.hour = step.stephour-24.*(step.doy-1);
step.day = day(step.date);
step.month = month(step.date);
step.year = inputs.year;
step.i = i;
stepPerPhoto = inputs.timesteps./photolength./inputs.runlength;     
step.photoInd = ceil(i./stepPerPhoto);

end
