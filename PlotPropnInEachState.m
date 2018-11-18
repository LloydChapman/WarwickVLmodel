function PlotPropnInEachState(t,model,fut_yrs,eqlbrtn_time,incdnce,cvrg,OT,attack_dur,rslts)
%PLOTPROPNINEACHSTATE Plot prevalences of human infection states over time.
load(rslts)

Y=deval(sol,t);
% Calculate recovered proportion
R=1-sum(Y(1:5,:))-Y(9,:);
% Calculate total KA prevalence (sum of the two KA sub-compartments)
K=Y(3,:)+Y(9,:);
% Prevalences over time
Prevs=[Y(1:2,:);K;Y(4:5,:);R]';
% Stacked area plot of prevalences
figure; h=area(t/365-eqlbrtn_time,100*Prevs);
filename=['ModelW' num2str(model) 'Prevs_' num2str(incdnce) '_' num2str(100*cvrg) '_' num2str(OT) '_' num2str(attack_dur) 'YrAttackPhase.csv'];
fid=fopen(filename,'w');
fprintf(fid,'S,A,K,T1,T2,R\n');
fclose(fid);
dlmwrite(filename,Prevs,'-append')
h(1).FaceColor=[0.231 0.471 0.851];
h(2).FaceColor=[0.965 0.698 0.4196];
h(3).FaceColor=[0.8 0.255 0.145];
h(4).FaceColor=[0.867 0.494 0.416];
h(5).FaceColor=[0.867 0.494 0.416];
h(6).FaceColor=[0.216 0.463 0.114];
xlim([-2 fut_yrs])
ylim([70 100])
xlabel('Years since start of intervention')
ylabel('Prevalence (%)')
legend('Susceptible','Asymptomatic','Symptomatic untreated','Treatment 1','Treatment 2','Recovered','Location','Best')
saveas(gcf,['ModelW' num2str(model) 'Prevs_' num2str(incdnce) '_' num2str(100*cvrg) '_' num2str(OT) '_' num2str(attack_dur) 'YrAttackPhase'])
saveas(gcf,['ModelW' num2str(model) 'Prevs_' num2str(incdnce) '_' num2str(100*cvrg) '_' num2str(OT) '_' num2str(attack_dur) 'YrAttackPhase.png'],'png')

