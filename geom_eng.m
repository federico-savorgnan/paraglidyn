% ########################################################################
%
% PARAGLIDYN - Paraglider pre-processor for MBDyn
%
% Copyright (C) 2016 - 2017
% https://github.com/federico-savorgnan/paraglidyn
%
% Federico Savorgnan <federico.savorgnan@gmail.com>
%
%  Changing this copyright notice is forbidden.
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
% ########################################################################

%% Data processing
disp('Computing geometry points')

%% RIBS CG
  % Wingspan discretization (Y coord)
    pi_fact = pi/8 ;
    y_param =  cos(linspace( pi-pi_fact, pi_fact, N.ribs )) ./ cos(pi_fact) ;
    rib.x(:,2) =  vault.xm * y_param ;
  % Arc shape computation (Z coord)
    [ rib.x(:,3), rib.th ] = ellipse(rib.x(:,2), vault);
    rib.x(:,3) = rib.x(:,3) - vault.b ;

%% LEADING and TRAILING ADGE
  % Leading and Trailing edge construction (Y coord)
    rib.LE(:,2) = rib.x(:,2) ;
    rib.TE(:,2) = rib.x(:,2) ;
  % Leading and Trailing edge construction (X coord)
    rib.LE(:,1) = - ellipse(rib.LE(:,2), le) + le.b ;
    rib.TE(:,1) =   ellipse(rib.TE(:,2), te) + le.b ;
  % Leading and Trailing edge construction (Z coord)
    rib.LE(:,3) = rib.x(:,3) ;
    rib.TE(:,3) = rib.x(:,3) ;


  % RIBS chord position (X coord)
    rib.chord = norm(rib.LE-rib.TE, 'rows') ;
    rib.x(:,1) = pCG .* rib.chord + rib.LE(:,1) ;

%% LINES anchor points
  % LINE A
    rib.xA(:,1) = pA' .* rib.chord + rib.LE(:,1) ;
    rib.xA(:,2) = rib.x(:,2) ;
    rib.xA(:,3) = rib.x(:,3) ;
  % LINE B
    rib.xB(:,1) = pB' .* rib.chord + rib.LE(:,1) ;
    rib.xB(:,2) = rib.x(:,2) ;
    rib.xB(:,3) = rib.x(:,3) ;

%% JOINTS points
    box.x = 0.5 * (rib.x(1:(end-1),:) + rib.x(2:end,:));
    box.th1 = atan2(rib.x(2:end,3)-rib.x(1:(end-1),3), rib.x(2:end,2)-rib.x(1:end-1,2)) ;
  % Leading and Trailing edge construction
    box.LE = 0.5 * (rib.LE(1:end-1,:) + rib.LE(2:end,:)) ;
    box.TE = 0.5 * (rib.TE(1:end-1,:) + rib.TE(2:end,:)) ;

%% AERO points
    rib.xaero = 0.5 * (rib.LE + rib.TE);
    box.xaero = 0.5 * (rib.LE + rib.TE);
    box.xaero = 0.5 * (box.LE + box.TE);
  % CELL SPAN
    box.span = norm(rib.x(2:end,:) - rib.x(1:end-1,:), 'rows') ;

