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

%% Print MBDyn input files
PILOT = 1 ;
CARAB = 10 ;
CANOPY = 1e6 ;
EPS1 = 5e6 ;
EPS2 = 6e3 ;
RIBS_CG = 1e3 ;
RIBS_AC = 2e3 ;
RIBS_LE = 3e3 ;
RIBS_TE = 4e3 ;
BEAM = 1e4 ;
AERO = 2e4 ;
LINE_A = 3e4 ;
LINE_B = 4e4 ;

disp('Writing variables');
%% Set Variables
fid = fopen([model_name, '/paraglide.set'],'w') ;
  write_copy(fid);
  fprintf(fid,'set: const integer N_cell = %d ;    \n', N.cell) ;
  fprintf(fid,'set: const integer N_rib = N_cell + 1 ;    \n') ;

  fprintf(fid,'set: const integer CANOPY = %d ;   \n',   CANOPY) ;
  fprintf(fid,'set: const integer PILOT = %d ;   \n',   PILOT) ;
  fprintf(fid,'set: const integer CARAB = %d ;   \n',   CARAB) ;
  fprintf(fid,'set: const integer RIBS_CG = %d ;   \n',   RIBS_CG) ;
  fprintf(fid,'set: const integer RIBS_AC = %d ;   \n',   RIBS_AC) ;
  fprintf(fid,'set: const integer RIBS_LE = %d ;   \n',   RIBS_LE) ;
  fprintf(fid,'set: const integer RIBS_TE = %d ;   \n',   RIBS_TE) ;
  fprintf(fid,'set: const integer EPS1 = %d ;   \n',   EPS1) ;
  fprintf(fid,'set: const integer EPS2 = %d ;   \n',   EPS2) ;
  fprintf(fid,'set: const integer BEAM = %d ;    \n',   BEAM) ;
  fprintf(fid,'set: const integer AERO = %d ;    \n',    AERO) ;
  fprintf(fid,'set: const integer LINE_A = %d ;    \n', LINE_A) ;
  fprintf(fid,'set: const integer LINE_B = %d ;    \n', LINE_B) ;
  fprintf(fid,'set: const real Cd = %6.4f ; \n',      pilot.Cd) ;
  fprintf(fid,'set: const real S_pilot = %6.4f ; \n', pilot.S_aer) ;
  fprintf(fid,'set: const real rho = %6.4f ; \n',     pilot.rho) ;

  fprintf(fid,'set: const real stiff_A = %6.4f ; \n',  stiff_A) ;
  fprintf(fid,'set: const real stiff_B = %6.4f ; \n',  stiff_B) ;
  fprintf(fid,'set: const real damp_A = %6.4f ; \n',   damp_A) ;
  fprintf(fid,'set: const real damp_B = %6.4f ; \n',   damp_B) ;

  fprintf(fid,'set: const real V_inf = %6.4f ; \n',      ic.V_inf) ;
  fprintf(fid,'set: const real Eff = %6.4f ; \n',        ic.Eff) ;
  fprintf(fid,'set: const real pre_pitch = %6.4f ; \n',  ic.pre_pitch) ;

  fprintf(fid,'set: const integer aer_int_pts =  %d; \n', aer_int_pts) ;

  fprintf(fid,'set: const real EA = %6.4f ; \n',  EA) ;
  fprintf(fid,'set: const real GAy = %6.4f ; \n', GAy) ;
  fprintf(fid,'set: const real GAz = %6.4f ; \n', GAz) ;
  fprintf(fid,'set: const real GJ = %6.4f ; \n',  GJ) ;
  fprintf(fid,'set: const real EJy = %6.4f ; \n', EJy) ;
  fprintf(fid,'set: const real EJz = %6.4f ; \n', EJz) ;
  fprintf(fid,'set: const real damp_fact = %6.4f ; \n', damp_fact) ;
fclose(fid);
