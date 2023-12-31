function out = transport(inputs,step,atmosphere,variables,i)

% Look into Randall ewuation 4.22

% simple merional advection
dlon = 360/96;
dlat = 180/48;
ydim = 48;
xdim = 96;


ilat = 1:48;

%h_scl = 5000; % quantity
dX_advec = 0;

% deg = 2.*pi*6.371e6/360.;   % length of 1deg latitude [m] 
% dx = dlon; 
% dy = dlat; 
% dyy = dy*deg;
% lat = dlat*ilat-dlat/2 - 90;  
% dxlat = dx*deg*cos(2*pi/360*lat);
% ccya = inputs.param.timestep_circ./dyy/2;
% ccxa = inputs.param.timestep_circ./dxlat./2;
% wz = exp(-inputs.ANCIL.Orography.Orography/h_scl); % weight for each point

lattemp = [-46,-45,-44];
ilat = length(lattemp);
dy = 1; %degree
dlat = 1;
deg = 2.*pi*6.371e6/360.;   % length of 1deg latitude [m] 
dyy = dy*deg;
%lat = dlat*ilat-dlat/2 - 90;  
dxlat = deg*cos(2*pi/360*lattemp); % don't think I need this
ccya = inputs.secondstep./dyy/2; %s/m
test = cos(2.*pi./360.*[-44,-45,-46]);


% neg wind
out.O3 = atmosphere.dummyV(step.doy)*25.*(ccya.*(variables.O3(i)).*test(2) - ccya.*variables.O3(i).*test(1));
out.CLONO2 = atmosphere.dummyV(step.doy)*25.*(ccya.*(variables.CLONO2(i)).*test(2) - ccya.*variables.CLONO2(i).*test(1));
out.HCL = atmosphere.dummyV(step.doy)*25.*(ccya.*(variables.HCL(i)).*test(2) - ccya.*variables.HCL(i).*test(1));
out.HNO3 = atmosphere.dummyV(step.doy)*25.*(ccya.*(variables.HNO3(i)).*test(2) - ccya.*variables.HNO3(i).*test(1));
out.N2O5 = atmosphere.dummyV(step.doy)*25.*(ccya.*(variables.N2O5(i)).*test(2) - ccya.*variables.N2O5(i).*test(1));
% dXy3(:,end-1) = inputs.ANCIL.VWind.VWind(:,end-1,ityr).*ccya.*wz(:,end).*(-X(:,end-1)+X(:,end));
% dXy3(:,end) = 0;
% dXy3 = dXy3.*negwind;
% dXy2 = dXy2 + dXy3;        

end
%% diffusion

