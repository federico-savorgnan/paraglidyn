function [Pilot_x] = pilot_x(filename, ID_plot, N)
  %% Pilot path
    figure(ID_plot, 'Position', [50 100 1150 600])
    subplot(1,2,1)
    hold on
    grid on
    axis equal
    title('Pilot and Wing path')
    xlabel('X [m]')
    ylabel('Y [m]')
    zlabel('Z [m]')
    Pilot_x = ncread(filename, 'node.struct.1.X');
    for i = 1 : N.ribs
      rib(i).x = ncread(filename, ['node.struct.', num2str(1e4+i), '.X']);
      if i > N.ribs/2
        lr = 'g';
      else
        lr = 'r' ;
      end
      plot3(rib(i).x(1,:),rib(i).x(2,:),rib(i).x(3,:), lr)
    end
    plot3(Pilot_x(1,:),Pilot_x(2,:),Pilot_x(3,:), 'k')


  %% Pilot path 2D
    subplot(1,2,2)
    title('Pilot vertical path')
    xlabel('X [m]')
    ylabel('Z [m]')
    plot(Pilot_x(1,:)-Pilot_x(1,1),Pilot_x(3,:)-Pilot_x(3,1))

end
