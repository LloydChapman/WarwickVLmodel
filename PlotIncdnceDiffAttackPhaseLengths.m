function PlotIncdnceDiffAttackPhaseLengths(t,models,fut_yrs,eqlbrtn_time,incdnces,attack_dur,rslts)
%PLOTINCDNCEDIFFATTACKPHASELENGTHS Plot predicted incidence for different
%lengths of WHO attack phase.
incdnce=csvread(rslts,1);

for i=1:numel(models)
    for j=1:numel(incdnces)
        figure; plot(t/365-eqlbrtn_time,incdnce(:,numel(incdnces)*(numel(attack_dur)*(i-1):numel(attack_dur)*i-1)+j),t/365-eqlbrtn_time,ones(1,numel(t)),'k--');
        title(['Pre-control endemicity = ' num2str(incdnces(j)) '/10,000/yr'])
        xlabel('Years after start of intervention')
        ylabel('VL incidence (cases/10,000/yr)')
        xlim([-2 fut_yrs])
        yl=ylim;
        ylim([0 yl(2)])
        lgtxt=cell(1,numel(attack_dur));
        for k=1:numel(attack_dur)
           lgtxt{k}=[num2str(attack_dur(k)) '-yr attack phase'];
        end
        legend(lgtxt)
        saveas(gcf,['ModelW' num2str(models(i)) '_' num2str(incdnces(j)) '_DiffAttackPhases'])
        saveas(gcf,['ModelW' num2str(models(i)) '_' num2str(incdnces(j)) '_DiffAttackPhases.png'],'png')
    end
end