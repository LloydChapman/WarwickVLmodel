%RUNWHOSIMLTNS Script to run simulations of WHO guidelines for VL control.
%   Set model (W0/W1), parameters (pre-control endemicities, 
%   pre-control and control IRS and onset-to-treatment (OT) parameter 
%   values, asymptomatic infectiousness, initial guesses for sandfly-to-
%   human ratios, and transmission parameters), initial conditions and 
%   simulation times, and run simulations of WHO guideline interventions, 
%   with different durations of the attack phase.

clear

%% Pre-control parameter values
% Number of years to run the model for to reach equilibrium
eqlbrtn_time=300;
% Endemicity levels
incdnces=[2,5,10];
% IRS coverage level
cvrg0=0;
% Mean onset-treatment time
OT0=60;

%% Control parameter values
% Times of reduction in OT and start of IRS (start of WHO attack phase)
tOT1=eqlbrtn_time*365;
tIRS1=tOT1;

% Different durations of WHO attack phase to test
attack_dur=[0,5,10];

% IRS coverage levels:
% each row represents a different IRS coverage scenario with the two values 
% corresponding to the IRS coverage in the attack and consolidation phases
% cvrgs=[0.67,0.45]; % coverages should be numbers between 0 and 1 to 2d.p.
cvrgs=[0.67,0.45;0,0]; % uncomment to compare 2 scenarios: assumed IRS coverages vs no IRS

% Mean OT times:
% each row represents a different OT scenario with the three values 
% corresponding to the OT in the pre-control, attack and consolidation 
% phases
% OTs=OT0*[1,3/4,1/2];
OTs=OT0*[1,3/4,1/2;1,2/3,1/3]; % uncomment to compare 2 scenarios: assumed OTs vs more rapid OT reduction

% Number of years into the future for which to run simulations
fut_yrs=10;

%% Model-specific parameters
% Model
models=[0,1];
% Asymptomatic infectiousness
p1=[0,0.025];
% Initial guess for baseline sandfly-to-human ratio
nVstar1_0=[1.1,1.3,1.5;0.26,0.28,0.30];

%% Fixed parameter values
%%% Transmission parameters (all rates per day):
% Sandly biting rate
b=1/4;
% Probability of transmission from infected sandfly to susceptible human 
pH=1;  
% Rate determining mean duration of asymptomatic infection (1/gamma) 
gamma=1/150;

% Shape parameter of Erlang distribution for OT times (# of sub-compartments 
% for clinical VL)
shape=2;
% Number of infected states (human + sandfly) 
% = # clinical VL sub-compartments + asymptomatics + treated 1 + treated 2  
%   + latently infected flies + infectious flies                                                    
n=shape+5;

% Rate determining duration of 1st and 2nd treatment for VL
tau=1/28;
% Rate determining mean duration of immunity
kappa=1/(5*365);
% Mean death rate in Bihar (1/(average life expectancy))
mu=1/(68.1*365);
% Excess mortality rate due to VL
muK=1/150;
% Excess mortality rate due to 1st or 2nd treatment
muT=1/600;
% Overall mortality rates for untreated VL and VL patients undergoing 
% treatment
mu1=mu+muK;
mu2=mu+muK+muT;
% Proportion of asymptomatic individuals who develop clinical VL
f1=0.03;
% Proportion of VL patients who have 2nd treatment (from CARE 2012-13 data)
f2=[102/1595; 99/1361; 127/909; 165/752; 52/483; 56/387; 27/286; 10/157];
% Relative amplitude of seasonal variation in sandfly birth rate
a1=0.3;
% Phase shift of seasonal variation in sandfly birth rate
a2=2*pi/3;
% Frequency of oscillations in sandfly birth rate (annual)
omega=2*pi/365;
% Infectiousness of clinical VL cases (reference value)
p2=1;
% Relative infectiousness of patients undergoing 1st or 2nd treatment
p3=0.5;
% Rate determining mean duration of latent infection in sandfly
sigma=1/8;
% Rate determining mean sandfly life expectancy
muV=1/14;

%%% IRS parameters:
% IRS efficacy factor
eff=0.006;

