function [Pilot_Eff] = pilot_Eff(filename, ID_plot, time)
  %% Pilot Eff
    figure(ID_plot)
    hold on
    grid on
    title('Pilot Efficiency')
    xlabel('time [s]')
    ylabel('Ground Efficiency (H/V speed)')
    Pilot_xp = ncread(filename, 'node.struct.1.XP');
    Pilot_Eff = -(Pilot_xp(1,:).^2+Pilot_xp(2,:).^2).^0.5 ./ Pilot_xp(3,:) ;
    plot(time, Pilot_Eff)
end
