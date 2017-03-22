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

disp('Writing references');
%% Canopy reference
fid = fopen([model_name, '/canopy.ref'],'w') ;
write_copy(fid);
 % RIBS Center of Gravity
 for i = 1 : 2*N.ribs-1
   fprintf(fid,'reference: RIBS_CG + %d, \n', i) ;
   fprintf(fid,'        reference, CANOPY, %6.4f, %6.4f, %6.4f, \n', rib.x(i,:)) ;
   fprintf(fid,'        reference, CANOPY, \n') ;
   fprintf(fid,'			3, 0., %6.4f, %6.4f,  \n', -sin(rib.th(i)), cos(rib.th(i)) ) ;
   fprintf(fid,'			1, -1., 0., 0.,  \n') ;
   fprintf(fid,'        reference, CANOPY, null, \n') ;
   fprintf(fid,'        reference, CANOPY, null; \n') ;
 end

 % RIBS Center of gravity - Beam oriented
 for i = 1 : 2*N.ribs-1
   fprintf(fid,'reference: RIBS_CG + BEAM + %d, \n', i) ;
   fprintf(fid,'        reference, RIBS_CG + %d, null, \n', i) ;
   fprintf(fid,'        reference, RIBS_CG + %d, \n', i) ;
   fprintf(fid,'			1, 0., -1., 0.,  \n') ;
   fprintf(fid,'			3, 0., 0., 1.,  \n') ;
   fprintf(fid,'        reference, CANOPY, null, \n') ;
   fprintf(fid,'        reference, CANOPY, null; \n') ;
 end

 % RIBS Center of gravity - Section I oriented
 for i = 1 :2: 2*N.cell-1
   fprintf(fid,'reference: RIBS_CG + BEAM + EPS1 + %d, \n', i) ;
   fprintf(fid,'        reference, RIBS_CG + %d, null, \n', i) ;
   fprintf(fid,'        reference, CANOPY, \n') ;
   fprintf(fid,'			3, 0., %6.4f, %6.4f,  \n', -sin(rib.th_eps1((i+1)/2)), cos(rib.th_eps1((i+1)/2)) ) ;
   fprintf(fid,'			2, -1., 0., 0.,  \n') ;
   fprintf(fid,'        reference, CANOPY, null, \n') ;
   fprintf(fid,'        reference, CANOPY, null; \n') ;

% RIBS Center of gravity - Section II oriented
  fprintf(fid,'reference: RIBS_CG + BEAM + EPS2 + %d, \n', i) ;
  fprintf(fid,'        reference, RIBS_CG + %d, null, \n', i+2) ;
  fprintf(fid,'        reference, CANOPY, \n') ;
  fprintf(fid,'			3, 0., %6.4f, %6.4f,  \n', -sin(rib.th_eps2((i+1)/2)), cos(rib.th_eps2((i+1)/2)) ) ;
  fprintf(fid,'			2, -1., 0., 0.,  \n') ;
  fprintf(fid,'        reference, CANOPY, null, \n') ;
  fprintf(fid,'        reference, CANOPY, null; \n') ;
end

 % RIBS LEADING / TRAILING Edge
 for i = 1 : 2*N.ribs-1
 % (LE) LEADING EDGE
   fprintf(fid,'reference: RIBS_LE + %d, \n', i) ;
   fprintf(fid,'        reference, CANOPY, %6.4f, %6.4f, %6.4f, \n', rib.LE(i,:)) ;
   fprintf(fid,'        reference, RIBS_CG + %d, eye,  \n', i) ;
   fprintf(fid,'        reference, CANOPY, null, \n') ;
   fprintf(fid,'        reference, CANOPY, null; \n') ;
 % (TE) TRAILING EDGE
   fprintf(fid,'reference: RIBS_TE + %d, \n', i) ;
   fprintf(fid,'        reference, CANOPY, %6.4f, %6.4f, %6.4f, \n', rib.TE(i,:)) ;
   fprintf(fid,'        reference, RIBS_CG + %d, eye,  \n', i) ;
   fprintf(fid,'        reference, CANOPY, null, \n') ;
   fprintf(fid,'        reference, CANOPY, null; \n') ;
 end

 % CELL Surface reference - Aero oeriented
 for i = 1 : 2*N.ribs-1
     fprintf(fid,'reference: AERO + %d, \n', i) ;
     fprintf(fid,'        reference, CANOPY, %6.4f, %6.4f, %6.4f, \n', (rib.LE(i,:)+rib.TE(i,:))*0.5 ) ;
     fprintf(fid,'        reference, RIBS_CG + %d, \n', i) ;
     fprintf(fid,'			1, 1., 0., 0.,  \n' ) ;
     fprintf(fid,'			2, 0., 0., 1.,  \n') ;
     fprintf(fid,'        reference, CANOPY, null, \n') ;
     fprintf(fid,'        reference, CANOPY, null; \n') ;
 end

%% LINES anchor points reference
 for i = 1 :2: 2*N.ribs-1
 % LINE A
   fprintf(fid,'reference: LINE_A + %d, \n', i) ;
   fprintf(fid,'        reference, CANOPY, %6.4f, %6.4f,%6.4f, \n', rib.xA(i,:)) ;
   fprintf(fid,'        reference, RIBS_CG + %d, eye,  \n', i) ;
   fprintf(fid,'        reference, CANOPY, null, \n') ;
   fprintf(fid,'        reference, CANOPY, null; \n') ;
 % LINE B
   fprintf(fid,'reference: LINE_B + %d, \n', i) ;
   fprintf(fid,'        reference, CANOPY, %6.4f, %6.4f, %6.4f, \n', rib.xB(i,:)) ;
   fprintf(fid,'        reference, RIBS_CG + %d, eye,  \n', i) ;
   fprintf(fid,'        reference, CANOPY, null, \n') ;
   fprintf(fid,'        reference, CANOPY, null; \n') ;
 end


 % LEFT HARNESS CARABINER
 fprintf(fid,'reference: CARAB + 1, \n') ;
 fprintf(fid,'        reference, PILOT, 0., %6.4f, %6.4f, \n', -0.5*pilot.d, pilot.h) ;
 fprintf(fid,'        reference, PILOT, eye,  \n') ;
 fprintf(fid,'        reference, CANOPY, null, \n') ;
 fprintf(fid,'        reference, CANOPY, null; \n') ;

% RIGHT HARNESS CARABINER
fprintf(fid,'reference: CARAB + 2, \n') ;
fprintf(fid,'        reference, PILOT, 0., %6.4f, %6.4f, \n', 0.5*pilot.d, pilot.h) ;
fprintf(fid,'        reference, PILOT, eye,  \n') ;
fprintf(fid,'        reference, CANOPY, null, \n') ;
fprintf(fid,'        reference, CANOPY, null; \n') ;


fclose(fid);