% dX_diffuse = 0;
% kappa = 8e5; % atmospheric diffusion coefficient (m2/s)
% deg = 2.*pi*6.371e6/360.;   % length of 1deg latitude [m] 
% dy = 1; 
% 
% %dxlat = dx * deg * cos(2*pi/360*lat);
% 
% ccyd = kappa*inputs.secondstep./dyy.^2; % I actually think this is wrong and need to fix; for a disk and not a sphere?
% %ccxd = kappa*inputs.param.timestep_circ./dxlat.^2; % I actually think this is wrong and need to fix;
%   
% % testing code
% %ccxd = .1.*ones(1,48);
% 
% % lonleft1 = circshift(1:xdim,1);
% % lonleft2 = circshift(lonleft1,1);
% % lonleft3 = circshift(lonleft2,1);
% % lonright1 = circshift(1:xdim,-1);
% % lonright2 = circshift(lonright1,-1);
% % lonright3 = circshift(lonright2,-1);
% 
% % circulation time step = 
% % cts = floor(inputs.param.timestep./inputs.param.timestep_circ);
% % 
% % for it = 1:cts % main time loop       
% 
%     dXx2 = NaN(xdim,ydim);
%     dXy2 = NaN(xdim,ydim);
%     dXy3 = NaN(xdim,ydim);
%     Th = NaN(xdim,ydim);
%     
%     
%     dXy2(:,1) = ccyd*wz(:,2).*(-X(:,1)+X(:,2));
%     dXy2(:,end) = ccyd*wz(:,end-1).*(X(:,end-1)-X(:,end)); % This is the culprit
%     dXy2(:,2:end-1)=ccyd.*(wz(:,1:end-2).*(X(:,1:end-2)-X(:,2:end-1)) + wz(:,3:end).*(X(:,3:end)-X(:,2:end-1)));    
%     
%     
%     dxlarge = dxlat > 2.5e5;
%     dxsmall = find(dxlat <= 2.5e5);
%     
%     dXx2(:,dxlarge) = ccxd(dxlarge).*(10.*( wz(lonleft1,dxlarge).*(X(lonleft1,dxlarge)-X(:,dxlarge)) + wz(lonright1,dxlarge).*(X(lonright1,dxlarge) - X(:,dxlarge)))...
%         +4.*(wz(lonleft2,dxlarge).*(X(lonleft2,dxlarge) - X(lonleft1,dxlarge)) + wz(lonleft1,dxlarge).*(X(:,dxlarge) - X(lonleft1,dxlarge)))...
%         +4.*(wz(lonright1,dxlarge).*(X(:,dxlarge) - X(lonright1,dxlarge)) + wz(lonright2,dxlarge).*(X(lonright2,dxlarge) -X(lonright1,dxlarge)))...
%         +1.*(wz(lonleft3,dxlarge).*(X(lonleft3,dxlarge) - X(lonleft2,dxlarge)) + wz(lonleft2,dxlarge).*(X(lonleft1,dxlarge) -X(lonleft2,dxlarge)))...
%         +1.*(wz(lonright2,dxlarge).*(X(lonright1,dxlarge) - X(lonright2,dxlarge)) + wz(lonright3,dxlarge).*(X(lonright3,dxlarge) -X(lonright2,dxlarge))))./20;    
%     
%     % additional time loop for smaller areas
%     dd=max(1,round(inputs.param.timestep_circ./(1.*dxlat.^2/kappa))); 
%     dtdff2 = inputs.param.timestep_circ./dd;
%     time2 = max(1,round(inputs.param.timestep_circ)./dtdff2);
%     ccx2 = kappa.*dtdff2./dxlat.^2;    
%     
%     %ccx2 = .1.*ones(1,48); % testing code
%     
%     Xh = X;    
%     for k = 1:length(dxsmall)
%         for tt2 = 1:time2(dxsmall(k))      % additional time loop                
%             dXx2(:,dxsmall(k)) = ccx2(dxsmall(k)).*(10.*( wz(lonleft1,dxsmall(k)).*(Xh(lonleft1,dxsmall(k))-Xh(:,dxsmall(k))) + wz(lonright1,dxsmall(k)).*(Xh(lonright1,dxsmall(k)) - Xh(:,dxsmall(k))))...
%                 +4.*(wz(lonleft2,dxsmall(k)).*(Xh(lonleft2,dxsmall(k)) - Xh(lonleft1,dxsmall(k))) + wz(lonleft1,dxsmall(k)).*(Xh(:,dxsmall(k)) - Xh(lonleft1,dxsmall(k))))...
%                 +4.*(wz(lonright1,dxsmall(k)).*(Xh(:,dxsmall(k)) - Xh(lonright1,dxsmall(k))) + wz(lonright2,dxsmall(k)).*(Xh(lonright2,dxsmall(k)) -Xh(lonright1,dxsmall(k))))...
%                 +1.*(wz(lonleft3,dxsmall(k)).*(Xh(lonleft3,dxsmall(k)) - Xh(lonleft2,dxsmall(k))) + wz(lonleft2,dxsmall(k)).*(Xh(lonleft1,dxsmall(k)) -Xh(lonleft2,dxsmall(k))))...
%                 +1.*(wz(lonright2,dxsmall(k)).*(Xh(lonright1,dxsmall(k)) - Xh(lonright2,dxsmall(k))) + wz(lonright3,dxsmall(k)).*(Xh(lonright3,dxsmall(k)) -Xh(lonright2,dxsmall(k)))))./20;    
%             
%             dXx2 (dXx2 <= -Xh) = -.9.*Xh(dXx2 <= -Xh);         
% %             if k <3
% %                 figure; contourf(dXx2',-.1:.001:.1,'LineStyle','none'); caxis([-.1 .1]);
% %             end
%             Th(:,dxsmall(k)) = Xh(:,dxsmall(k)) + dXx2(:,dxsmall(k)); 
%             Xh(:,dxsmall(k)) = Th(:,dxsmall(k));
%         end % additional time loop
%     end    
%     dXx2(:,dxsmall) = Th(:,dxsmall)-X(:,dxsmall);
% 
%     ddx=dXx2+dXy2;    
%     
%     %ddx=dXx2;
%     dX_diffuse = exp(-inputs.ANCIL.Orography.Orography/h_scl).*ddx;        
%     %dX_diffuse = ddx;
%     
%     %% advection    
%     dXy2 = NaN(xdim,ydim);
%     dXx = NaN(xdim,ydim);
%     dXx2 = NaN(xdim,ydim);        
%     
%     poswind = inputs.ANCIL.VWind.VWind(:,:,ityr) >= 0;
%     negwind = inputs.ANCIL.VWind.VWind(:,:,ityr) < 0;
%     poswind2 = inputs.ANCIL.UWind.UWind(:,:,ityr) >= 0;
%     negwind2 = inputs.ANCIL.UWind.UWind(:,:,ityr) < 0; 
%     
%    % -inputs.ANCIL.VWind.VWind(j,k,ityr).*ccya*( wz(j,km1).*(X(j,k)-X(j,km1))+wz(j,km2)*(X(j,k)-X(j,km2)) )./3;
%     
%     %pos wind
%     dXy2(:,3:end) = -inputs.ANCIL.VWind.VWind(:,3:end,ityr).*ccya.*(wz(:,2:end-1).*(X(:,3:end)-X(:,2:end-1))+wz(:,1:end-2).*(X(:,3:end)-X(:,1:end-2)))./3;
%     dXy2(:,2) = -inputs.ANCIL.VWind.VWind(:,2,ityr).*ccya.*wz(:,1).*(X(:,2)-X(:,1));
%     dXy2(:,1) = 0;
%     dXy2 = dXy2.*poswind;
%     
%     % neg wind
%     dXy3(:,1:end-2) = inputs.ANCIL.VWind.VWind(:,1:end-2,ityr).*ccya.*(wz(:,2:end-1).*(X(:,1:end-2)-X(:,2:end-1))+wz(:,3:end).*(X(:,1:end-2)-X(:,3:end)))./3;
%     dXy3(:,end-1) = inputs.ANCIL.VWind.VWind(:,end-1,ityr).*ccya.*wz(:,end).*(-X(:,end-1)+X(:,end));
%     dXy3(:,end) = 0;
%     dXy3 = dXy3.*negwind;
%     dXy2 = dXy2 + dXy3;        
%     
%     % positive wind
%     dXx(:,dxlarge) = -inputs.ANCIL.UWind.UWind(:,dxlarge,ityr).*ccxa(dxlarge).*(wz(lonleft1,dxlarge).*(X(:,dxlarge)-X(lonleft1,dxlarge))...
%              +wz(lonleft2,dxlarge).*(X(:,dxlarge)-X(lonleft2,dxlarge)) )./3;
%     dXx = dXx.*poswind2;
%     
%     %negative wind
%     dXx2(:,dxlarge) = inputs.ANCIL.UWind.UWind(:,dxlarge,ityr).*ccxa(dxlarge).*(wz(lonright1,dxlarge).*(X(:,dxlarge)-X(lonright1,dxlarge))...
%              +wz(lonright2,dxlarge).*(X(:,dxlarge)-X(lonright2,dxlarge)) )./3;
%     dXx2 = dXx2.*negwind2;
%     dXx = dXx + dXx2;
%         
%     dd=max(1,round(inputs.param.timestep_circ./(dxlat./10/.1))); 
%     dtdff2=inputs.param.timestep_circ./dd;
%     time2=max(1,round(inputs.param.timestep_circ./dtdff2));
%     ccx2=dtdff2./dxlat./2;
%     
%     Xh = X;    
%     for k = 1:length(dxsmall)
%         for tt2 = 1:time2(dxsmall(k))      % additional time loop  
%                         
%             % positive wind
%             dXx(:,dxsmall(k))= -inputs.ANCIL.UWind.UWind(:,dxsmall(k),ityr).*ccx2(dxsmall(k)).*(10.*wz(lonleft1,dxsmall(k)).*(Xh(:,dxsmall(k)) - Xh(lonleft1,dxsmall(k)))... 
%                 +4.*wz(lonleft2,dxsmall(k)).*(Xh(lonleft1,dxsmall(k)) - Xh(lonleft2,dxsmall(k))) + 1.*wz(lonleft3,dxsmall(k)).*(Xh(lonleft2,dxsmall(k)) - Xh(lonleft3,dxsmall(k))))./20;
%             dXx(:,dxsmall(k)) = dXx(:,dxsmall(k)).*poswind2(:,dxsmall(k));
%                         
%             % negative wind
%             dXx2(:,dxsmall(k))= inputs.ANCIL.UWind.UWind(:,dxsmall(k),ityr).*ccx2(dxsmall(k)).*(10.*wz(lonright1,dxsmall(k)).*(Xh(:,dxsmall(k)) - Xh(lonright1,dxsmall(k)))... 
%                 +4.*wz(lonright2,dxsmall(k)).*(Xh(lonright1,dxsmall(k)) - Xh(lonright2,dxsmall(k))) + 1.*wz(lonright3,dxsmall(k)).*(Xh(lonright2,dxsmall(k)) - Xh(lonright3,dxsmall(k))))./20;
%             dXx2(:,dxsmall(k)) = dXx2(:,dxsmall(k)).*negwind2(:,dxsmall(k));            
%             dXx(:,dxsmall(k)) = dXx(:,dxsmall(k)) + dXx2(:,dxsmall(k));                                            
%             
%             dXx (dXx <= -Xh) = -.9.*Xh(dXx <= -Xh); % this ensures water vapor does not go below 0            
%             
%             Th(:,dxsmall(k)) = Xh(:,dxsmall(k)) + dXx(:,dxsmall(k)); 
%             Xh(:,dxsmall(k)) = Th(:,dxsmall(k));                                          
%             
%         end
%     end
%     
%     dXx(:,dxsmall) = Th(:,dxsmall)-X(:,dxsmall);    
%     dX_advec = dXx + dXy2;
%     X = X + dX_diffuse + dX_advec;     
%     %X = X + dX_diffuse;                  
% end    
