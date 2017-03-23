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
N.cell = 33 ;          % Wing cell
N.ribs = N.cell + 1 ; % Wing number of Ribs

% % Canopy Vault shape
vault.a = 6.0 ;    % m - semiaxis ellipse
vault.b = 3 ;    % m -semiaxis ellipse
vault.xm = 5.39;      % m - semi-span
vault.x1 = 2. ;    % m - correction point
vault.c0 = 1. ;   % m - correction strenght
vault.type = 2 ;  %  correction type (exponent)

% % Canopy Leading Edge shape
le.a = 7.0 ;      % m - semiaxis ellipse
le.b = 2. ;       % m - semiaxis ellipse
le.xm = 5.39 ;     % m - semi-span
le.x1 = 2. ;       % m - Canopy heigh
le.c0 = 0.5 ;      % m - correction strenght
le.type = 0 ;      %  correction type (exponent)

% % Canopy Trailing Edge shape
te.a = 7. ;      % m - semiaxis ellipse
te.b = 2 ;        % m - semiaxis ellipse
te.xm = le.xm ;    % m - semi-span
te.x1 = 2. ;     % m - Canopy heigh
te.c0 = 0.5 ;       % m - correction strenght
te.type = 0 ; %  correction type (exponent)

% RIBS twist
rib.tw0 = 2 * pi/180 ;
rib.tw1 = 4 * pi/180 ;
% Pilot position
pilot.x(1) = 0.2 * (le.b + te.b) ;   % m - Pilot X position
pilot.x(2) = 0. ;                     % m - Pilot Y position
pilot.x(3) = -8. ;                    % m - Pilot Z position
pilot.d = 0.45 ;    % m - Carabiner horizz distance
pilot.h = 0.4 ;     % m - Carabiner - pilot_CG vert distance
% Pilot movement
pilot.offset = 0.2 ;
pilot.t0 = 1.;
pilot.tau = 8.;

% Special points chord position
pCG = 0.2 ;  % Adimensional 0-1
pAC = 0.25 ;  % Adimensional 0-1
pA  = 0.1 ;  % Adimensional 0-1
pB  = 0.7 ;  % Adimensional 0-1

% Pilot Drag
pilot.S_aer = 0.5; % Pilot Frontal aerodynamic surface
pilot.Cd = 1. ;    % Pilot Drag coeff.
pilot.rho = 1.1 ;  % Air density for pilot drag calc

%% Pilot lumped mass
pilot.mass = 100. ; % Kg - Pilot + Harness weight
pilot.Ixx = 3. ;  % 3.
pilot.Iyy = 8. ;  % 8.
pilot.Izz = 9. ;  % 9.

%% Canopy mass/stiffness data
% M = 5 ;          % Kg - Canopy weight
rib.Ixx = .05 ;  % .05
rib.Iyy = .2 ;   % .2
rib.Izz = .2 ;   % .2
stiff_A = 1.e8;  % N/m lines stiffness
stiff_B = 1.e8;  % N/m lines stiffness
damp_A = 100;    % N/m/s lines damp
damp_B = 100;    % N/m/s lines damp

%% Canopy beam section properties
EA  = 1.e3 ;
GAy = 1.e3 ;
GAz = 1.e3 ;
GJ  = 1.e3 ;
EJy = 1.e7 ;
EJz = 1.e7 ;
damp_fact = 0.05 ;
aer_int_pts = 5 ;

%% Simulation initial condition
ic.V_inf = 15 ;
ic.Eff = 8 ;
ic.pre_pitch = -7 * pi/180 ; % Positive nose-up

%% SAVE INPUT DATA to FILE
save([model_name, '/input_data.mat'], 'vault', 'le', 'te', 'pilot', 'N', 'ic');
