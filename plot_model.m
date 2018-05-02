
  disp('Plotting 3D view');
% PLOT INPUT GEOMETRY
    figure('Position',[200 200 2000 1000])
    subplot(1,2,1)
    hold on
    grid on
    axis equal
    view( -25, 15 );
    xlabel('X [m]')
    ylabel('Y [m]')
    zlabel('Z [m]')
  % Right wing
    plot3(rib.LE(:,1),rib.LE(:,2),rib.LE(:,3) ,'-', 'Color', [1. .3 0.]);
    plot3(rib.TE(:,1),rib.TE(:,2),rib.TE(:,3) ,'-', 'Color', [.9 .6 0.]);
    plot3(rib.xA(:,1),rib.xA(:,2),rib.xA(:,3) ,'or');
    plot3(rib.xB(:,1),rib.xB(:,2),rib.xB(:,3) ,'ok');
    plot3(rib.x(:,1),rib.x(:,2),rib.x(:,3) ,'-*', 'Color', [0. .5 1.]);
    plot3(pAC*rib.chord(:,1)+rib.LE(:,1),rib.x(:,2),rib.x(:,3) ,'*g');

  % RIBS lines
    for i = 1 : N.ribs
      text(rib.LE(i,1),rib.LE(i,2),rib.LE(i,3),num2str(i), 'fontsize', 16)
      plot3([rib.LE(i,1), rib.TE(i,1)], [rib.LE(i,2), rib.TE(i,2)], [rib.LE(i,3), rib.TE(i,3)],':k');
    end

  % Knots
      for i = 1 : length(knot)
          plot3(knot(i).xA(1), knot(i).xA(2), knot(i).xA(3),'or');
          plot3(knot(i).xB(1), knot(i).xB(2), knot(i).xB(3),'ok');
      end

  % Rope TOP Lines
  for i = 1 :  length(knot)
    for j = 1 : length(knot(i).nrib)
      plop.line_A = plot3( [rib.xA(knot(i).nrib(j),1), knot(i).xA(1)], [rib.xA(knot(i).nrib(j),2), knot(i).xA(2)], [rib.xA(knot(i).nrib(j),3), knot(i).xA(3)] ,':', 'Color', [1. 0. 0.]);
      plop.line_B = plot3( [rib.xB(knot(i).nrib(j),1), knot(i).xB(1)], [rib.xB(knot(i).nrib(j),2), knot(i).xB(2)], [rib.xB(knot(i).nrib(j),3), knot(i).xB(3)] ,':', 'Color', [0. 0. 0.]);
    end
  end

  % Rope LOW Lines
  for i = 1 : length(knot)/2
      plop.line_A1L = plot3( [pilot.x(1), knot(i).xA(1)], [pilot.x(2)-pilot.d/2, knot(i).xA(2)], [pilot.x(3)+pilot.h, knot(i).xA(3)] ,':r');
      plop.line_B1L = plot3( [pilot.x(1), knot(i).xB(1)], [pilot.x(2)-pilot.d/2, knot(i).xB(2)], [pilot.x(3)+pilot.h, knot(i).xB(3)] ,':k');
  end
  for i = length(knot)/2 + 1 : length(knot)
      plop.line_A1R = plot3( [pilot.x(1), knot(i).xA(1)], [pilot.x(2)+pilot.d/2, knot(i).xA(2)], [pilot.x(3)+pilot.h, knot(i).xA(3)] ,':r');
      plop.line_B1R = plot3( [pilot.x(1), knot(i).xB(1)], [pilot.x(2)+pilot.d/2, knot(i).xB(2)], [pilot.x(3)+pilot.h, knot(i).xB(3)] ,':k');
  end




  % Pilot and Carabiners
    plop.pilot = plot3(pilot.x(1),pilot.x(2),pilot.x(3),'^k');
    plop.l_carab = plot3(pilot.x(1),pilot.x(2)-pilot.d/2,pilot.x(3)+pilot.h,'sr');
    plop.r_carab = plot3(pilot.x(1),pilot.x(2)+pilot.d/2,pilot.x(3)+pilot.h,'sg');


%----------------------------------------

%legend([ plop.x, plop.ac, plop.line, plop.le, plop.pilot, plop.l_carab, plop.r_carab ], ...
%'Ribs CG', 'Ribs AC', 'Lines', 'Wing surface', 'Pilot CG', 'Left Carabiner', 'Right Carabinier');

