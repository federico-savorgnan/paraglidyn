function [f1, f2, m1, m2] = joint_f(filename, ID_plot, N, time)
  %% WING JOINTS FORCES
    figure(ID_plot, 'Position', [50 100 1150 600])
    subplot(1,2,1)
    hold on
    grid on
    title('Wing Joint Traslational Forces')
    xlabel('time [s]')
    ylabel('Force [N]')
    for i = 1 : N.cell
      f1 = ncread(filename, ['elem.joint.', num2str(6e4+i),'.f']);
      plot(time, f1(1,:), 'r');
      plot(time, f1(2,:), 'g');
      plot(time, f1(3,:), 'b');
      legend('X', 'Y', 'Z')

      f2 = ncread(filename, ['elem.joint.', num2str(7e4+i),'.f']);
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
  for i = 1 : N.cell
    m1 = ncread(filename, ['elem.joint.', num2str(8e4+i),'.m']);
    plot(time, m1(1,:), 'r');
    plot(time, m1(2,:), 'g');
    plot(time, m1(3,:), 'b');
    legend('X', 'Y', 'Z')

    m2 = ncread(filename, ['elem.joint.', num2str(9e4+i),'.m']);
    plot(time, m2(1,:), 'r');
    plot(time, m2(2,:), 'g');
    plot(time, m2(3,:), 'b');
    legend('X', 'Y', 'Z')
  end

end
