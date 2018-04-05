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

disp('Writing nodes');
%% NODES
fid = fopen([model_name, '/canopy.nod'],'w') ;
write_copy(fid);
    for i = 1 : N.ribs
        fprintf(fid,'structural: RIBS_CG + %d, dynamic,\n', i) ;
        fprintf(fid,'        reference, RIBS_CG + %d, null,       \n', i) ;
        fprintf(fid,'        reference, RIBS_CG + %d, eye,        \n', i) ;
        fprintf(fid,'        reference, RIBS_CG + %d, null,       \n', i) ;
        fprintf(fid,'        reference, RIBS_CG + %d, null;       \n', i) ;
    end



      %% Knot Nodes
      for i = 1 : length(knot)
          % LINE A
          fprintf(fid,'structural: LINE_A + KNOT_1 + %d, dynamic,\n', i) ;
          fprintf(fid,'        reference, LINE_A + KNOT_1 + %d, null,       \n', i) ;
          fprintf(fid,'        reference, LINE_A + KNOT_1 + %d, eye,        \n', i) ;
          fprintf(fid,'        reference, LINE_A + KNOT_1 + %d, null,       \n', i) ;
          fprintf(fid,'        reference, LINE_A + KNOT_1 + %d, null;       \n', i) ;
          % LINE B
          fprintf(fid,'structural: LINE_B + KNOT_1 + %d, dynamic,\n', i) ;
          fprintf(fid,'        reference, LINE_B + KNOT_1 + %d, null,       \n', i) ;
          fprintf(fid,'        reference, LINE_B + KNOT_1 + %d, eye,        \n', i) ;
          fprintf(fid,'        reference, LINE_B + KNOT_1 + %d, null,       \n', i) ;
          fprintf(fid,'        reference, LINE_B + KNOT_1 + %d, null;       \n', i) ;
      end


% Dummy Nodes
%% LEADING / TRAILING EDGE
for i = 1 : N.ribs
    fprintf(fid,'structural: RIBS_LE + %d, dummy, RIBS_CG + %d, offset, \n', i, i) ;
    fprintf(fid,'       reference, RIBS_LE + %d, null, \n', i) ;
    fprintf(fid,'       reference, RIBS_LE + %d, eye; \n',  i) ;
    fprintf(fid,'structural: RIBS_TE + %d, dummy, RIBS_CG + %d, offset, \n', i, i) ;
    fprintf(fid,'       reference, RIBS_TE + %d, null, \n', i) ;
    fprintf(fid,'       reference, RIBS_TE + %d, eye; \n',  i) ;
end

%% AERO POINTS
for i = 1 : N.ribs
    fprintf(fid,'structural: AERO + %d, dummy, RIBS_CG + %d, offset, \n', i, i) ;
    fprintf(fid,'       reference, AERO + %d, null, \n', i) ;
    fprintf(fid,'       reference, AERO + %d, eye; \n',  i) ;
end

%% BEAM_I POINTS
for i = 1 : N.beam
    fprintf(fid,'structural: BEAM_I + %d, dummy, PILOT, offset, \n', i) ;
    fprintf(fid,'       reference, BEAM_I + %d, null, \n', i) ;
    fprintf(fid,'       reference, BEAM_I + %d, eye; \n',  i) ;
end
%% BEAM_II POINTS
for i = 1 : N.beam
    fprintf(fid,'structural: BEAM_II + %d, dummy, PILOT, offset, \n', i) ;
    fprintf(fid,'       reference, BEAM_II + %d, null, \n', i) ;
    fprintf(fid,'       reference, BEAM_II + %d, eye; \n',  i) ;
end


fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Beam / Connection elements
 disp('Writing elements')
fid = fopen([model_name, '/canopy.elm'],'w') ;
write_copy(fid);

