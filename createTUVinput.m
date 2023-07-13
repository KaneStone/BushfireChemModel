function [] = createTUVinput(inputs,atmosphere,step)

    %% save TUV data

    % geotime
%     dayend = cumsum([31,29,31,30,31,30,31,31,30,31,30,31]);
%     month = 1;
%     day = 1;
%     count = 1;
    
    ozoneout_nd = atmosphere.O3(:,step.doy);
    densityout = atmosphere.M(:,step.doy);
    tempout = atmosphere.T(:,step.doy);

    fid = fopen(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushChemModel/TUV5.4/MINPUTS/','geotime/','timestep','.geotime'], 'w');
    fprintf(fid, '%.3f\n', inputs.latitude); %latitude
    %fprintf(fid,
    fprintf(fid, '%.3f\n', 0); % longitude                
    fprintf(fid, '%.0f\n', step.year); % year
    fprintf(fid, '%.0f\n', step.month); % month
    fprintf(fid, '%.0f\n', step.day);% day      
    fprintf(fid, '%.2f\n', step.hour);% day      
    fclose(fid);

    % ozone
    fid = fopen(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushChemModel/TUV5.4/MINPUTS/','ozone/','timestep','.ozone'], 'w');
    fprintf(fid, '# values from 2-74 km are from US Standard Atmosphere, 1976, for 45N, annual\n');
    fprintf(fid, '# means.\n');
    fprintf(fid, '# values at 0 and 1 km are filled in assuming a typical surface mixing ratio\n');
    fprintf(fid, '# of 40 ppb\n');
    fprintf(fid, '# total ozone (assuming linear behavior between altitude points): 349.82 DU\n');
    fprintf(fid, '# 1st column:  Geometric Altitude (km)\n');
    fprintf(fid, '# 2nd column:  Ozone number density (n(O3) cm-3)\n');
    fprintf(fid, '%.0f %.3g\n', [atmosphere.altitude;ozoneout_nd']);
    fclose(fid);

    % density
    fid = fopen(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushChemModel/TUV5.4/MINPUTS/','density/','timestep','.density'], 'w');
    fprintf(fid, '# values are from US Standard Atmosphere, 1976, for 45N, annual means\n');
    fprintf(fid, '# 1st column:  Geometric Altitude (km)\n');
    fprintf(fid, '# 2nd column:  Number density n (cm-3)\n');
    fprintf(fid, '%.0f %.3g\n', [atmosphere.altitude;densityout']);
    fclose(fid);

    % temperature
    fid = fopen(['/Users/kanestone/Dropbox (MIT)/Work_Share/MITWork/BushChemModel/TUV5.4/MINPUTS/','temp/','timestep','.temperature'], 'w');
    fprintf(fid, '# vaules are from US Standard Atmosphere, 1976, for 45N, annual means\n');
    fprintf(fid, '# 1st column:  Geometric Altitude (km)\n');
    fprintf(fid, '# 2nd column:  Temperature (deg K)\n');
    fprintf(fid, '%.0f %.3f\n', [atmosphere.altitude;tempout']);
    fclose(fid);

end