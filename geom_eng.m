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
% CANOPY SHAPE GENERATION
   x_param =  linspace(pi,0,N.ribs);
   xx_r = vault.xm * cos(x_param) ;
   xx_c = (xx_r(2:end)+xx_r(1:end-1))/2 ;
   rib.x(1:2:2*N.ribs-1,2) = xx_r ;
   rib.x(2:2:2*N.ribs-2,2) = xx_c ;
   rib.eps1(:,2) = xx_c - (xx_c - xx_r(1:end-1))/sqrt(3);
   rib.eps2(:,2) = xx_c + (xx_r(2:end) - xx_c)/sqrt(3);
 % rib.x(:,2) = xx(2:2:2*N.ribs)'' ;
 % rib.x(1:end-1,2) = rib.x(1:end-1,2) + dx * (rib.x(1:end-1,2)/vault.xm).^10 ;
  rib.LE(:,2) = rib.x(:,2) ;
  rib.TE(:,2) = rib.x(:,2) ;

  [ rib.x(:,3), rib.th ] = ellipse(rib.x(:,2), vault) ;
  [ rib.eps1(:,3), rib.th_eps1 ] = ellipse(rib.eps1(:,2), vault) ;
  [ rib.eps2(:,3), rib.th_eps2 ] = ellipse(rib.eps2(:,2), vault) ;
  rib.x(:,3) = rib.x(:,3) - vault.b ;

  rib.LE(:,1) = ellipse(rib.LE(:,2), le) ;
  rib.LE(:,1) = -rib.LE(:,1) + le.b ;
  rib.TE(:,1) = ellipse(rib.TE(:,2), te) ;
  rib.TE(:,1) = rib.TE(:,1) + le.b ;


  rib.chord = norm(rib.LE-rib.TE, 'rows');
  rib.x(:,1) = pCG .* rib.chord + rib.LE(:,1) ;
  rib.xA(:,1) = pA .* rib.chord + rib.LE(:,1) ;
  rib.xB(:,1) = pB .* rib.chord + rib.LE(:,1) ;

  rib.xA(:,2) = rib.x(:,2);
  rib.xA(:,3) = rib.x(:,3);
  rib.xB(:,2) = rib.x(:,2);
  rib.xB(:,3) = rib.x(:,3);
  rib.LE(:,3) = rib.x(:,3);
  rib.TE(:,3) = rib.x(:,3);

  %% TWIST law (TODO)
  rib.twist = twist(rib.x(:,2), rib.tw0, rib.tw1) ;

  disp('Plotting 3D view');
% PLOT INPUT GEOMETRY
  figure(1)
    hold on
    grid on
    axis equal
    view( -25, 15 );
  % Right wing
    plop.le = plot3(rib.LE(:,1),rib.LE(:,2),rib.LE(:,3) ,'-r');
    plot3(rib.TE(:,1),rib.TE(:,2),rib.TE(:,3) ,'-r');
    plot3(rib.xA(1:2:end,1),rib.xA(1:2:end,2),rib.xA(1:2:end,3) ,'ok');
    plot3(rib.xB(1:2:end,1),rib.xB(1:2:end,2),rib.xB(1:2:end,3) ,'ok');
    plop.x = plot3(rib.x(:,1),rib.x(:,2),rib.x(:,3) ,'-*k');
    plop.ac = plot3(pAC*rib.chord(:,1)+rib.LE(:,1),rib.x(:,2),rib.x(:,3) ,'--b');

  % RIBS lines
    for i = 1 :2: 2*N.ribs-1
      plot3([rib.LE(i,1), rib.TE(i,1)], [rib.LE(i,2), rib.TE(i,2)], [rib.LE(i,3), rib.TE(i,3)],'-r');
    end

  % Wingtip Lines
  for i = 1 : 2 : 2*N.ribs-1
     if i <= N.ribs
        lr = -1 ;
     else
        lr = 1 ;
     end
    plop.line = plot3([rib.xA(i,1), pilot.x(1)],[rib.xA(i,2), pilot.x(2)+lr*pilot.d/2],[rib.xA(i,3), pilot.x(3)+pilot.h] ,'--k');
    plot3([rib.xB(i,1), pilot.x(1)],[rib.xB(i,2), pilot.x(2)+lr*pilot.d/2],[rib.xB(i,3), pilot.x(3)+pilot.h] ,'--k');
  end

  % Pilot and Carabiners
    plop.pilot = plot3(pilot.x(1),pilot.x(2),pilot.x(3),'^k');
    plop.l_carab = plot3(pilot.x(1),pilot.x(2)-pilot.d/2,pilot.x(3)+pilot.h,'sr');
    plop.r_carab = plot3(pilot.x(1),pilot.x(2)+pilot.d/2,pilot.x(3)+pilot.h,'sg');

legend([ plop.x, plop.ac, plop.line, plop.le, plop.pilot, plop.l_carab, plop.r_carab ], ...
'Ribs CG', 'Ribs AC', 'Lines', 'Wing surface', 'Pilot CG', 'Left Carabiner', 'Right Carabinier');



figure(2)
hold on
grid on
axis equal
lv = 0.5;
 plot(rib.x(:,2) - lv*sin(rib.th), rib.x(:,3) + lv*cos(rib.th), 'or' )

  plot(rib.x(:,2), rib.x(:,3),'o-r')
