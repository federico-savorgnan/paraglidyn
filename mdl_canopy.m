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

disp('Writing main file');
%% Canopy reference
fid = fopen([model_name, '/canopy.mbd'],'w') ;
write_copy(fid);
 % RIBS Center of Gravity

fprintf(fid, 'begin: data;    \n') ;
fprintf(fid, '	integrator: initial value;    \n') ;
fprintf(fid, 'end: data;    \n') ;

fprintf(fid, 'include: "paraglide.set" ;    \n') ;

fprintf(fid, 'begin: initial value;    \n') ;
fprintf(fid, 'initial time: 0.;        \n') ;
fprintf(fid, 'final time: 50. ;         \n') ;
fprintf(fid, 'time step: 0.01 ;        \n') ;

fprintf(fid, 'method: ms, .4;                   \n') ;
fprintf(fid, 'max iterations: 1000, at most;    \n') ;
fprintf(fid, 'tolerance: 1.e-6;                 \n') ;
% fprintf(fid, ' # linear solver: naive, colamd;    \n') ;
% fprintf(fid, ' # nonlinear solver: newton raphson, modified, 4;    \n') ;
fprintf(fid, 'derivatives tolerance:  1.e-5;      \n') ;
fprintf(fid, 'derivatives max iterations:  100;   \n') ;
fprintf(fid, ' derivatives coefficient:  1.e-12;  \n') ;
% fprintf(fid, 'derivatives coefficient:  auto, max iterations, 10;    \n') ;
% fprintf(fid, ' # output: iterations;    \n') ;
% fprintf(fid, ' # output: residual;    \n') ;


% fprintf(fid, ' #	nonlinear solver: newton raphson, modified, 4;    \n') ;
% fprintf(fid, ' # linear solver: umfpack, cc, block size, 2;    \n') ;
% fprintf(fid, 'eigenanalysis: 0.,    \n') ;
% fprintf(fid, '	use lapack,    \n') ;
% fprintf(fid, '	output eigenvectors,    \n') ;
% fprintf(fid, '	output geometry ;    \n') ;
fprintf(fid, 'end: initial value ;    \n') ;

fprintf(fid, 'begin: control data ;                  \n') ;
fprintf(fid, ' # skip initial joint assembly ;       \n') ;
fprintf(fid, ' default output : reference frames ;   \n') ;
fprintf(fid, ' output results : netcdf ;             \n') ;
fprintf(fid, ' default aerodynamic output : all ;    \n') ;
fprintf(fid, ' default beam output : all ;           \n');
fprintf(fid, ' #  default orientation: orientation matrix ;    \n') ;

fprintf(fid, '	 structural nodes:                  \n') ;
fprintf(fid, '      + N_rib 	# canopy ribs         \n') ;
fprintf(fid, '      + 2*N_knot 	# lines knots       \n') ;
fprintf(fid, '      + 1        # pilot              \n') ;
% fprintf(fid, '      + 3*N_rib    # dummy LE / TE    \n') ;
% fprintf(fid, '      + N_rib-1    # dummy beam   \n') ;
fprintf(fid, '   ; \n') ;
fprintf(fid, '  rigid bodies:                       \n') ;
fprintf(fid, '      +  N_rib    # wing              \n') ;
fprintf(fid, '      +  2*N_knot    # knots           \n') ;
fprintf(fid, '      + 1      			# pilota          \n') ;
fprintf(fid, '   ; \n') ;
fprintf(fid, '  joints:                             \n') ;
fprintf(fid, '      + 4*N_rope   # LINE_A + LINE_B    \n') ;
fprintf(fid, '   ; \n') ;

if BEAM_TYPE == 2
  fprintf(fid, '  beams:                              \n') ;
  fprintf(fid, '      + (N_rib-1)                    \n') ;
  fprintf(fid, '   ; \n') ;
  fprintf(fid, '  aerodynamic elements:               \n') ;
  fprintf(fid, '      + (N_rib-1)      # Aero Body  \n') ;
  fprintf(fid, '   ; \n') ;
elseif BEAM_TYPE == 3
  fprintf(fid, '  beams:                              \n') ;
  fprintf(fid, '      + (N_rib-1)/2                  \n') ;
  fprintf(fid, '   ; \n') ;
  fprintf(fid, '  aerodynamic elements:               \n') ;
  fprintf(fid, '      + (N_rib-1)/2      # Aero Body  \n') ;
  fprintf(fid, '   ; \n') ;
end

fprintf(fid, '  forces:                             \n') ;
fprintf(fid, '      + 1           # Pilot drag      \n') ;
fprintf(fid, '   ; \n') ;
fprintf(fid, '  air properties;    \n') ;
fprintf(fid, '  gravity;    \n') ;
fprintf(fid, 'end: control data;    \n') ;
fprintf(fid, '# REFERENCE SYSTEMS    \n') ;
fprintf(fid, 'reference: CANOPY,    \n') ;
fprintf(fid, '  reference, global, null,    \n') ;
fprintf(fid, '  reference, global,    \n') ;
fprintf(fid, '    1, -cos(pre_pitch), 0., -sin(pre_pitch),    \n') ;
fprintf(fid, '    2,  0., -1., 0.,   \n') ;
fprintf(fid, '  reference, global, V_inf, 0., -V_inf/Eff, \n') ;
fprintf(fid, '  reference, global, null;    \n') ;
fprintf(fid, '## Infinity thumbling (not sure if it works)    \n') ;
fprintf(fid, '#reference: CANOPY,    \n') ;
fprintf(fid, '#        reference, global, null,    \n') ;
fprintf(fid, '#        reference, global, 2, 0., 1., 0., 1, cos(pre_pitch), 0., -sin(pre_pitch),    \n') ;
fprintf(fid, '#        reference, global, -V_inf, 0., -V_inf/Eff,    \n') ;
fprintf(fid, '#        reference, global, 0., 2.5*V_inf/z_pilot, 0.;    \n') ;
fprintf(fid, '  include: "pilot.ref";    \n') ;
fprintf(fid, '  include: "canopy.ref";    \n') ;
fprintf(fid, 'begin: nodes;    \n') ;
fprintf(fid, '  include: "pilot.nod";    \n') ;
fprintf(fid, '  include: "canopy.nod";    \n') ;
fprintf(fid, 'end: nodes;    \n') ;
fprintf(fid, 'begin: elements;    \n') ;
fprintf(fid, '  gravity: uniform, 0., 0., -1., const, 9.81;    \n') ;
fprintf(fid, '  air properties: std, SI, reference altitude, 0.,    \n') ;
fprintf(fid, '    1., 0., 0.,    \n') ;
fprintf(fid, '    const, 0. ;    \n') ;
fprintf(fid, '  include: "pilot.elm";    \n') ;
fprintf(fid, '  include: "canopy.elm";    \n') ;
fprintf(fid, 'end: elements;    \n') ;

fclose(fid);
