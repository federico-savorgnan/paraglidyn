function [] = wing_shape(filename, ID_plot, N, time)
  %% WING SHAPE
  figure(ID_plot, 'Position', [50 100 1150 600])
  hold on
  grid on
  axis equal
  title('Wing shape')
  xlabel('X [m]')
  ylabel('Y [m]')
  zlabel('Z [m]')
  X0 = ncread(filename, ['node.struct.', num2str( 5e4 + N.ribs/2 ), '.X']) ;
  R0 = ncread(filename, ['node.struct.', num2str( 5e4 + N.ribs/2 ), '.R']) ;
  pilot.X = ncread(filename, ['node.struct.1.X']) ;
  tt = [ 1 : 10 : size(X0,2) ] ;

  for i = 1 : N.ribs
    X = ncread(filename, ['node.struct.', num2str(1e4+i), '.X']) ;
    for j = 1 : length(tt)
      wing(j).x2(:,i) = R0(:,:,tt(j))' * ( X(:, tt(j)) - X0(:, tt(j))) ;
    end
  end

  for j = 1 : length(tt)
    pilot.x2(:,j) = R0(:,:,tt(j))' * (pilot.X(:, tt(j)) - X0(:, tt(j))) ;
    plot3(wing(j).x2(1,:),wing(j).x2(2,:), wing(j).x2(3,:), '-*')
  end

  plot3(pilot.x2(1,:),pilot.x2(2,:), pilot.x2(3,:), '-*k')

end