%% Initial conditions
% Population proportions of human stages (susceptible (S), asymptomatic (A), 
% clinical VL 1 (K1), treated 1 (T1), treated 2 (T2))
PropH=[0.9,0.01,4e-5,5e-5,5e-6];
% Proportions of sandfly stages (susceptible (SV), infectious (IV))
PropV=[0.99,0.005];
% Cumulative number of VL cases (C) and proportion of clinical VL 2 (K2)
C0andPropK2=[0.001,4e-5];
% Combined proportions with 2 sub-compartments for clinical VL
initial=[PropH,PropV,C0andPropK2]; % initial=[S0,A0,K10,T10,T20,SV0,IV0,C0,K20] 

%% Time points for evaluation
% Times at which to evaluate incidence up to the start of interventions
tint0=1:365*eqlbrtn_time;
% Times at which to evaluate incidence for predictions
tint1=1:365*(eqlbrtn_time+fut_yrs);

%% WHO guidelines simulations and simulations with different lengths of attack phase
for i=1:numel(models)
    model=models(i);
    p1i=p1(i);
    nVstar1_0i=nVstar1_0(i,:);
    for j=1:numel(attack_dur)
        tOT2j=(eqlbrtn_time+attack_dur(j))*365;
        tIRS2j=tOT2j;
        PredictSubdstrctVLIncdnceWHO(model,fut_yrs,tint0,tint1,tOT1,tIRS1,tOT2j,tIRS2j,attack_dur(j),incdnces,cvrg0,OT0,cvrgs,OTs,nVstar1_0i,n,b,pH,gamma,tau,kappa,mu,mu1,mu2,f1,f2,a1,a2,omega,p1i,p2,p3,sigma,muV,initial,eff,eqlbrtn_time)
    end
end

%% Make results files and plot results for different attack phase lengths
% Vector of times at which to evaluate solutions for saving and plotting
t=(eqlbrtn_time-2)*365:5:(eqlbrtn_time+fut_yrs)*365; % every 5 days
% csv file for simulation results for default attack phase length (5 yrs)
MakeCSVfilesWHOSmltns(t,models,incdnces,cvrgs,OTs,'ModelW0PrdctdIncdncesWHO5YrAttackPhase.mat','ModelW1PrdctdIncdncesWHO5YrAttackPhase.mat')
% Plot prevalences of infection states for default attack phase length and
% 67% IRS coverage and 45-day OT in attack phase
for i=1:numel(models)
   for j=1:numel(incdnces)
       for k=1 % change this to plot for more coverage scenarios
           for l=1 % change this to plot for more OT scenarios
               for m=2 % change this to plot for more attack phase lengths
                   PlotPropnInEachState(t,models(i),fut_yrs,eqlbrtn_time,incdnces(j),cvrgs(k,1),OTs(l,2),attack_dur(m),['ModelW' num2str(models(i)) 'ODEsoln_' num2str(incdnces(j)) '_' num2str(100*cvrgs(k,1)) '_' num2str(OTs(l,2)) '_' num2str(attack_dur(m)) 'YrAttackPhase.mat'])
               end
           end
       end
   end
end
% csv file for simulation results for alternative attack phase lengths (0 and 10 yrs)
MakeCSVfilesWHOSmltnsDiffAttackPhaseLengths(t,models,incdnces,attack_dur,cvrgs,OTs,'ModelW0PrdctdIncdncesWHO0YrAttackPhase.mat','ModelW0PrdctdIncdncesWHO5YrAttackPhase.mat','ModelW0PrdctdIncdncesWHO10YrAttackPhase.mat','ModelW1PrdctdIncdncesWHO0YrAttackPhase.mat','ModelW1PrdctdIncdncesWHO5YrAttackPhase.mat','ModelW1PrdctdIncdncesWHO10YrAttackPhase.mat')
% Plot predicted incidence for different attack phase lengths
PlotIncdnceDiffAttackPhaseLengths(t,models,fut_yrs,eqlbrtn_time,incdnces,attack_dur,'Predictions_W0_W1_Diff_Attack_Phase_Lengths_WHO.csv')