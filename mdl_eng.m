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

disp('Writing nodes');
%% NODES
fid = fopen([model_name, '/canopy.nod'],'w') ;
write_copy(fid);
    for i = 1 : 2*N.ribs-1
        fprintf(fid,'structural: RIBS_CG + %d, dynamic,\n', i) ;
        fprintf(fid,'        reference, RIBS_CG + %d, null,       \n', i) ;
        fprintf(fid,'        reference, RIBS_CG + %d, eye,        \n', i) ;
        fprintf(fid,'        reference, RIBS_CG + %d, null,       \n', i) ;
        fprintf(fid,'        reference, RIBS_CG + %d, null;       \n', i) ;
    end

% Dummy Nodes
  for i = 1 :2: 2*N.ribs-1
      fprintf(fid,'structural: LINE_A + %d, dummy, RIBS_CG + %d, offset, \n', i, i) ;
      fprintf(fid,'       reference, LINE_A + %d, null, \n', i) ;
      fprintf(fid,'       reference, LINE_A + %d, eye; \n',  i) ;
  end
  for i = 1 :2: 2*N.ribs-1
      fprintf(fid,'structural: LINE_B + %d, dummy, RIBS_CG + %d, offset, \n', i, i) ;
      fprintf(fid,'       reference, LINE_B + %d, null, \n', i) ;
      fprintf(fid,'       reference, LINE_B + %d, eye; \n',  i) ;
  end

  for i = 1 : 2*N.ribs-1
      fprintf(fid,'structural: RIBS_LE + %d, dummy, RIBS_CG + %d, offset, \n', i, i) ;
      fprintf(fid,'       reference, RIBS_LE + %d, null, \n', i) ;
      fprintf(fid,'       reference, RIBS_LE + %d, eye; \n',  i) ;
  end
  for i = 1 : 2*N.ribs-1
      fprintf(fid,'structural: RIBS_TE + %d, dummy, RIBS_CG + %d, offset, \n', i, i) ;
      fprintf(fid,'       reference, RIBS_TE + %d, null, \n', i) ;
      fprintf(fid,'       reference, RIBS_TE + %d, eye; \n',  i) ;
  end

  for i = 1 : 2*N.ribs-1
      fprintf(fid,'structural: AERO + %d, dummy, RIBS_CG + %d, offset, \n', i, i) ;
      fprintf(fid,'       reference, AERO + %d, null, \n', i) ;
      fprintf(fid,'       reference, AERO + %d, eye; \n',  i) ;
  end

  for i = 1 : 2*N.ribs-1
      fprintf(fid,'structural: BEAM + %d, dummy, RIBS_CG + %d, offset, \n', i, i) ;
      fprintf(fid,'       reference, RIBS_CG + BEAM + %d, null, \n', i) ;
      fprintf(fid,'       reference, RIBS_CG + BEAM + %d, eye; \n',  i) ;
  end

fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Beam / Connection elements
 disp('Writing elements')
fid = fopen([model_name, '/canopy.elm'],'w') ;
write_copy(fid);
  for i =  1 :2: 2*N.cell-1
      fprintf(fid,'beam3: BEAM + %d, \n', i);
      fprintf(fid,'   RIBS_CG + %d, reference, RIBS_CG + BEAM + %d, null, \n', i, i) ;
      fprintf(fid,'   RIBS_CG + %d, reference, RIBS_CG + BEAM + %d, null, \n', i+1, i+1) ;
      fprintf(fid,'   RIBS_CG + %d, reference, RIBS_CG + BEAM + %d, null, \n', i+2, i+2) ;
      fprintf(fid,'	reference, RIBS_CG + BEAM + EPS1 + %d, eye,  \n', i ) ;
      fprintf(fid,'	linear viscoelastic generic, \n' ) ;
      fprintf(fid,'	diag, EA, GAy, GAz, GJ, EJy, EJz, \n' ) ;
      fprintf(fid,'	proportional, damp_fact,  \n' ) ;
      fprintf(fid,'	reference, RIBS_CG + BEAM + EPS2 + %d, eye,  \n', i ) ;
      fprintf(fid,'	same ; \n' ) ;
  end

  %% AERO BEAM 2 elements
    for i =  1 :2: 2*N.cell-1
      fprintf(fid,'aerodynamic beam3: AERO + %d, BEAM + %d, \n', i, i);
      fprintf(fid,'    reference,  AERO + %d, null, \n', i ) ;
      fprintf(fid,'	  reference,  AERO + %d, eye,  \n', i ) ;
      fprintf(fid,'	  reference,  AERO + %d, null, \n', i+1 ) ;
      fprintf(fid,'	  reference,  AERO + %d, eye,  \n', i+1 ) ;
      fprintf(fid,'	  reference,  AERO + %d, null, \n', i+2 ) ;
      fprintf(fid,'	  reference,  AERO + %d, eye,  \n', i+2 ) ;
      fprintf(fid,'	  linear, %6.4f, %6.4f, \n', rib.chord(i), rib.chord(i+2));
      fprintf(fid,'	  linear, %6.4f, %6.4f, \n', (0.5-pAC)*rib.chord(i), (0.5-pAC)*rib.chord(i+2) );
      fprintf(fid,'	  linear, %6.4f, %6.4f, \n', -0.25 * rib.chord(i), -0.25 * rib.chord(i+2) );
      fprintf(fid,'	  linear, %6.4f, %6.4f, \n', rib.twist(i), rib.twist(i+2) );
      fprintf(fid,'  	aer_int_pts, \n');
      fprintf(fid,'  	naca0012,    \n');
  %     fprintf(fid,'  	unsteady, bielawa,     \n');
  %     fprintf(fid,'  	#theodorsen, c81, NACA0012,         \n');
  %     fprintf(fid,'  	c81, NACA0012,      \n');
      fprintf(fid,'     jacobian, 1; \n');
  end

  %% Body RIBS
  for i = 1 : 2*N.ribs-1
      rib.mass = 0.2 ;
      fprintf(fid,'body: RIBS_CG + %d, RIBS_CG + %d,   \n', i, i);
      fprintf(fid,'     %6.4f, \n', rib.mass);
      fprintf(fid,'     reference, RIBS_CG + %d, null,    \n', i);
      fprintf(fid,'     eye; \n');
      %fprintf(fid,'     diag, 1.e-3, 4.e-3, 4.e-3; \n');
  end

  %% Lines elements
  for i = 1 :2: 2*N.ribs-1
     if i <= N.ribs
        lr = 1 ;
     else
        lr = 2 ;
     end
    % LINE A
      fprintf(fid,'joint: LINE_A + %d, rod, \n', i);
      fprintf(fid,'	PILOT, position, reference, CARAB + %d, null, \n', lr ) ;
      fprintf(fid,'	RIBS_CG + %d, position, reference, LINE_A + %d, null, \n',i,i) ;
      fprintf(fid,'	from nodes, \n') ;
      fprintf(fid,'	double linear viscoelastic, 100., 1.e-2, -1., stiff_A, 1e-2, second damping, damp_A; \n', stiff_A, damp_A);
    % LINE B
      fprintf(fid,'joint: LINE_B + %d, rod, \n', i);
      fprintf(fid,'	PILOT, position, reference, CARAB + %d, null, \n', lr );
      fprintf(fid,'	RIBS_CG + %d, position, reference, LINE_B + %d, null, \n', i, i);
      fprintf(fid,'	from nodes, \n') ;
      fprintf(fid,'	double linear viscoelastic, 100., 1.e-2, -1., stiff_B, 1e-2, second damping, damp_B; \n', stiff_B, damp_B);
  end

fclose(fid);