if BEAM_TYPE == 3
i_beam = 0 ;
  for i =  1 : 2 : (N.ribs-2)
    i_beam = i_beam + 1 ;
      fprintf(fid,'beam3: BEAM + %d, \n', i);
      fprintf(fid,'   RIBS_CG + %d,   position, reference,  RIBS_CG + %d, null, \n', i,i) ;
      fprintf(fid,'                orientation, reference,  RIBS_CG + %d, eye, \n', i) ;
      fprintf(fid,'   RIBS_CG + %d,   position, reference,  RIBS_CG + %d, null, \n', i+1,i+1) ;
      fprintf(fid,'                orientation, reference,  RIBS_CG + %d, eye, \n', i+1) ;
      fprintf(fid,'   RIBS_CG + %d,   position, reference,  RIBS_CG + %d, null, \n', i+2,i+2) ;
      fprintf(fid,'                orientation, reference,  RIBS_CG + %d, eye, \n', i+2) ;
  %    fprintf(fid,'   RIBS_CG + %d,  reference, node, null, \n', i) ;
  %    fprintf(fid,'   RIBS_CG + %d,  reference, node, null, \n', i+1) ;
  %    fprintf(fid,'   RIBS_CG + %d,  reference, node, null, \n', i+2) ;
      fprintf(fid,'	reference, BEAM_I + %d, eye, \n', i_beam ) ;
      fprintf(fid,'	linear elastic generic, eye, \n' ) ;
      %fprintf(fid,'	diag, %.1e, %.1e, %.1e, %.1e, %.1e, %.1e, \n', beam_stiff ) ;
    %  fprintf(fid,'	proportional, %6.4f,  \n', damp_fact ) ;
      fprintf(fid,'	reference, BEAM_II + %d, eye, \n', i_beam ) ;
      fprintf(fid,'	linear elastic generic, eye; \n' ) ;
      %fprintf(fid,'	diag, %.1e, %.1e, %.1e, %.1e, %.1e, %.1e; \n', beam_stiff ) ;
      %fprintf(fid,'	proportional, %6.4f;  \n', damp_fact ) ;
  end

  %% AERO BEAM 2 elements
    for i =  1 : 2 : (N.ribs-2)
      fprintf(fid,'aerodynamic beam3: AERO + %d, BEAM + %d, \n', i, i);
      fprintf(fid,'   reference,  AERO + %d, null, \n', i ) ;
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
      fprintf(fid,'     jacobian, yes; \n');
  end

elseif BEAM_TYPE == 2
    for i =  1 : (N.ribs-1)
        fprintf(fid,'beam2: BEAM + %d, \n', i);
        fprintf(fid,'   RIBS_CG + %d,  null, \n', i) ;
        fprintf(fid,'   RIBS_CG + %d,  null, \n', i+1) ;
      %  fprintf(fid,'   RIBS_CG + %d,   position, reference,  RIBS_CG + %d, null, \n', i,i) ;
        %fprintf(fid,'                orientation, reference,  RIBS_CG + %d, eye, \n', i) ;
      %  fprintf(fid,'   RIBS_CG + %d,   position, reference,  RIBS_CG + %d, null, \n', i+1,i+1) ;
        %fprintf(fid,'                orientation, reference,  RIBS_CG + %d, eye, \n', i+1) ;
        fprintf(fid,'	from nodes, \n' ) ;
        fprintf(fid,'	linear viscoelastic generic, \n' ) ;
       fprintf(fid,'	diag, %.1e, %.1e, %.1e, %.1e, %.1e, %.1e, \n', beam_stiff ) ;
       fprintf(fid,'	proportional, %6.5f; \n', damp_fact ) ;
     end

    %% AERO BEAM 2 elements
      for i =  1 : (N.ribs-1)
        fprintf(fid,'aerodynamic beam2: AERO + %d, BEAM + %d, \n', i, i);
        fprintf(fid,'   reference,  AERO + %d, null, \n', i ) ;
        fprintf(fid,'	  reference,  AERO + %d, eye,  \n', i ) ;
        fprintf(fid,'	  reference,  AERO + %d, null, \n', i+1 ) ;
        fprintf(fid,'	  reference,  AERO + %d, eye,  \n', i+1 ) ;
        fprintf(fid,'	  linear, %6.4f, %6.4f, \n', rib.chord(i), rib.chord(i+1));
        fprintf(fid,'	  linear, %6.4f, %6.4f, \n', (0.5-pAC)*rib.chord(i), (0.5-pAC)*rib.chord(i+1) );
        fprintf(fid,'	  linear, %6.4f, %6.4f, \n', -0.25 * rib.chord(i), -0.25 * rib.chord(i+1) );
        fprintf(fid,'	  linear, %6.4f, %6.4f, \n', rib.twist(i), rib.twist(i+1) );
        fprintf(fid,'  	aer_int_pts, \n');
        fprintf(fid,'  	naca0012,    \n');
    %     fprintf(fid,'  	unsteady, bielawa,     \n');
    %     fprintf(fid,'  	#theodorsen, c81, NACA0012,         \n');
    %     fprintf(fid,'  	c81, NACA0012,      \n');
        fprintf(fid,'     jacobian, yes; \n');
    end
  end


  %% RIBS Body
  for i = 1 : N.ribs
      fprintf(fid,'body: RIBS_CG + %d, RIBS_CG + %d,   \n', i, i);
      fprintf(fid,'     %6.4f, \n', rib.mass);
      fprintf(fid,'     reference, RIBS_CG + %d, null,    \n', i);
      fprintf(fid,'     diag,  %.3e, %.3e, %.3e ;  \n', rib.Ixx, rib.Iyy, rib.Izz);
  end




  %% Fake knots body
  for i = 1 : length(knot)
      fprintf(fid,'body: LINE_A + KNOT_1 + %d, LINE_A + KNOT_1 + %d,   \n', i, i);
      fprintf(fid,'     %6.4f, \n', 0.001);
      fprintf(fid,'     reference, LINE_A + KNOT_1 + %d, null,    \n', i);
      %fprintf(fid,'     diag, 1.e-6, 1.e-6, 1.e-6; \n');
      fprintf(fid,'     eye; \n');

      fprintf(fid,'body: LINE_B + KNOT_1 + %d, LINE_B + KNOT_1 + %d,   \n', i, i);
      fprintf(fid,'     %6.4f, \n', 0.001);
      fprintf(fid,'     reference, LINE_B + KNOT_1 + %d, null,    \n', i);
      %fprintf(fid,'     diag, 1.e-6, 1.e-6, 1.e-6; \n');
      fprintf(fid,'     eye; \n');
  end




