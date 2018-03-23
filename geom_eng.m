% ########################################################################
%
% PARAGLIDYN - Paraglider pre-processor for MBDyn
%
% Copyright (C) 2016 - 2018
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

%% INPLANE CONSTRUCTION
  % Wingspan discretization (Y coord)
    pi_fact = pi/4 ;
    y_param =  cos(linspace( pi-pi_fact, pi_fact, N.ribs )) ./ cos(pi_fact) ;
    wing.x(:,2) =  0.5 * wing.span * y_param ;
    ff = 0;
    for i = 1 : 2 : N.ribs-2
      ff = ff+1 ;
      wing.I(ff,2) = ( wing.x(i+1,2) - wing.x(i,2))*(1-(1/3)^0.5) + wing.x(i,2);
      wing.II(ff,2) = ( wing.x(i+2,2) - wing.x(i+1,2))*((1/3)^0.5) + wing.x(i+1,2);
    end

    %% LEADING and TRAILING EDGE

    wing.LE(:,3) = zeros(N.ribs,1) ;
    wing.TE(:,3) = zeros(N.ribs,1) ;
    wing.x(:,3) = zeros(N.ribs,1) ;
    wing.I(:,3) = zeros(N.beam,1) ;
    wing.II(:,3) = zeros(N.beam,1) ;
    wing.I_LE(:,3) = zeros(N.beam,1) ;
    wing.I_TE(:,3) = zeros(N.beam,1) ;
    wing.II_LE(:,3) = zeros(N.beam,1) ;
    wing.II_TE(:,3) = zeros(N.beam,1) ;
      % Leading and Trailing edge construction (Y coord)
        wing.LE(:,2) = wing.x(:,2) ;
        wing.TE(:,2) = wing.x(:,2) ;
        wing.I_LE(:,2) =   wing.I(:,2) ;
        wing.I_TE(:,2) =   wing.I(:,2)  ;
        wing.II_LE(:,2) =  wing.II(:,2)  ;
        wing.II_TE(:,2) =  wing.II(:,2)  ;
      % Leading and Trailing edge construction (X coord)

        [ wing.LE(:,1), wing.th_LE ] =  ellipse(wing.LE(:,2), le) ;
        [ wing.TE(:,1), wing.th_TE ] =  ellipse(wing.TE(:,2), te) ;
        [ wing.I_LE(:,1), wing.I_th_LE ] =  ellipse(wing.I_LE(:,2), le) ;
        [ wing.I_TE(:,1), wing.I_th_TE ] =  ellipse(wing.I_TE(:,2), te) ;
        [ wing.II_LE(:,1), wing.II_th_LE ] =  ellipse(wing.II_LE(:,2), le) ;
        [ wing.II_TE(:,1), wing.II_th_TE ] =  ellipse(wing.II_TE(:,2), te) ;

        wing.LE(:,1) = - wing.LE(:,1) + le.b ;
        wing.TE(:,1) =   wing.TE(:,1) + le.b ;
        wing.th_TE = - wing.th_TE ;

        wing.I_LE(:,1) = - wing.I_LE(:,1) + le.b ;
        wing.I_TE(:,1) =   wing.I_TE(:,1) + le.b ;
        wing.I_th_TE = - wing.I_th_TE ;

        wing.II_LE(:,1) = - wing.II_LE(:,1) + le.b ;
        wing.II_TE(:,1) =   wing.II_TE(:,1) + le.b ;
        wing.II_th_TE = - wing.II_th_TE ;

        wing.chord = norm(wing.LE(:,1:2)-wing.TE(:,1:2), 'rows') ;
        wing.x(:,1) = pCG .* wing.chord + wing.LE(:,1) ;
        wing.th = -pCG .* (wing.th_LE - wing.th_TE) + wing.th_LE ;

        wing.I_chord = norm(wing.I_LE(:,1:2)-wing.I_TE(:,1:2), 'rows') ;
        wing.I(:,1) = pCG .* wing.I_chord + wing.I_LE(:,1) ;
        wing.I_th = -pCG .* (wing.I_th_LE - wing.I_th_TE) + wing.I_th_LE ;

        wing.II_chord = norm(wing.II_LE(:,1:2)-wing.II_TE(:,1:2), 'rows') ;
        wing.II(:,1) = pCG .* wing.II_chord + wing.II_LE(:,1) ;
        wing.II_th = -pCG .* (wing.II_th_LE - wing.II_th_TE) + wing.II_th_LE ;

        rib.chord = wing.chord ;


        for i = 1 : N.ribs
          ref = wing.x(i,2) ;
            fun = @(x)esse(x,vault,ref) ;
            rib.x(i,2) = fsolve(fun, ref) ;
        end
        [ rib.x(:,3), rib.th ] =  ellipse(rib.x(:,2), vault);
          rib.x(:,3) = rib.x(:,3) - vault.b ;
        % RIBS chord position (X coord)
            rib.x(:,1) = wing.x(:,1) ;

        for i = 1 : N.beam
          ref = wing.I(i,2) ;
            fun = @(x)esse(x,vault,ref) ;
            rib.I(i,2) = fsolve(fun, ref) ;
        end
        [ rib.I(:,3), rib.I_th ] =  ellipse(rib.I(:,2), vault);
          rib.I(:,3) = rib.I(:,3) - vault.b ;
        % RIBS chord position (X coord)
            rib.I(:,1) = wing.I(:,1) ;

        for i = 1 : N.beam
          ref = wing.II(i,2) ;
            fun = @(x)esse(x,vault,ref) ;
            rib.II(i,2) = fsolve(fun, ref) ;
        end
        [ rib.II(:,3), rib.II_th ] =  ellipse(rib.II(:,2), vault);
          rib.II(:,3) = rib.II(:,3) - vault.b ;
        % RIBS chord position (X coord)
          rib.II(:,1) = wing.II(:,1) ;


        rib.LE(:,1) = wing.LE(:,1) ;
        rib.LE(:,2) = rib.x(:,2) ;
        rib.LE(:,3) = rib.x(:,3) ;

        rib.TE(:,1) = wing.TE(:,1) ;
        rib.TE(:,2) = rib.x(:,2) ;
        rib.TE(:,3) = rib.x(:,3) ;


