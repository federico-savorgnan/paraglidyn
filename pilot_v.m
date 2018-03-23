function [Pilot_v] = pilot_v(filename, ID_plot, time)
  %% Pilot velocity
    figure(ID_plot)
    hold on
    grid on

    title('Pilot velocity')
    xlabel('time step')
    ylabel('Velocity [m/s]')

    Pilot_v = norm(ncread(filename, ['node.struct.1.XP']),'columns');
    plot(time,Pilot_v)
end
