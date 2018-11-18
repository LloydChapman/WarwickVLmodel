function PlotPrevalences(t,Y,n)
%PLOTPREVALENCES Plot prevalences of all human and sandfly infection states.

% Humans
figure(1);
if n==7
    plot(t,[Y(:,1:end-4),Y(:,end)])
%     plot(t((end-29):end),[Y((end-29):end,1:end-4),Y((end-29):end,end)])
    legend('S','A','K_1','T_1','T_2','K_2')
else
    plot(t,Y(:,1:end-3))
%     plot(t((end-29):(end-6)),Y((end-29):(end-6),1:end-3))
    legend('S','A','K_1','T_1','T_2')
end

% Sandflies
figure(2);
plot(t,Y(:,6:7))
% plot(t((end-29):end),Y((end-29):end,6:7))
legend('S_V','I_V')

% Plot cumulative proportion of KA cases
figure(3);
C=Y(:,8);
% plot(t,C)
plot(t((end-29):end),C((end-29):end)-C((end-30):(end-1)))
xlabel('t'); ylabel('K')
pause(0.01)