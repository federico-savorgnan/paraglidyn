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

disp('Writing references');
%% Canopy reference
fid = fopen([model_name, '/canopy.ref'],'w') ;
write_copy(fid);


  fprintf(fid,'reference: BEAM_0, \n') ;
  fprintf(fid,'        reference, CANOPY, null, \n')  ;
  fprintf(fid,'        reference, CANOPY,  \n') ;
  fprintf(fid,'			1,  0., 1., 0.,   \n' ) ;
  fprintf(fid,'			3,  0., 0., 1.,   \n') ;
  fprintf(fid,'        reference, CANOPY, null, \n') ;
  fprintf(fid,'        reference, CANOPY, null; \n') ;

  fprintf(fid,'reference: AERO_0, \n') ;
  fprintf(fid,'        reference, CANOPY, null, \n')  ;
  fprintf(fid,'        reference, CANOPY,  \n') ;
  fprintf(fid,'			1,  -1., 0., 0.,   \n' ) ;
  fprintf(fid,'			2,  0., 0., 1.,   \n') ;
  fprintf(fid,'        reference, CANOPY, null, \n') ;
  fprintf(fid,'        reference, CANOPY, null; \n') ;

% RIBS Center of Gravity
 for i = 1 : N.ribs
   fprintf(fid,'reference: RIBS_CG + %d, \n', i) ;
   fprintf(fid,'        reference, CANOPY, %9.7f, %9.7f, %9.7f, \n', rib.x(i,:)) ;
   fprintf(fid,'        reference, BEAM_0, euler123, \n') ;
   fprintf(fid,'			     0., %9.7f, %9.7f,  \n', -rib.th(i), 0. ) ;
   fprintf(fid,'        reference, BEAM_0, null, \n') ;
   fprintf(fid,'        reference, BEAM_0, null; \n') ;
 end

 for i = 1 : N.beam
   fprintf(fid,'reference: BEAM_I + %d, \n', i) ;
   fprintf(fid,'        reference, CANOPY, %9.7f, %9.7f, %9.7f, \n', rib.I(i,:)) ;
   fprintf(fid,'        reference, BEAM_0, euler123, \n') ;
   fprintf(fid,'			     0., %9.7f, %9.7f,  \n', -rib.I_th(i), 0.) ;
   fprintf(fid,'        reference, BEAM_0, null, \n') ;
   fprintf(fid,'        reference, BEAM_0, null; \n') ;
 end

 for i = 1 : N.beam
   fprintf(fid,'reference: BEAM_II + %d, \n', i) ;
   fprintf(fid,'        reference, CANOPY, %9.7f, %9.7f, %9.7f, \n', rib.II(i,:)) ;
   fprintf(fid,'        reference, BEAM_0, euler123, \n') ;
   fprintf(fid,'			     0., %9.7f, %9.7f,  \n', -rib.II_th(i), 0.) ;
   fprintf(fid,'        reference, BEAM_0, null, \n') ;
   fprintf(fid,'        reference, BEAM_0, null; \n') ;
 end

 % AERO CELL Surface reference - Aero oeriented
 for i = 1 : N.ribs
     fprintf(fid,'reference: AERO + %d, \n', i) ;
     fprintf(fid,'        reference, CANOPY, %9.7f, %9.7f, %9.7f, \n', rib.aer(i,:)) ;
     fprintf(fid,'        reference, AERO_0, euler123,  \n') ;
     fprintf(fid,'			     %9.7f, %9.7f, 0.,  \n', -rib.th(i), 0. ) ;
     fprintf(fid,'        reference, AERO_0, null, \n') ;
     fprintf(fid,'        reference, AERO_0, null; \n') ;
 end


 %% DUMMY REFERENCE
  % RIBS LEADING / TRAILING Edge
  for i = 1 : N.ribs
  % (LE) LEADING EDGE
    fprintf(fid,'reference: RIBS_LE + %d, \n', i) ;
    fprintf(fid,'        reference, CANOPY, %9.7f, %9.7f, %9.7f, \n', rib.LE(i,:)) ;
    fprintf(fid,'        reference, BEAM_0, euler123, \n') ;
    fprintf(fid,'			     0., %9.7f, %9.7f,  \n', -rib.th(i), 0. ) ;
    fprintf(fid,'        reference, CANOPY, null, \n') ;
    fprintf(fid,'        reference, CANOPY, null; \n') ;
  % (TE) TRAILING EDGE
    fprintf(fid,'reference: RIBS_TE + %d, \n', i) ;
    fprintf(fid,'        reference, CANOPY, %9.7f, %9.7f, %9.7f, \n', rib.TE(i,:)) ;
    fprintf(fid,'        reference, BEAM_0, euler123, \n') ;
    fprintf(fid,'			     0., %9.7f, %9.7f,  \n', -rib.th(i), 0. ) ;
    fprintf(fid,'        reference, CANOPY, null, \n') ;
    fprintf(fid,'        reference, CANOPY, null; \n') ;
  end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LINES anchor points reference
 for i = 1 : N.ribs
 % LINE A
   fprintf(fid,'reference: LINE_A + %d, \n', i) ;
   fprintf(fid,'        reference, CANOPY, %9.7f, %9.7f, %9.7f, \n', rib.xA(i,:)) ;
   fprintf(fid,'        reference, RIBS_CG + %d, eye,  \n', i) ;
   fprintf(fid,'        reference, CANOPY, null, \n') ;
   fprintf(fid,'        reference, CANOPY, null; \n') ;
 % LINE B
   fprintf(fid,'reference: LINE_B + %d, \n', i) ;
   fprintf(fid,'        reference, CANOPY, %9.7f, %9.7f, %9.7f, \n', rib.xB(i,:)) ;
   fprintf(fid,'        reference, RIBS_CG + %d, eye,  \n', i) ;
   fprintf(fid,'        reference, CANOPY, null, \n') ;
   fprintf(fid,'        reference, CANOPY, null; \n') ;
 end


