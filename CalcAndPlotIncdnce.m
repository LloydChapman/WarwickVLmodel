function [incdnce,ax,h]=CalcAndPlotIncdnce(t,Y,eqlbrtn_time,fut_yrs,ttl,newfig,str)
%CALCANDPLOTINCDNCE Calculate and plot predicted incidence from model.
if newfig
    figure;
    ax=gca;
else
    ax=gca;
end
C=Y(:,8);
% Calculate VL incidence (per 10,000/yr)
incdnce=1e4*365*(C-[0;C(1:end-1)]);
% Make index vector for times to plot incidence (including 2 years prior to
% start of interventions)
Nt=numel(t);
idx=(Nt-(fut_yrs+2)*365+1):Nt;

if strcmp(str,'crrnt') % plot predicted district incidences
h=plot(2012+t(idx)/365-eqlbrtn_time,incdnce(idx),2012+t(idx)/365-eqlbrtn_time,ones(1,numel(t(idx))),'r--');
xlabel('Year'); ylabel('VL Incidence (per 10,000/yr)'); title(ttl)
elseif strcmp(str,'altntve') % plot predicted incidence at sub-district level for alternative interventions
h=plot(t(idx)/365-eqlbrtn_time,incdnce(idx),t(idx)/365-eqlbrtn_time,ones(1,numel(t(idx))),'r--');
xlabel('Years after start of intervention'); ylabel('VL Incidence (per 10,000/yr)'); title(ttl)
end

pause(0.001)