%% CHORD length at points
  box.chord = 0.5 * (rib.chord(1:end-1,:) + rib.chord(2:end,:)) ;

  %% TWIST law (TODO)
  rib.twist = twist(rib.x(:,2), rib.tw0, rib.tw1) ;


  % Knots on Lines
  for j = 1 : length(knot)/2
    knot(j).xA(1) = ( (( rib.xA(knot(j).nrib(1),1)+rib.xA(knot(j).nrib(end),1))/2 )  - pilot.x(1) )*knot(j).r + pilot.x(1) ;
    knot(j).xA(2) = ( (( rib.xA(knot(j).nrib(1),2)+rib.xA(knot(j).nrib(end),2))/2 )  - (pilot.x(2)-pilot.d/2) ) * knot(j).r + (pilot.x(2)-pilot.d/2)  ;
    knot(j).xA(3) = ( (( rib.xA(knot(j).nrib(1),3)+rib.xA(knot(j).nrib(end),3))/2 )  - (pilot.x(3)+pilot.h) ) * knot(j).r + (pilot.x(3)+pilot.h) ;

    knot(j).xB(1) = ( (( rib.xB(knot(j).nrib(1),1)+rib.xB(knot(j).nrib(end),1))/2 )  - pilot.x(1) )*knot(j).r + pilot.x(1) ;
    knot(j).xB(2) = ( (( rib.xB(knot(j).nrib(1),2)+rib.xB(knot(j).nrib(end),2))/2 )  - (pilot.x(2)-pilot.d/2) ) * knot(j).r + (pilot.x(2)-pilot.d/2)  ;
    knot(j).xB(3) = ( (( rib.xB(knot(j).nrib(1),3)+rib.xB(knot(j).nrib(end),3))/2 )  - (pilot.x(3)+pilot.h) ) * knot(j).r + (pilot.x(3)+pilot.h) ;
  end

  % Knots on Lines
  for j = length(knot)/2 + 1 : length(knot)
    knot(j).xA(1) = ( (( rib.xA(knot(j).nrib(1),1)+rib.xA(knot(j).nrib(end),1))/2 )  - pilot.x(1) )*knot(j).r + pilot.x(1) ;
    knot(j).xA(2) = ( (( rib.xA(knot(j).nrib(1),2)+rib.xA(knot(j).nrib(end),2))/2 )  - (pilot.x(2)+pilot.d/2) ) * knot(j).r + (pilot.x(2)+pilot.d/2)  ;
    knot(j).xA(3) = ( (( rib.xA(knot(j).nrib(1),3)+rib.xA(knot(j).nrib(end),3))/2 )  - (pilot.x(3)+pilot.h) ) * knot(j).r + (pilot.x(3)+pilot.h) ;

    knot(j).xB(1) = ( (( rib.xB(knot(j).nrib(1),1)+rib.xB(knot(j).nrib(end),1))/2 )  - pilot.x(1) )*knot(j).r + pilot.x(1) ;
    knot(j).xB(2) = ( (( rib.xB(knot(j).nrib(1),2)+rib.xB(knot(j).nrib(end),2))/2 )  - (pilot.x(2)+pilot.d/2) ) * knot(j).r + (pilot.x(2)+pilot.d/2)  ;
    knot(j).xB(3) = ( (( rib.xB(knot(j).nrib(1),3)+rib.xB(knot(j).nrib(end),3))/2 )  - (pilot.x(3)+pilot.h) ) * knot(j).r + (pilot.x(3)+pilot.h) ;
  end





  disp('Plotting 3D view');
