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
                save([inputs.ancildir,'fluxcorrection/',sprintf('%.2f',inputs.hourstep),'hourstep_',inputs.region,'.mat'],'flux');
            end
        otherwise
            if i == 1
                load([inputs.ancildir,'fluxcorrection/',sprintf('%.2f',inputs.hourstep),'hourstep_',inputs.region,'.mat'])
            end
    end
    variables.O3(end) = variables.O3(end) - flux.O3(i).*variables.O3(end);
%     variables.HNO3(end) = atmosphere.dummyHNO3(step.doy);%  variables.HNO3(end) - flux.HNO3(i).*variables.HNO3(end); % atmosphere.atLevel.HNO3.nd(step.doy)+atmosphere.atLevel.HNO3.nd(step.doy)./10; atmosphere.dummyHNO3(step.doy);
%     variables.N2O5(end) = atmosphere.dummyN2O5(step.doy);% variables.N2O5(end) - flux.N2O5(i).*variables.N2O5(end);% atmosphere.dummyN2O5(step.doy);
    variables.HNO3(end) = variables.HNO3(end) - flux.HNO3(i).*variables.HNO3(end); % atmosphere.atLevel.HNO3.nd(step.doy)+atmosphere.atLevel.HNO3.nd(step.doy)./10; atmosphere.dummyHNO3(step.doy);
    %variables.N2O5(end) = variables.N2O5(end) - flux.N2O5(i).*variables.N2O5(end);% atmosphere.dummyN2O5(step.doy);
    variables.CLONO2(end) = variables.CLONO2(end) - flux.CLONO2(i).*variables.CLONO2(end);
    %variables.HCL(end) = variables.HCL(end) - flux.HCL(i).*variables.HCL(end);
    %variables.CLO(end) = variables.CLO(end).*.7;
    %variables.HO2(end) = variables.HO2(end).*.5;
    %variables.NO2(end) = atmosphere.atLevel.NO2.nd(step.doy);
%     variables.OH(end) = variables.OH(end)-1e5;
%     variables.OH (variables.OH < 0) = .1e5;
%     variables.HO2(end) = variables.HO2(end)+3e6;
%     variables.HO2 (variables.OH < 0) = 5e5;
    %variables.N2O5(end) = atmosphere.atLevel.N2O5.nd(step.doy);
    %variables.NO3(end) = atmosphere.atLevel.NO3.nd(step.doy)+5e6;
    %variables.CLO(end) = variables.CLO(end)./3;
    %variables.BRO(end) = variables.BRO(end).*2;
    %variables.OH(end) = variables.HO2(end).*10;
    %variables.BRONO2(end) = atmosphere.atLevel.BRONO2.nd(step.doy);
    %variables.HOBR(end) = atmosphere.atLevel.HOBR.nd(step.doy);
    
    
else
    return
end

    

end