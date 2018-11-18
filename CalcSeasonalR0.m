function R0=CalcSeasonalR0(n,nVstar,b,pH,gamma,delta,tau,mu,mu1,mu2,f1,f2,a1,a2,omega,p1,p2,p3,sigma,muV)
%CALCSEASONALR0 Calculate R0 with seasonal variation in sandfly population. 
%   Uses Floquet theory approach of Bacaer 2007 (see Sec 3.1.2 in 
%   Supplementary File S1 of Le Rutte and Chapman et al, "Elimination of 
%   visceral leishmaniasis in the Indian subcontinent: a comparison of 
%   predictions from three transmission models", Epidemics 2017. 
%   https://ars.els-cdn.com/content/image/1-s2.0-S1755436516300792-mmc1.pdf)

% Make transmissions and transitions matrices, T and Sigma, for infection 
% sub-system (equations for infected states)
T=zeros(n,n);
if n==7 % 2 VL sub-compartments
    T(6,1:5)=b*[p1,p2,p2,p3,p3];
    Sigma=diag([gamma+mu,2*delta+mu1,2*delta+mu1,tau+mu2,tau+mu2,0,0],0);
    Sigma(3,2)=-2*delta;
    Sigma(4,3)=-2*delta;
    Sigma(5,4)=-f2*tau;
elseif n==6 % 1 VL compartment
    T(5,1:4)=b*[p1,p2,p3,p3];
    Sigma=diag([gamma+mu,delta+mu1,tau+mu2,tau+mu2,0,0],0);
    Sigma(3,2)=-delta;
    Sigma(4,3)=-f2*tau;
end
Sigma(2,1)=-f1*gamma;
Sigma(end,end-1)=-sigma;

% Initial guess for R0
lambda0=1.5;
options=optimset('Display','off');
% Calculate R0
R0=fsolve(@(lambda)CalcSpctrlRdsFndmntlMtrxSoln(lambda,n,T,Sigma,nVstar,b,pH,sigma,muV,a1,a2,omega),lambda0,options);
