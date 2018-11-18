function dYdt=TransmssnODEsWHO(t,Y,b,pH,gamma,delta,tau,kappa,mu,mu1,mu2,f1,f2,a1,a2,omega,p1,p2,p3,sigma,muV,nVstar,cvrg,eff,tOT,tIRS,tOT1,tIRS1)
%TRANSMSSNODESWHO ODEs that define Warwick W0 and W1 transmission models.
%   See Sec 2 in Supplementary File S1 of Le Rutte and Chapman et al, 
%   "Elimination of visceral leishmaniasis in the Indian subcontinent: a 
%   comparison of predictions from three transmission models", Epidemics 2017. 
%   https://ars.els-cdn.com/content/image/1-s2.0-S1755436516300792-mmc1.pdf)
dYdt=zeros(numel(Y),1);

% Set step-change in OT time at t=tOT
if t<=tOT
    delta=delta(1);
elseif t>tOT && t<=tOT1
    delta=delta(2);
else
    delta=delta(3);
end

% Human stages, as proportions of the total human population
S=Y(1); % susceptible
A=Y(2); % asymptomatic
K1=Y(3); % clinical VL 1
T1=Y(4); % treated 1
T2=Y(5); % treated 2

if numel(Y)==9 % 2 VL sub-compartments
    K2=Y(end); % clinical VL 2
    % Calculate force of infection (FOI) towards flies
    lambdaV=b*(p1*A+p2*(K1+K2)+p3*(T1+T2));
    % ODE for K1
    dYdt(3)=f1*gamma*A-(2*delta+mu1)*K1;
    % ODE for K2
    dYdt(end)=2*delta*K1-(2*delta+mu1)*K2;
    % ODE for T1
    dYdt(4)=2*delta*K2-(tau+mu2)*T1;
    % Set human birth rate to match population loss due to death and excess 
    % mortality from VL and treatment
    alpha=mu+(mu1-mu)*(K1+K2)+(mu2-mu)*(T1+T2);
    % Proportion recovered
    R=1-sum(Y(1:5))-K2;
elseif numel(Y)==8 % 1 VL compartment
    % Calculate FOI towards flies
    lambdaV=b*(p1*A+p2*K1+p3*(T1+T2));
    % ODE for K1
    dYdt(3)=f1*gamma*A-(delta+mu1)*K1;
    % ODE for T1
    dYdt(4)=delta*K1-(tau+mu2)*T1;
    % Set human birth rate to match population loss due to death and excess 
    % mortality from VL and treatment
    alpha=mu+(mu1-mu)*K1+(mu2-mu)*(T1+T2);
    % Proportion recovered
    R=1-sum(Y(1:5));    
end

% Sandfly stages, as proportions of the total sandfly population
SV=Y(6); % susceptible
IV=Y(7); % infectious
EV=1-SV-IV; % latently infected

% Proportional increase in sandfly death rate due to IRS
epsilon=cvrg*eff;
% Start IRS at t=tIRS
if t<=tIRS
    % SHR before start of IRS
    nV=nVstar*exp(muV*a1*sin(omega*t+a2)/omega);
elseif t>tIRS && t<=tIRS1
    % SHR after start of intensive IRS
    nV=nVstar*exp(muV*(a1*sin(omega*t+a2)/omega-epsilon(1)*(t-tIRS)));
else
    % SHR with more limited IRS after 5 years of intensive IRS
    nV=nVstar*exp(muV*(a1*sin(omega*t+a2)/omega-epsilon(2)*(t-tIRS1)-epsilon(1)*(tIRS1-tIRS)));  
end

% Calculate FOI towards humans
lambdaH=b*pH*nV*IV;

% Calculate sandfly birth rate
alphaV=muV*(1+a1*cos(omega*t+a2));

% ODEs
% Humans
dYdt(1)=alpha-(lambdaH+mu)*S+kappa*R;
dYdt(2)=lambdaH*S-(gamma+mu)*A;
dYdt(5)=f2*tau*T1-(tau+mu2)*T2;

% Sandflies
dYdt(6)=alphaV-(lambdaV+alphaV)*SV;
dYdt(7)=sigma*EV-alphaV*IV;

% Cumulative incidence of VL cases
dYdt(8)=f1*gamma*A;