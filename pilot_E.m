function [Pilot_E] = pilot_E(filename, ID_plot, N, time)
  %% Pilot angles
    figure(ID_plot)
    hold on
    grid on

    title('Central rib Euler angles')
    xlabel('time [s])')
    ylabel('E angles [deg]')
    Pilot_E = ncread(filename, ['node.struct.', num2str(5e4+N.ribs/2),'.E']);
    plot(time, Pilot_E(1,:), 'r');
    plot(time, Pilot_E(2,:), 'g');
    plot(time, Pilot_E(3,:), 'b');
  %  legend('ROLL', 'PITCH', 'YAW', 'Location', 'NorthWest')
end
