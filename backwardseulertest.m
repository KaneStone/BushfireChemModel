% create a backwards and forwards euler test

%% function df(x)/dx = exp(-2700/200)*y;
%x initial = 1
y(1) = 1e6;
yb(1) = y(1);
x(1) = 1e6;
xb(1) = 1e6;
dt = 10;
for i = 1:1000
    % forwards euler
    rates(1) = exp(-1500/240).*x(i);
    rates(2) = -exp(-1500/220).*y(i)./1.2;
    
    ratesi(1) = exp(-1500/250).*y(i);
    ratesi(2) = -exp(-1500/230).*x(i)./1.2;
    
    y(i+1) = y(i) + sum(rates).*dt;
    x(i+1) = x(i) + sum(ratesi).*dt;
    
    if i == 1
        dy = sum(rates);    
        dx = sum(ratesi);    
    else
        [ratesby,ratesbx] = calcrates(yb(i),xb(i));    
        dy = sum(ratesby);
        dx = sum(ratesbx);
    end
    [yb(i+1),xb(i+1)] = backwards(i,yb(i),dy,xb(i),dx,dt);
    %xb(i+1) = backwards(i,xb,dx);

    
end

a = 1

function [ybout,xbout] = backwards(i,yb,dy,xb,dx,dt)

    % backwards euler
    % initial guess be previous time step
    %chrome-extension://efaidnbmnnnibpcajpcglclefindmkaj/https://personal.math.ubc.ca/~anstee/math104/newtonmethod.pdf
    %  dy/dt = S(t,y)


    conv = 0;
    count = 1;
    y1(1) = yb;
    x1(1) = xb;
    while ~conv
        if count == 1
            G(count) = y1(count) - yb - dy.*dt;
            J(count) = G(count)^-1;
            y1(count+1) = yb - J(count).*G(count);            
            
            Gx(count) = x1(count) - xb - dx.*dt;
            Jx(count) = Gx(count)^-1;
            x1(count+1) = xb - Jx(count).*Gx(count);            
            
            
            [dy1(count,:),dx1(count,:)] = calcrates(y1(count+1),x1(count+1));
        else
            
            G(count) = y1(count) - y1(count-1) - sum(dy1(count-1,:),2).*dt;
            J(count) = [G(count) - G(count-1)]^-1;
            y1(count+1) = y1(count) - J(count).*G(count);
            
            Gx(count) = x1(count) - x1(count-1) - sum(dx1(count-1,:),2).*dt;
            Jx(count) = [Gx(count) - Gx(count-1)]^-1;
            x1(count+1) = x1(count) - Jx(count).*Gx(count);
            
            [dy1(count,:),dx1(count,:)] = calcrates(y1(count+1),x1(count+1));
        end
         count = count+1;
         if count == 35
             conv = 1;
             ybout = y1(end);
             xbout = x1(end);
         end
        
    end

end

function [rates,ratesi] = calcrates(y,x)

    rates(1) = exp(-1500/240).*x;
    rates(2) = -exp(-1500/220).*y./1.3;
    
    ratesi(1) = exp(-1500/250).*y;
    ratesi(2) = -exp(-1500/230).*x./1.2;
end