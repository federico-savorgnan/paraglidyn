function [Pilot_alfa] = pilot_alfa(filename, ID_plot, N, time)
  %% Pilot Eff
    figure(ID_plot)
    hold on
    grid on
    title('Wing Alfa')
    xlabel('Wingspan')
    ylabel('Time [s]')
    zlabel('Alfa [deg]')

    DATA = load([filename(1:end-2), 'aer']);

    np = 3 * N.aer_int_pts ;

    for i = 1 : N.beam
      for j = 1 : np
        alfa(:,(i-1)*np+j) = DATA(i:N.beam:end, 2+8*(j-1));
      end
    end

    surf(1:N.beam*np, time,  alfa )
end