%% Knot points
 for i = 1 : length(knot)
 % LINE A
   fprintf(fid,'reference: LINE_A + KNOT_1 + %d, \n', i) ;
   fprintf(fid,'        reference, CANOPY, %9.7f, %9.7f, %9.7f, \n', knot(i).xA) ;
   fprintf(fid,'        reference, CANOPY, eye,  \n') ;
   fprintf(fid,'        reference, CANOPY, null, \n') ;
   fprintf(fid,'        reference, CANOPY, null; \n') ;
 % LINE B
   fprintf(fid,'reference: LINE_B + KNOT_1 + %d, \n', i) ;
   fprintf(fid,'        reference, CANOPY, %9.7f, %9.7f, %9.7f, \n', knot(i).xB) ;
   fprintf(fid,'        reference, CANOPY, eye,  \n') ;
   fprintf(fid,'        reference, CANOPY, null, \n') ;
   fprintf(fid,'        reference, CANOPY, null; \n') ;
 end


% LEFT HARNESS CARABINER
  fprintf(fid,'reference: CARAB + 1, \n') ;
  fprintf(fid,'        reference, PILOT, 0., %9.7f, %9.7f, \n', -0.5*pilot.d, pilot.h) ;
  fprintf(fid,'        reference, PILOT, eye,  \n') ;
  fprintf(fid,'        reference, CANOPY, null, \n') ;
  fprintf(fid,'        reference, CANOPY, null; \n') ;

% RIGHT HARNESS CARABINER
  fprintf(fid,'reference: CARAB + 2, \n') ;
  fprintf(fid,'        reference, PILOT, 0., %9.7f, %9.7f, \n', 0.5*pilot.d, pilot.h) ;
  fprintf(fid,'        reference, PILOT, eye,  \n') ;
  fprintf(fid,'        reference, CANOPY, null, \n') ;
  fprintf(fid,'        reference, CANOPY, null; \n') ;


fclose(fid);
