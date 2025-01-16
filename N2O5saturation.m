
normal = load('/Users/kanestone/work/code/BushfireChemModel/output/runoutput/control_19km_-45S_0flux_0.25hoursnormalSAD.mat');
five = load('/Users/kanestone/work/code/BushfireChemModel/output/runoutput/control_19km_-45S_0flux_0.25hoursSAD*5.mat');
twenty = load('/Users/kanestone/work/code/BushfireChemModel/output/runoutput/control_19km_-45S_0flux_0.25hoursSAD*20.mat');
fifty = load('/Users/kanestone/work/code/BushfireChemModel/output/runoutput/control_19km_-45S_0flux_0.25hoursSAD*50.mat');
hundred = load('/Users/kanestone/work/code/BushfireChemModel/output/runoutput/control_19km_-45S_0flux_0.25hoursSAD*100.mat');
hundrednoHCL = load('/Users/kanestone/work/code/BushfireChemModel/output/runoutput/control_19km_-45S_0flux_0.25hoursSAD*100_noHCL.mat');
hundrednoHCLorBRONO2 = load('/Users/kanestone/work/code/BushfireChemModel/output/runoutput/control_19km_-45S_0flux_0.25hoursSAD*100_noHCL.mat');

%%
createfig('medium','on');
tiledlayout(2,2);
nexttile;
hold on
plot(normal.variables.N2O5(3*96+1:4*96),'LineWidth',3)
plot(five.variables.N2O5(3*96+1:4*96),'LineWidth',3)
plot(twenty.variables.N2O5(3*96+1:4*96),'LineWidth',3)
plot(fifty.variables.N2O5(3*96+1:4*96),'LineWidth',3)
plot(hundred.variables.N2O5(3*96+1:4*96),'LineWidth',3)
plot(hundrednoHCL.variables.N2O5(3*96+1:4*96),'LineWidth',3)
plot(hundrednoHCLorBRONO2.variables.N2O5(3*96+1:4*96),'LineWidth',3)
set(gca,'fontsize',18);
ylabel('Number Density','fontsize',20);
xlabel('Hour','fontsize',20);
set(gca,'xtick',0:12:96,'xticklabel',0:3:24)
box on;

nexttile;
hold on
plot(normal.variables.HNO3(3*96+1:4*96),'LineWidth',3)
plot(five.variables.HNO3(3*96+1:4*96),'LineWidth',3)
plot(twenty.variables.HNO3(3*96+1:4*96),'LineWidth',3)
plot(fifty.variables.HNO3(3*96+1:4*96),'LineWidth',3)
plot(hundred.variables.HNO3(3*96+1:4*96),'LineWidth',3)
plot(hundrednoHCL.variables.HNO3(3*96+1:4*96),'LineWidth',3)
set(gca,'fontsize',18);
ylabel('Number Density','fontsize',20);
xlabel('Hour','fontsize',20);
set(gca,'xtick',0:12:96,'xticklabel',0:3:24)
box on

nexttile;
hold on
plot(normal.variables.NO(3*96+1:4*96)+normal.variables.NO2(3*96+1:4*96),'LineWidth',3)
plot(five.variables.NO(3*96+1:4*96)+five.variables.NO2(3*96+1:4*96),'LineWidth',3)
plot(twenty.variables.NO(3*96+1:4*96)+twenty.variables.NO2(3*96+1:4*96),'LineWidth',3)
plot(fifty.variables.NO(3*96+1:4*96)+fifty.variables.NO2(3*96+1:4*96),'LineWidth',3)
plot(hundred.variables.NO(3*96+1:4*96)+fifty.variables.NO2(3*96+1:4*96),'LineWidth',3)
plot(hundrednoHCL.variables.NO(3*96+1:4*96)+fifty.variables.NO2(3*96+1:4*96),'LineWidth',3)
set(gca,'fontsize',18);
ylabel('Number Density','fontsize',20);
xlabel('Hour','fontsize',20);
set(gca,'xtick',0:12:96,'xticklabel',0:3:24)
box on

nexttile;
hold on
plot(normal.variables.O3(3*96+1:4*96),'LineWidth',3)
plot(five.variables.O3(3*96+1:4*96),'LineWidth',3)
plot(twenty.variables.O3(3*96+1:4*96),'LineWidth',3)
plot(fifty.variables.O3(3*96+1:4*96),'LineWidth',3)
plot(hundred.variables.O3(3*96+1:4*96),'LineWidth',3)
plot(hundrednoHCL.variables.O3(3*96+1:4*96),'LineWidth',3)
plot(hundrednoHCLorBRONO2.variables.O3(3*96+1:4*96),'LineWidth',3)
set(gca,'fontsize',18);
ylabel('Number Density','fontsize',20);
xlabel('Hour','fontsize',20);
set(gca,'xtick',0:12:96,'xticklabel',0:3:24)
box on