function [d1, d2, e1, e2] = joint_x(filename, ID_plot, N, time)
  %% WING JOINTS FORCES
    figure(ID_plot, 'Position', [50 100 1150 600])
    figure(11)
    hold on
    grid on
    title('Wing Joint Displacement')
    xlabel('time [s]')
    ylabel('Disp [m]')
    for i = 1 : N.cell
      d1 = ncread(filename, ['elem.joint.', num2str(6e4+i),'.d']);
      plot(time, d1(1,:), 'r');
      plot(time, d1(2,:), 'g');
      plot(time, d1(3,:), 'b');
      legend('X', 'Y', 'Z')

      d2 = ncread(filename, ['elem.joint.', num2str(7e4+i),'.d']);
      plot(time, d2(1,:), 'r');
      plot(time, d2(2,:), 'g');
      plot(time, d2(3,:), 'b');
      legend('X', 'Y', 'Z')
    end

  %% WING JOINTS MOMENTS
figure(10)
  hold on
  grid on
  title('Wing Joint Rotational Displacement')
  xlabel('time [s]')
  ylabel('Rotation [deg]')
  for i = 1 : N.cell
    e1 = ncread(filename, ['elem.joint.', num2str(8e4+i),'.E']);
    plot(time, e1(1,:), 'r');
    plot(time, e1(2,:), 'g');
    plot(time, e1(3,:), 'b');
    legend('X', 'Y', 'Z')

    e2 = ncread(filename, ['elem.joint.', num2str(9e4+i),'.E']);
    plot(time, e2(1,:), 'r');
    plot(time, e2(2,:), 'g');
    plot(time, e2(3,:), 'b');
    legend('X', 'Y', 'Z')
  end

end
