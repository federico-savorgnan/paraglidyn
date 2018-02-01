function [fA, fB] = lines_f(filename, ID_plot, N, time)
  %% LINE A
    figure(ID_plot, 'Position', [50 100 1150 600])
    subplot(1,2,1)
    hold on
    grid on
    title('Lines A')
    xlabel('time [s]')
    ylabel('Axial force [N]')
    for i = 1 : N.ribs
      fA = ncread(filename, ['elem.joint.', num2str(3e5+i),'.f']);
      plot(time, fA(1,:)');
      text(time(end), fA(1,end), num2str(i))
    end

  %% LINE B
    subplot(1,2,2)
    hold on
    grid on
    title('Lines B')
    xlabel('time [s]')
    ylabel('Axial force [N]')
    for i = 1 : N.ribs
      fB = ncread(filename, ['elem.joint.', num2str(4e5+i),'.f']);
      plot(time, fB(1,:)');
      text(time(end), fB(1,end), num2str(i))
    end