function incdnceDiff=CalcIncdnceDiffWHO(nVstar,n,b,pH,gamma,delta,tau,kappa,mu,mu1,mu2,f1,f2,a1,a2,omega,p1,p2,p3,sigma,muV,incdnce,tspan,initial,optionsDE,tint,cvrg,eff,tOT,tIRS,tOT1,tIRS1)
%CALCINCDNCEDIFFWHO Calculate difference of model incidence from target 
%pre-control incidence.

% Calculate R0 with seasonality
R0=CalcSeasonalR0(n,nVstar,b,pH,gamma,delta,tau,mu,mu1,mu2,f1,f2,a1,a2,omega,p1,p2,p3,sigma,muV);
if R0<=1 % no endemic equilibrium
    incdnceDiff=NaN; % don't run simulation & set error in incidence to NaN
else
    % Solve transmission ODEs
    sol=ode15s(@(t,Y)TransmssnODEsWHO(t,Y,b,pH,gamma,delta,tau,kappa,mu,mu1,mu2,f1,f2,a1,a2,omega,p1,p2,p3,sigma,muV,nVstar,cvrg,eff,tOT,tIRS,tOT1,tIRS1),tspan,initial,optionsDE);
    % Evaluate solution at times in tint
    Y=deval(sol,tint)';
    % Plot solutions
%     PlotPrevalences(tint,Y,n) % uncomment this line to view prevalences of human and sandfly states
    % Calculate annual incidence from model and difference from required incidence
    C=Y(:,8);
    AnnlIncdnce=1e4*(C(end)-C(end-365));
    incdnceDiff=abs(AnnlIncdnce-incdnce);
end