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

%% Canopy shape data
%% CELL NUMBER
N.ribs = 12   ;         % Wing number of Ribs
N.cell = N.ribs - 1 ;   % Wing cell

% % Canopy Vault shape
vault.a = 6.6;      % m - semiaxis ellipse
vault.b = 8.5 ;     % m -semiaxis ellipse
vault.xm = 5.9;     % m - semi-span
vault.x1 = 3. ;     % m - correction point
vault.c0 = .5 ;     % m - correction strenght
vault.type = 2 ;    %  correction type (exponent)

% % Canopy Leading Edge shape
le.a = 7.0 ;       % m - semiaxis ellipse
le.b = 2. ;        % m - semiaxis ellipse
le.xm = 5.39 ;     % m - semi-span
le.x1 = 2. ;       % m - Canopy heigh
le.c0 = 0.5 ;      % m - correction strenght
le.type = 0 ;      %  correction type (exponent)

% % Canopy Trailing Edge shape
te.a = 7. ;        % m - semiaxis ellipse
te.b = 2 ;         % m - semiaxis ellipse
te.xm = le.xm ;    % m - semi-span
te.x1 = 2. ;       % m - Canopy heigh
te.c0 = 0.5 ;      % m - correction strenght
te.type = 0 ;      %  correction type (exponent)

% RIBS twist
rib.tw0 = 8. * pi/180 ;  % Wing center
rib.tw1 = 7. * pi/180 ;  %  Tip wing
% Pilot position
pilot.x(1) = 0.1 * (le.b + te.b) ;    % m - Pilot X position
pilot.x(2) = 0. ;                     % m - Pilot Y position
pilot.x(3) = -8. ;                    % m - Pilot Z position
pilot.d = 0.4 ;     % m - Carabiner horizz distance
pilot.h = 0. ;     % m - Carabiner - pilot_CG vert distance
% Pilot movement
pilot.offset = 0.02 ;
pilot.t0 = 5. ;
pilot.Dt = 50. ;
pilot.tau = 10. ;
pilot.Ncyc = 4 ;
pilot.type = 'half'  ;

% Special points chord position
pCG = 0.2 ;   % Adimensional chord [0-1]
pAC = 0.25 ;  % Adimensional chord [0-1]
pA  = [linspace(0,0.15,N.ribs/2), linspace(0.15,0.,N.ribs/2)] ;   % Adimensional chord [0-1]
pB  = 0.65 * ones(1,N.ribs);  % Adimensional chord [0-1]

% Pilot Drag
pilot.S_aer = 0.5 ;    % Pilot Frontal aerodynamic surface
pilot.Cd = 3. ;        % Pilot Drag coeff.
pilot.rho = 1.225 ;    % Air density for pilot drag calc

%% Pilot lumped mass
pilot.mass = 100. ;   % Kg - Pilot + Harness weight
pilot.Ixx = 3. ;      % 3.
pilot.Iyy = 8. ;      % 8.
pilot.Izz = 9. ;      % 9.

%% Canopy mass/stiffness data
M = 3 ;                %  Kg - Canopy weight
rib.mass = M / (N.ribs+N.cell) ;
box.mass = rib.mass ;                                    %%% DA RAFFINARE
rib.Ixx = .005 ;       % .05
rib.Iyy = .02 ;        % .2
rib.Izz = .02 ;        % .2
stiff_A = 1.e7;        % N/m - lines stiffness
stiff_B = 1.e7;        % N/m - lines stiffness
damp_A = 1000.;           % Ns/m - lines damp
damp_B = 1000.;           % Ns/m - lines damp

knot(1).r = 0.5 ;
knot(1).nrib = [ 1:2] ;
knot(2).r = 0.5 ;
knot(2).nrib = [3:4 ] ;
knot(3).r = 0.5 ;
knot(3).nrib = [ 5:6] ;


lkn = length(knot);
N.rope = 0 ;
for i = 1 : lkn
  N.rope = N.rope + length(knot(i).nrib) + 1 ;
  knot(lkn+i).r = knot(lkn+1-i).r ;
  knot(lkn+i).nrib = fliplr(N.ribs - knot(lkn+1-i).nrib + 1) ;
end

%% Canopy beam section properties
joint.Kx =  ones(N.cell,1)*[1.e4, 1.e4, 1.e5] ;
joint.Cx =  ones(N.cell,1)*[0.15, 0.1, 0.2] .* joint.Kx ;
joint.Kth = ones(N.cell,1)*[.1, 5.e3, 2.e3 ] ;
%% tip nodes
joint.Kth(1,:)=[1e7, 1e7, 1e7];
joint.Kth(end,:)=[1e7, 1e7, 1e7];
joint.Cth = ones(N.cell,1)*[0.2, 0.2, 0.1] .* joint.Kth ;

aer_int_pts = 2. ;    % N Aero integration points

%% Simulation initial condition
ic.V_inf = 11.55;                % m/s - Canopy Velocity m/s
ic.Eff = 6.76;                     % Efficiency Vx/Vz
ic.pre_pitch = -13 * pi/180 ;   % Positive nose-up

%% SAVE INPUT DATA to FILE
save([model_name, '/input_data.mat'], 'vault', 'le', 'te', 'pilot', 'N', 'ic', 'rib', 'knot');