%{

figure(2)
  hold on
  %grid on
  axis equal
  lv = 0.5;
  im_ex=imread('exampl.jpg');
  imshow(im_ex);
  f_sc = - 0.5*size(im_ex,2) / rib.x(1,2) ;

% Mid wing line
  plot((rib.x(:,2)-rib.x(1,2))*f_sc, -rib.x(:,3)*f_sc, '*-r');
% Normal wing points
  plot((rib.x(:,2)-rib.x(1,2))*f_sc - lv*sin(rib.th)*f_sc, -rib.x(:,3)*f_sc - lv*cos(rib.th)*f_sc, '*r' )

%}



    subplot(3,2,2)
    hold on
    grid on
    axis equal
    axis([- 1.1*wing.span/2, 1.1*wing.span/2, 0., max(rib.TE(:,1)) ])
    plot(wing.x(:,2), wing.x(:,1))
    plot(wing.LE(:,2), wing.LE(:,1))
    plot(wing.TE(:,2), wing.TE(:,1))
    plot(wing.xA(:,2), wing.xA(:,1), 'ok')
    plot(wing.xB(:,2), wing.xB(:,1), 'ok')
    for i = 1 : N.ribs
      plot([wing.LE(i,2), wing.TE(i,2)],[wing.LE(i,1), wing.TE(i,1)], 'k:')
    end
    legend('Beam', 'LE', 'TE')






subplot(3,2,4)
hold on
grid on
axis([- 1.1*wing.span/2, 1.1*wing.span/2 ])
plot(wing.x(:,2), wing.th*180/pi)
plot(wing.x(:,2), wing.th_LE*180/pi)
plot(wing.x(:,2), wing.th_TE*180/pi)
plot(wing.I(:,2),wing.I_th*180/pi)
plot(wing.II(:,2),wing.II_th*180/pi)
xlabel('Wingspan [m]')
ylabel('Plane geometry angle [deg]')
legend('Beam', 'LE', 'TE')

subplot(3,2,6)
hold on
grid on
axis equal
view( -90, 0 );
% axis([0., max(rib.TE(:,1)), -wing.span/2, wing.span/2, min(rib.x(:,3)), 0. ])
xlabel('X - axis [m]')
ylabel('Y - axis [m]')
zlabel('Z - axis [m]')
plot3(rib.x(:,1), rib.x(:,2), rib.x(:,3), '-k')
plot3(wing.LE(:,1), wing.LE(:,2), wing.LE(:,3),'*-b')
plot3(wing.TE(:,1), wing.TE(:,2), wing.TE(:,3),'b')
plot3(rib.LE(:,1), rib.LE(:,2), rib.LE(:,3),'*-r')
plot3(rib.TE(:,1), rib.TE(:,2), rib.TE(:,3),'r')
for i = 1 : N.ribs
  plot3([wing.LE(i,1), wing.TE(i,1)],[wing.LE(i,2), wing.TE(i,2)],[wing.LE(i,3), wing.TE(i,3)], 'b')
    plot3([rib.LE(i,1), rib.TE(i,1)],[rib.LE(i,2), rib.TE(i,2)],[rib.LE(i,3), rib.TE(i,3)], 'r')
end
%---------------------------------------


%--------------------------------

figure('Position',[200 200 1600 700])
subplot(1,2,1)
hold on
grid on
axis equal
xlabel('Y - axis, Wingspan [m]')
ylabel('Z - axis, Heigh [m]')
% Mid wing line
leg_wing = plot(rib.x(ceil(N.ribs/2):end,2), rib.x(ceil(N.ribs/2):end,3), '*-r', 'LineWidth', 2 );
leg_pilot = plot(pilot.x(2), pilot.x(3), '^r');

% Rope TOP Lines
for i = length(knot)/2 + 1 :  length(knot)
  for j = 1 : length(knot(i).nrib)
      plot( [rib.xA(knot(i).nrib(j),2), knot(i).xA(2)], [rib.xA(knot(i).nrib(j),3), knot(i).xA(3)] ,'-ok', 'LineWidth', 2 );
  end
end

% Rope LOW Lines
for i = length(knot)/2 + 1 : length(knot)
    leg_line = plot( [pilot.x(2)+pilot.d/2, knot(i).xA(2)], [pilot.x(3)+pilot.h, knot(i).xA(3)] ,'-ok', 'LineWidth', 2 );
end



for i = 1 : N.ribs
  lp(i) = (  - pilot.x(3) + rib.x(i,3) + rib.x(i,2)/tan(rib.th(i)) ) .* sin(rib.th(i));
  z0(i,:) = [0., rib.x(i,3) + rib.x(i,2)/tan(rib.th(i))] ;
end


for i = ceil(N.ribs/2) : N.ribs
  leg_norm = plot([z0(i,1), rib.x(i,2)], [z0(i,2), rib.x(i,3)], ':b');
end

for i = ceil(N.ribs/2):N.ribs
  text(rib.x(i,2), rib.x(i,3),num2str(i), 'fontsize', 14);
end

% axis([ 0., 1.1*wing.span/2, min([z0(:,2); pilot.x(3)]), 0.5 ]);
legend([leg_wing, leg_line, leg_norm, leg_pilot], 'Wing profile', 'Rope lines', 'Wing normal dir.', 'Pilot', 'Location', 'SouthEast');


%--------------------------------

subplot(1,2,2)
hold on
grid on
xlabel('Wingspan [m]')
ylabel('Wing section lever arm to Pilot [m]')
plot(wing.x(ceil(N.ribs/2):end,2), lp(ceil(N.ribs/2):end),'-ob');
for i = ceil(N.ribs/2):N.ribs
  text(wing.x(i,2), lp(i),num2str(i), 'fontsize', 14);
end