%---------------------------------------------------------



%--------------------------------------------------------------




%% LINES anchor points
  % LINE A
    rib.xA(:,1) = pA' .* rib.chord + rib.LE(:,1) ;
    rib.xA(:,2) = rib.x(:,2) ;
    rib.xA(:,3) = rib.x(:,3) ;
  % LINE B
    rib.xB(:,1) = pB' .* rib.chord + rib.LE(:,1) ;
    rib.xB(:,2) = rib.x(:,2) ;
    rib.xB(:,3) = rib.x(:,3) ;

%% AERO points
    rib.xaero = 0.5 * (rib.LE + rib.TE);
  % CELL SPAN
    box.span = norm(rib.x(2:end,:) - rib.x(1:end-1,:), 'rows') ;


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

    figure('Position',[200 200 1500 600])
    hold on
    grid on
    axis equal
    plot(wing.x(:,2), wing.x(:,1))
    plot(wing.LE(:,2), wing.LE(:,1))
    plot(wing.TE(:,2), wing.TE(:,1))
    legend('Beam', 'LE', 'TE')

    figure('Position',[200 200 1500 600])
    hold on
    grid on
    axis equal
    plot(wing.x(:,2), zeros(1,N.ribs),'ko')
    plot(rib.x(:,2), rib.x(:,3), 'ro')

    figure('Position',[200 200 1500 600])
    hold on
    grid on
    plot(wing.th)
    plot(wing.th_LE)
    plot(wing.th_TE)
    legend('Beam', 'LE', 'TE')

    figure(4)
    hold on
    grid on
    axis equal
    plot3(rib.x(:,1), rib.x(:,2), rib.x(:,3), 'o-k')
    plot3(wing.LE(:,1), wing.LE(:,2), wing.LE(:,3),'r')
    plot3(wing.TE(:,1), wing.TE(:,2), wing.TE(:,3),'r')
    plot3(rib.LE(:,1), rib.LE(:,2), rib.LE(:,3),'r')
    plot3(rib.TE(:,1), rib.TE(:,2), rib.TE(:,3),'r')
    plot3(rib.I(:,1), rib.I(:,2), rib.I(:,3),'r*')
    plot3(rib.II(:,1), rib.II(:,2), rib.II(:,3),'b*')



for i = 1 : N.ribs
  lp(i) = (  - pilot.x(3) + rib.x(i,3) + rib.x(i,2)/tan(rib.th(i)) ) .* sin(rib.th(i));
end

figure('Position',[200 200 1500 600])
subplot(1,2,1)
hold on
grid on
axis equal
plot(rib.x(:,2), rib.x(:,3), 'g','LineWidth',2) ;
plot(0,pilot.x(3), 'or') ;

subplot(1,2,2)
hold on
grid on
plot(rib.x(:,2), lp)
