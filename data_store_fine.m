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

%% Canopy shape data
%% CELL NUMBER
N.beam = 13 ;
N.ribs = 1 + 2*N.beam ;         % Wing number of Ribs
N.box = N.ribs - 1 ;   % Wing cell
N.cell = N.box ;   % Wing cell
% % Canopy Vault shape
vault.a = 4.2 ;      % m - semiaxis ellipse
vault.b = 2.3;     % m -semiaxis ellipse
vault.x1 = 3. ;     % m - correction point
vault.c0 = .5 ;     % m - correction strenght
vault.type = 0 ;    %  correction type (exponent)

wing.span = 10.2 ;
% % Canopy Leading Edge shape
le.a = 5.4 ;       % m - semiaxis ellipse
le.b = 1.5 ;        % m - semiaxis ellipse
le.x1 = 3. ;       % m - Canopy heigh
le.c0 = 0. ;      % m - correction strenght
le.type = 0 ;      %  correction type (exponent)

% % Canopy Trailing Edge shape
te.a = 5.4 ;        % m - semiaxis ellipse
te.b = 1.5 ;         % m - semiaxis ellipse
te.x1 = 3. ;       % m - Canopy heigh
te.c0 = 0. ;      % m - correction strenght
te.type = 0 ;      %  correction type (exponent)

% RIBS twist
rib.tw0 = 6. * pi/180 ;  % Wing center
rib.tw1 = 6. * pi/180 ;  %  Tip wing

% Special points chord position
pCG = 0.3 ;   % Adimensional chord [0-1]
pAC = 0.3 ;   % Adimensional chord [0-1]
pA  = linspace(0.2,0.2,N.ribs/2+1) ;   % Adimensional chord [0-1]
pA = [pA, fliplr(pA(1:end-1))];
pB  = linspace(.9,0.8,N.ribs/2+1) ;  % Adimensional chord [0-1]
pB = [pB, fliplr(pB(1:end-1))];

% --------------------------------------------------------------
% Pilot position
pilot.x(1) = 0.2 * (le.b + te.b) ;    % m - Pilot X position
pilot.x(2) = 0. ;                    % m - Pilot Y position
pilot.x(3) = -5.75 ;                  % m - Pilot Z position
pilot.d = 0.4 ;     % m - Carabiner horizz distance
pilot.h = 0. ;     % m - Carabiner - pilot_CG vert distance
% Pilot movement
pilot.offset = 0.01 ;
pilot.t0 = 1. ;
pilot.Dt = 0. ;
pilot.tau = 7. ;
pilot.Ncyc = 30 ;
pilot.type = 'one'  ;

% Pilot Drag
pilot.S_aer = 0.8 ;    % Pilot Frontal aerodynamic surface
pilot.Cd = .5 ;        % Pilot Drag coeff.
pilot.rho = 1.225 ;    % Air density for pilot drag calc

%% Pilot lumped mass
pilot.mass = 90. ;   % Kg - Pilot + Harness weight
pilot.Ixx = 1. ;      % 3.
pilot.Iyy = 1. ;      % 8.
pilot.Izz = 1. ;      % 9.

% --------------------------------------------------------------
%% Canopy mass/stiffness data
M = 5 ;                %  Kg - Canopy weight
rib.mass = M / (N.ribs) ;
rib.Ixx = .2 ;        % .2
rib.Iyy = .05 ;       % .05
rib.Izz = .2 ;        % .2
stiff_A = 1.e7 ;        % N/m - lines stiffness
stiff_B = stiff_A ;        % N/m - lines stiffness
damp_A = 0.00005 * stiff_A ;        % Ns/m - lines damp
damp_B = damp_A ;        % Ns/m - lines damp

BEAM_TYPE = 3 ;
stiff_fact = 1. ;
EA = 1.e4 ;
GAy = 50. ;
GAz = 100. ;
GJ = 50. ;
EJy = 100. ;
EJz = 500. ;
beam_stiff = stiff_fact * [ EA, GAy, GAz, GJ, EJy, EJz] ;
damp_fact = 0.2 ;



in = 1 ;
knot(in).r = 0.6 ;
knot(in).nrib = [ 1:2] ;
in = in+1 ;
knot(in).r = 0.6 ;
knot(in).nrib = [ 3:6] ;
in = in+1 ;
knot(in).r = 0.6 ;
knot(in).nrib = [ 7:10] ;
in = in+1 ;
knot(in).r = 0.6;
knot(in).nrib = [ 11:14] ;

% load('connection_table.mat')


N.knot = length(knot) ;
N.rope = 0 ;
for i = 1 : N.knot
  N.rope = N.rope + length(knot(i).nrib) + 1 ;
  knot(N.knot+i).r = knot(N.knot+1-i).r ;
  knot(N.knot+i).nrib = fliplr(N.ribs - knot(N.knot+1-i).nrib + 1) ;
end


N.aer_int_pts = 1 ;    % N Aero integration points

% --------------------------------------------------------------
%% Simulation initial condition
ic.V_inf = 13.;                % m/s - Canopy Velocity m/s
ic.Eff = 5.8;                     % Efficiency Vx/Vz
ic.pre_pitch = -5. * pi/180 ;   % Positive nose-up

% ================================================================
%% SAVE INPUT DATA to FILE
save([model_name, '/input_data.mat'], 'vault', 'le', 'te', 'pilot', 'N', 'ic', 'rib', 'knot');