%% TOP Line rods
  for j = 1 : length(knot)
    for i = 1 : length(knot(j).nrib)
      ij = knot(j).nrib(i);

    % LINE A
      fprintf(fid,'joint: LINE_A   + %d, rod, \n', 100*j+i);
      fprintf(fid,' 	LINE_A + KNOT_1 + %d, position, reference, LINE_A + KNOT_1 + %d, null, \n', j, j ) ;
      fprintf(fid,' 	RIBS_CG + %d, position, reference, LINE_A + %d, null, \n',ij,ij) ;
      fprintf(fid,' 	from nodes, \n') ;
      %fprintf(fid,' 	double linear viscoelastic, .1, 1.e-4, -1., stiff_A, 1e-2, second damping, damp_A; \n');
      fprintf(fid,' 	linear viscoelastic, stiff_A, damp_A; \n');

     % LINE B
      fprintf(fid,'joint: LINE_B   + %d, rod, \n', 100*j+i);
      fprintf(fid,' 	LINE_B + KNOT_1 + %d, position, reference, LINE_B + KNOT_1 + %d, null, \n', j, j ) ;
      fprintf(fid,' 	RIBS_CG + %d, position, reference, LINE_B + %d, null, \n',ij,ij) ;
      fprintf(fid,' 	from nodes, \n') ;
      %fprintf(fid,' 	double linear viscoelastic, .1, 1.e-4, -1., stiff_B, 1e-2, second damping, damp_B; \n');
      fprintf(fid,' 	linear viscoelastic, stiff_B, damp_B; \n');
     end
  end



  %% LOW Line rods
  for i =  1 : length(knot)/2
    % LINE A
      fprintf(fid,'joint: LINE_A + KNOT_1 + %d, rod, \n', i);
      fprintf(fid,'	PILOT, position, reference, CARAB + 1, null, \n' ) ;
      fprintf(fid,'	LINE_A + KNOT_1 + %d, position, reference, LINE_A + KNOT_1 + %d, null, \n',i,i) ;
      fprintf(fid,'	from nodes, \n') ;
      %fprintf(fid,'	double linear viscoelastic, .1, 1.e-4, -1., stiff_A, 1e-2, second damping, damp_A; \n');
      fprintf(fid,' 	linear viscoelastic, stiff_A, damp_A; \n');
   % LINE B
     fprintf(fid,'joint: LINE_B + KNOT_1 + %d, rod, \n', i);
     fprintf(fid,'	PILOT, position, reference, CARAB + 1, null, \n' );
     fprintf(fid,'	LINE_B + KNOT_1 + %d, position, reference, LINE_B + KNOT_1 + %d, null, \n', i, i);
     fprintf(fid,'	from nodes, \n') ;
    % fprintf(fid,'	double linear viscoelastic, .1, 1.e-4, -1., stiff_B, 1e-2, second damping, damp_B; \n');
     fprintf(fid,' 	linear viscoelastic, stiff_B, damp_B; \n');
  end
  for i = length(knot)/2 + 1 : length(knot)
    % LINE A
      fprintf(fid,'joint: LINE_A + KNOT_1 + %d, rod, \n', i);
      fprintf(fid,'	PILOT, position, reference, CARAB + 2, null, \n' ) ;
      fprintf(fid,'	LINE_A + KNOT_1 + %d, position, reference, LINE_A + KNOT_1 + %d, null, \n',i,i) ;
      fprintf(fid,'	from nodes, \n') ;
      %fprintf(fid,'	double linear viscoelastic, .1, 1.e-2, -1., stiff_A, 1e-2, second damping, damp_A; \n');
      fprintf(fid,' 	linear viscoelastic, stiff_A, damp_A; \n');
    % LINE B
      fprintf(fid,'joint: LINE_B + KNOT_1 + %d, rod, \n', i);
      fprintf(fid,'	PILOT, position, reference, CARAB + 2, null, \n' );
      fprintf(fid,'	LINE_B + KNOT_1 + %d, position, reference, LINE_B + KNOT_1 + %d, null, \n', i, i);
      fprintf(fid,'	from nodes, \n') ;
    %  fprintf(fid,'	double linear viscoelastic, .1, 1.e-2, -1., stiff_B, 1e-2, second damping, damp_B; \n');
      fprintf(fid,' 	linear viscoelastic, stiff_B, damp_B; \n');
  end




fclose(fid);
