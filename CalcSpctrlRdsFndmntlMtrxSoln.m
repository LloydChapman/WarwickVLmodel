function F=CalcSpctrlRdsFndmntlMtrxSoln(lambda,n,T,Sigma,nVstar,b,pH,sigma,muV,a1,a2,omega)
%CALCSPCTRLRDSFNDMNTLMTRXSOLN Calculate spectral radius of fundamental 
%matrix solution of linearised infection subsystem.
%   Solves eigenvalue problem defined by Eqns (21)-(26) in Sec 3.1.2 of 
%   Supplementary File S1 of Le Rutte and Chapman et al, "Elimination of 
%   visceral leishmaniasis in the Indian subcontinent: a comparison of 
%   predictions from three transmission models", Epidemics 2017. 
%   https://ars.els-cdn.com/content/image/1-s2.0-S1755436516300792-mmc1.pdf
tspan=[0,2*pi/omega];
psi=zeros(n,n);
for i=1:n
   X0=zeros(n,1);
   X0(i)=1;
   [~,X]=ode45(@(t,X)LnrsdInfctnSubsystem(t,X,lambda,T,Sigma,nVstar,b,pH,sigma,muV,a1,a2,omega),tspan,X0);
   psi(:,i)=X(end,:)';
end

if sum(isnan(psi))==0 & sum(isinf(psi))==0
    F=max(eig(psi))-1;
else
    F=1e10;
end
