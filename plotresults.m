% plotting 1D model
inputs = Minputs;
inputs.fluxcorrections = 0;
d.control = load([inputs.outputdir,'data/','control','_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours.mat']);
d.controlflux = load([inputs.outputdir,'data/','control','_','1','_',sprintf('%.2f',inputs.hourstep),'hours.mat']);
d.doublelinear = load([inputs.outputdir,'data/','doublelinear','_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours.mat']);
d.doublelinearflux = load([inputs.outputdir,'data/','doublelinear','_','1','_',sprintf('%.2f',inputs.hourstep),'hours.mat']);
d.doublelinearflux_nohcl = load([inputs.outputdir,'data/','doublelinear','_','1','_',sprintf('%.2f',inputs.hourstep),'hours_nohclflux.mat']);

% d.doublelinear_5timesSAD = load([inputs.outputdir,'data/','doublelinear','_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours_5xSAD.mat']);
%d.solubility = load([inputs.outputdir,'data/','solubility','_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours.mat']);
%d.SAD5 = load([inputs.outputdir,'data/','doublelinear','_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours_5xSAD.mat']);
% doublelinear2 = load([inputs.outputdir,'data/','doublelinear','_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours_nohclfluxcorrection.mat']);
% doublelinear3 = load([inputs.outputdir,'data/','doublelinear','_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours_nohno3fluxcorrection.mat']);
% doublelinear4 = load([inputs.outputdir,'data/','doublelinear','_',num2str(inputs.fluxcorrections),'_',sprintf('%.2f',inputs.hourstep),'hours_fluxtodummy.mat']);

%%
df = fields(d);
tickout = monthtick('short',0);
vars = {'NO2'};
for i = 1:length(vars)
    createfig('medium','on')
    for j = 1:length(df)
        
        ph(j) = plot(1:365,d.(df{j}).dayaverage.(vars{i}),'LineWidth',2);
        hold on                
    end
    
    set(gca,'xtick',tickout.tick,'xticklabels',tickout.monthnames,'fontsize',inputs.fsize);
    xlabel('Month','fontsize',inputs.fsize+2);
    ylabel('Number Density (molecules cm^-^3)','fontsize',inputs.fsize+2);
    title([inputs.runtype,', ',vars{i}],'fontsize',inputs.fsize+4);    
    lh = legend(ph,df,'location','southeastoutside','box','off');
    set(gca,'Yscale','log')
  %  savefigure([inputs.outputdir,'figures/'],[inputs.runtype,'_',inputs.fluxcorrections,'_',vars{i},sprintf('%.2f',inputs.hourstep),'hours'],1,0,0,0);
end

%%
df2 = df
df2(1) = [];
for i = 1:length(vars)
    createfig('medium','on')
    for j = 1:length(df2)
        
        ph2(j) = plot(1:365,d.(df2{j}).dayaverage.(vars{i}) - d.(df{1}).dayaverage.(vars{i}),'LineWidth',2);
        hold on                
    end
    
    set(gca,'xtick',tickout.tick,'xticklabels',tickout.monthnames,'fontsize',inputs.fsize);
    xlabel('Month','fontsize',inputs.fsize+2);
    ylabel('Number Density (molecules cm^-^3)','fontsize',inputs.fsize+2);
    title([inputs.runtype,', ',vars{i}],'fontsize',inputs.fsize+4);    
    lh = legend(ph2,df2,'location','southeastoutside','box','off');
    set(gca,'Yscale','log')
  %  savefigure([inputs.outputdir,'figures/'],[inputs.runtype,'_',inputs.fluxcorrections,'_',vars{i},sprintf('%.2f',inputs.hourstep),'hours'],1,0,0,0);
end