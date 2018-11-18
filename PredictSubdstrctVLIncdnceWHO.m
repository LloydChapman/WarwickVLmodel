function PredictSubdstrctVLIncdnceWHO(model,fut_yrs,tint0,tint1,tOT1,tIRS1,tOT2,tIRS2,attack_dur,incdnces,cvrg0,OT0,cvrgs,OTs,nVstar1_0,n,b,pH,gamma,tau,kappa,mu,mu1,mu2,f1,f2,a1,a2,omega,p1,p2,p3,sigma,muV,initial,eff,eqlbrtn_time)
%PREDICTSUBDSTRCTVLINCDNCEWHO Predict and plot VL incidence for 
%sub-districts with different pre-control endemicities for different 
%intervention strategies.

%% Predict sub-district-level incidence for alternative intervention strategies
%%% Set pre-control parameter values:
% Time span for simulation for fitting pre-control incidence
tspan0=[0,tint0(end)];
% Death rates (use means of district values)
mu=mean(mu);
mu1=mean(mu1);
mu2=mean(mu2);
% Proportion of VL patients who have 2nd treatment (use mean of district
% values)
f2=mean(f2);

% Make vectors for storing pre-control SHRs
Nincdnces=numel(incdnces);
nVstar1=NaN(Nincdnces,1);
incdnceDiff=NaN(Nincdnces,1);
% Set function tolerance for fitting pre-control SHRs 
options=optimset('TolFun',1e-2);
% Relative tolerance and non-negative solutions for ODE solver
optionsDE=odeset('RelTol',1e-6,'NonNegative',1:n+2);
% Fit pre-control SHRs
for i=1:Nincdnces
    % Minimise difference between incidence predicted by model and chosen 
    % pre-control incidence
    [nVstar1(i),incdnceDiff(i)]=fminsearch(@(nVstar)CalcIncdnceDiffWHO(nVstar,n,b,pH,gamma,1/OT0,tau,kappa,mu,mu1,mu2,f1,f2,a1,a2,omega,p1,p2,p3,sigma,muV,incdnces(i),tspan0,initial,optionsDE,tint0,cvrg0,eff,tOT1,tIRS1,tOT2,tIRS2),nVstar1_0(i),options);
end

% Predict sub-district incidence for different IRS coverage and OT 
% reduction combinations
% Time span for simulation
tspan1=[0,tint1(end)];
Ncvrgs=size(cvrgs,1);
N_OTs=size(OTs,1);
incdnce1=NaN(numel(tint1),Nincdnces*Ncvrgs*N_OTs);
lgtxt=cell(Ncvrgs*N_OTs,1);
for i=1:Nincdnces
    for j=1:Ncvrgs
        for k=1:N_OTs
            % Solve transmission ODEs
            sol=ode15s(@(t,Y)TransmssnODEsWHO(t,Y,b,pH,gamma,1./OTs(k,:),tau,kappa,mu,mu1,mu2,f1,f2,a1,a2,omega,p1,p2,p3,sigma,muV,nVstar1(i),cvrgs(j,:),eff,tOT1,tIRS1,tOT2,tIRS2),tspan1,initial,optionsDE);
            % Evaluate solution at times in tint
            Y=deval(sol,tint1)';
            % Make new figure for each pre-control endemicity level
            if j==1 && k==1
                newfig=true;
            else
                newfig=false;
            end
            % Plot solutions
            [incdnce1(:,(Ncvrgs*N_OTs)*(i-1)+N_OTs*(j-1)+k),ax,h1(N_OTs*(j-1)+k,:)]=CalcAndPlotIncdnce(tint1,Y,eqlbrtn_time,fut_yrs,['Pre-control endemicity = ' num2str(incdnces(i)) '/10,000/yr'],newfig,'altntve');
            lgtxt{N_OTs*(j-1)+k}=['IRS cvrge 1 = ' num2str(100*cvrgs(j,1)) '%, IRS cvrge 2 = ' num2str(100*cvrgs(j,2)) '%, OT1 = ' num2str(OTs(k,2)) ' days, OT2 = ' num2str(OTs(k,3)) ' days'];
            hold(ax,'on')
            save(['ModelW' num2str(model) 'ODEsoln_' num2str(incdnces(i)) '_' num2str(100*cvrgs(j,1)) '_' num2str(OTs(k,2)) '_' num2str(attack_dur) 'YrAttackPhase'],'sol')
        end
    end
    xlim([-2 fut_yrs])
    yl=ylim;
    ylim([0 yl(2)]);
    legend(h1(:,1),lgtxt)
    hold(ax,'off')
    saveas(gcf,['ModelW' num2str(model) '_' num2str(incdnces(i)) '_' num2str(attack_dur) 'YrAttackPhase'])
    saveas(gcf,['ModelW' num2str(model) '_' num2str(incdnces(i)) '_' num2str(attack_dur) 'YrAttackPhase.png'],'png')
end
save(['ModelW' num2str(model) 'PrdctdIncdncesWHO' num2str(attack_dur) 'YrAttackPhase'],'tint1','tspan1','incdnces','cvrg0','OT0','tIRS1','tOT1','nVstar1','cvrgs','OTs','Ncvrgs','N_OTs','incdnce1')
