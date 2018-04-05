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
          ref = wing.x(i,2);
            fun = @(x)esse(x,vault,ref) ;
            rib.x(i,2) = fsolve(fun, 0.) ;
        end
        [ rib.x(:,3), rib.th ] =  ellipse(rib.x(:,2), vault);
          rib.x(:,3) = rib.x(:,3) - vault.b ;
        % RIBS chord position (X coord)
            rib.x(:,1) = wing.x(:,1) ;

        for i = 1 : N.beam
          ref = wing.I(i,2) ;
            fun = @(x)esse(x,vault,ref) ;
            rib.I(i,2) = fsolve(fun, 0.) ;
        end
        [ rib.I(:,3), rib.I_th ] =  ellipse(rib.I(:,2), vault);
          rib.I(:,3) = rib.I(:,3) - vault.b ;
        % RIBS chord position (X coord)
            rib.I(:,1) = wing.I(:,1) ;

        for i = 1 : N.beam
          ref = wing.II(i,2) ;
            fun = @(x)esse(x,vault,ref) ;
            rib.II(i,2) = fsolve(fun, 0.) ;
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

        rib.aer(:,1) = rib.LE(:,1) + 0.5 * rib.chord ;
        rib.aer(:,2) = rib.x(:,2) ;
        rib.aer(:,3) = rib.x(:,3) ;

%---------------------------------------------------------

%---------------------------------------------------------

%% LINES anchor points
  % LINE A
    rib.xA(:,1) = pA' .* rib.chord + rib.LE(:,1) ;
    rib.xA(:,2) = rib.x(:,2) ;
    rib.xA(:,3) = rib.x(:,3) ;
  % LINE B
    rib.xB(:,1) = pB' .* rib.chord + rib.LE(:,1) ;
    rib.xB(:,2) = rib.x(:,2) ;
    rib.xB(:,3) = rib.x(:,3) ;

    % LINE A
      wing.xA(:,1) = pA' .* wing.chord + wing.LE(:,1) ;
      wing.xA(:,2) = wing.x(:,2) ;
      wing.xA(:,3) = wing.x(:,3) ;
    % LINE B
      wing.xB(:,1) = pB' .* wing.chord + wing.LE(:,1) ;
      wing.xB(:,2) = wing.x(:,2) ;
      wing.xB(:,3) = wing.x(:,3) ;

%% AERO points
    rib.xaero = 0.5 * (rib.LE + rib.TE);
  % CELL SPAN
    box.span = norm(rib.x(2:end,:) - rib.x(1:end-1,:), 'rows') ;


  %% TWIST law (TODO)
  rib.twist = twist(wing.x(:,2), rib.tw0, rib.tw1) ;


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


% ==========================================================================================
% ==========================================================================================
