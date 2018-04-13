function [d1, d2, e1, e2] = joint_x(filename, ID_plot, N, time)
  %% WING JOINTS FORCES
    figure(ID_plot, 'Position', [50 100 1150 600])
    subplot(1,2,1)
    hold on
    grid on
    title('Wing Joint Displacement')
    xlabel('time [s]')
    ylabel('Disp [m]')
    for i = 1 : 2 : N.ribs-2
      d1 = ncread(filename, ['elem.beam.', num2str(4e5+i),'.nu_I']);
      plot(time, d1(1,:), 'r');
      plot(time, d1(2,:), 'g');
      plot(time, d1(3,:), 'b');

        d2 = ncread(filename, ['elem.beam.', num2str(4e5+i),'.nu_II']);
      plot(time, d2(1,:), 'r');
      plot(time, d2(2,:), 'g');
      plot(time, d2(3,:), 'b');
    end

  %% WING JOINTS MOMENTS
  subplot(1,2,2)
  hold on
  grid on
  title('Wing Joint Rotational Displacement')
  xlabel('time [s]')
  ylabel('Rotation [deg]')
  for i = 1 : 2 : N.ribs-2
    e1 = ncread(filename, ['elem.beam.', num2str(4e5+i),'.k_I']);
    plot(time, e1(1,:), 'r');
    plot(time, e1(2,:), 'g');
    plot(time, e1(3,:), 'b');

      e2 = ncread(filename, ['elem.beam.', num2str(4e5+i),'.k_II']);
    plot(time, e2(1,:), 'r');
    plot(time, e2(2,:), 'g');
    plot(time, e2(3,:), 'b');
  end

end
