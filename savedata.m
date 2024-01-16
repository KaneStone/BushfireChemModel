function savedata(inputs,variables,dayAverage,family,rates,ratesDayAverage)
%% save output (variables dayAverage rates)
if ~inputs.savedata
    return
end
if ~exist([inputs.outputdir,'runoutput/'],'dir')
    mkdir([inputs.outputdir,'runoutput/']);
end
save([inputs.outputdir,'runoutput/',inputs.runtype,'_',num2str(inputs.altitude),...
    'km_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'flux_',sprintf('%.2f',inputs.hourstep),'hours.mat'],...
    'variables','dayAverage','family','rates','ratesDayAverage');

end