function [SZAconv,SZAdiff] = diurnalfromclim(inputs,i)

% DEFUNCT script but may be useful in the future so leaving in folder

% calculate SZA over entire day
SZA = NaN(1,24/inputs.hourstep);
for j = 1:24/inputs.hourstep
    step = initializestep(inputs,i+j-1,1);
    SZA(j) = calcSZA(inputs,step,j+i-1);
end

% find morning and evening here
SZAdiff = diff(SZA);
SZAdiff = [SZAdiff(1),SZAdiff];

SZAconv = SZA;
SZAconv (SZAconv < 88) = 1;
SZAconv (SZAconv > 92) = 0;
SZAconv (SZAconv < 92 & SZAconv > 88) = .5;

SZAconvind = SZAconv == .5;
x = 1:length(SZAconv);
SZAconv(SZAconvind) = interp1(x(~SZAconvind),SZAconv(~SZAconvind),x(SZAconvind),'linear');

sum(SZAconv);

SZAconv = SZAconv.*length(SZAconv)./sum(SZAconv);

%SZAConv


end
