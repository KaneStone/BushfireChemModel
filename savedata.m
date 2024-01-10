function savedata(variables,dayAverage,family,rates,ratesDayAverage)
%% save output (variables dayAverage rates)
if ~inputs.savedata
    return
end

save([inputs.outputdir,'data/',inputs.runtype,'_',num2str(inputs.altitude),...
    '_',abs(num2str(inputs.latitude)),inputs.hemisphere...
    ,'_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours.mat'],...
    'variables','dayAverage','family','rates','ratesDayAverage');

end