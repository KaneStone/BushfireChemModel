function [variables,flux] = fluxcorrection(inputs,variables,flux,atmosphere,step,i)

    if inputs.fluxcorrections
        switch inputs.runtype
            case 'control'        
                flux.O3(i) = (variables.O3(end) - atmosphere.dummyO3(step.doy))./variables.O3(end);
                flux.HNO3(i) = (variables.HNO3(end) - atmosphere.dummyHNO3(step.doy))./variables.HNO3(end);
                flux.N2O5(i) = (variables.N2O5(end) - atmosphere.dummyN2O5(step.doy))./variables.N2O5(end);
                flux.CLONO2(i) = (variables.CLONO2(end) - atmosphere.dummyCLONO2(step.doy))./variables.CLONO2(end);
                flux.HCL(i) = (variables.HCL(end) - atmosphere.dummyHCL(step.doy))./variables.HCL(end);

                if i == inputs.timesteps
                    % save output
                    if ~exist([inputs.outputdir,'fluxcorrection/'],'dir')
                        mkdir([inputs.outputdir,'fluxcorrection/']);
                    end
                    save([inputs.outputdir,'fluxcorrection/',...
                        sprintf('%.2f',inputs.hourstep),'_',num2str(inputs.altitude),...
                        '_','hourstep_',inputs.region,'.mat'],'flux');
                end
            otherwise
                if i == 1
                    load([inputs.outputdir,'fluxcorrection/',...
                        sprintf('%.2f',inputs.hourstep),'_',num2str(inputs.altitude),...
                        '_','hourstep_',inputs.region,'.mat'])
                end
        end

        variables.O3(end) = variables.O3(end) - flux.O3(i).*variables.O3(end);
        variables.HNO3(end) = variables.HNO3(end) - flux.HNO3(i).*variables.HNO3(end);
        variables.CLONO2(end) = variables.CLONO2(end) - flux.CLONO2(i).*variables.CLONO2(end);

            
    end        
    
end