function [f1, f2, m1, m2] = joint_f(filename, ID_plot, N, time)
  %% WING JOINTS FORCES
    figure(ID_plot, 'Position', [50 100 1150 600])
    subplot(1,2,1)
    hold on
    grid on
    title('Wing Bram Traslational Forces')
    xlabel('time [s]')
    ylabel('Force [N]')
    for i = 1 : 2 : N.ribs-2
      f1 = ncread(filename, ['elem.beam.', num2str(4e5+i),'.F_I']);
      plot(time, f1(1,:), 'r');
      plot(time, f1(2,:), 'g');
      plot(time, f1(3,:), 'b');
      legend('X', 'Y', 'Z')

      f2 = ncread(filename, ['elem.beam.', num2str(4e5+i),'.F_II']);
      plot(time, f2(1,:), 'r');
      plot(time, f2(2,:), 'g');
      plot(time, f2(3,:), 'b');
      legend('X', 'Y', 'Z')
    end

  %% WING JOINTS MOMENTS
  subplot(1,2,2)
  hold on
  grid on
  title('Wing Joint Rotational Forces')
  xlabel('time [s]')
  ylabel('Moment [Nm]')
  for i = 1 : 2 : N.ribs-2
    m1 = ncread(filename, ['elem.beam.', num2str(4e5+i),'.M_I']);
    plot(time, m1(1,:), 'r');
    plot(time, m1(2,:), 'g');
    plot(time, m1(3,:), 'b');
    legend('X', 'Y', 'Z')

    m2 = ncread(filename, ['elem.beam.', num2str(4e5+i),'.M_II']);
    plot(time, m2(1,:), 'r');
    plot(time, m2(2,:), 'g');
    plot(time, m2(3,:), 'b');
    legend('X', 'Y', 'Z')
  end

end