% PLOT INPUT GEOMETRY
  figure(1)
    hold on
    grid on
    axis equal
    view( -25, 15 );
  % Right wing
    plot3(rib.LE(:,1),rib.LE(:,2),rib.LE(:,3) ,'-r');
    plot3(rib.TE(:,1),rib.TE(:,2),rib.TE(:,3) ,'-r');
    plot3(rib.xA(:,1),rib.xA(:,2),rib.xA(:,3) ,'ok');
    plot3(rib.xB(:,1),rib.xB(:,2),rib.xB(:,3) ,'ok');
    plot3(rib.x(:,1),rib.x(:,2),rib.x(:,3) ,'-*k');
    plot3(box.x(:,1),box.x(:,2),box.x(:,3) ,'*k');
    plot3(box.xaero(:,1),box.xaero(:,2),box.xaero(:,3) ,'*g');
    plot3(pAC*rib.chord(:,1)+rib.LE(:,1),rib.x(:,2),rib.x(:,3) ,'*b');

  % RIBS lines
    for i = 1 : N.ribs
      text(rib.LE(i,1),rib.LE(i,2),rib.LE(i,3),num2str(i), 'fontsize', 16)
      plot3([rib.LE(i,1), rib.TE(i,1)], [rib.LE(i,2), rib.TE(i,2)], [rib.LE(i,3), rib.TE(i,3)],'-r');
    end

  % Knots
      for i = 1 : length(knot)
          plot3(knot(i).xA(1), knot(i).xA(2), knot(i).xA(3),'ob');
          plot3(knot(i).xB(1), knot(i).xB(2), knot(i).xB(3),'ob');
      end

  % Rope TOP Lines
  for i = 1 :  length(knot)
    for j = 1 : length(knot(i).nrib)
      plop.line_A = plot3( [rib.xA(knot(i).nrib(j),1), knot(i).xA(1)], [rib.xA(knot(i).nrib(j),2), knot(i).xA(2)], [rib.xA(knot(i).nrib(j),3), knot(i).xA(3)] ,'--b');
      plop.line_B = plot3( [rib.xB(knot(i).nrib(j),1), knot(i).xB(1)], [rib.xB(knot(i).nrib(j),2), knot(i).xB(2)], [rib.xB(knot(i).nrib(j),3), knot(i).xB(3)] ,'--b');
    end
  end

  % Rope LOW Lines
  for i = 1 : length(knot)/2
      plop.line_A1L = plot3( [pilot.x(1), knot(i).xA(1)], [pilot.x(2)-pilot.d/2, knot(i).xA(2)], [pilot.x(3)+pilot.h, knot(i).xA(3)] ,'--k');
      plop.line_B1L = plot3( [pilot.x(1), knot(i).xB(1)], [pilot.x(2)-pilot.d/2, knot(i).xB(2)], [pilot.x(3)+pilot.h, knot(i).xB(3)] ,'--k');
  end
  for i = length(knot)/2 + 1 : length(knot)
      plop.line_A1R = plot3( [pilot.x(1), knot(i).xA(1)], [pilot.x(2)+pilot.d/2, knot(i).xA(2)], [pilot.x(3)+pilot.h, knot(i).xA(3)] ,'--k');
      plop.line_B1R = plot3( [pilot.x(1), knot(i).xB(1)], [pilot.x(2)+pilot.d/2, knot(i).xB(2)], [pilot.x(3)+pilot.h, knot(i).xB(3)] ,'--k');
  end




  % Pilot and Carabiners
    plop.pilot = plot3(pilot.x(1),pilot.x(2),pilot.x(3),'^k');
    plop.l_carab = plot3(pilot.x(1),pilot.x(2)-pilot.d/2,pilot.x(3)+pilot.h,'sr');
    plop.r_carab = plot3(pilot.x(1),pilot.x(2)+pilot.d/2,pilot.x(3)+pilot.h,'sg');

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

  figure(3)
    hold on
    grid on
    axis equal

  % Mid wing line
    plot(rib.x(:,2), rib.x(:,3), '*-r');

    % Rope TOP Lines
    for i = 1 :  length(knot)
      for j = 1 : length(knot(i).nrib)
          plot( [rib.xA(knot(i).nrib(j),2), knot(i).xA(2)], [rib.xA(knot(i).nrib(j),3), knot(i).xA(3)] ,'-ob');
          plot( [rib.xB(knot(i).nrib(j),2), knot(i).xB(2)], [rib.xB(knot(i).nrib(j),3), knot(i).xB(3)] ,'-ob');
      end
    end

    % Rope LOW Lines
    for i = 1 : length(knot)/2
       plot( [pilot.x(2)-pilot.d/2, knot(i).xA(2)], [pilot.x(3)+pilot.h, knot(i).xA(3)] ,'-ok');
       plot( [pilot.x(2)-pilot.d/2, knot(i).xB(2)], [pilot.x(3)+pilot.h, knot(i).xB(3)] ,'-ok');
    end
    for i = length(knot)/2 + 1 : length(knot)
        plot( [pilot.x(2)+pilot.d/2, knot(i).xA(2)], [pilot.x(3)+pilot.h, knot(i).xA(3)] ,'-ok');
        plot( [pilot.x(2)+pilot.d/2, knot(i).xB(2)], [pilot.x(3)+pilot.h, knot(i).xB(3)] ,'-ok');
    end
