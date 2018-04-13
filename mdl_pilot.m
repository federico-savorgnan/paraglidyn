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

disp('Writing PILOT data');
%% PILOT REFERENCE
fid = fopen([model_name, '/pilot.ref'], 'w') ;
    write_copy(fid);
    % PILOT CG
    fprintf(fid,'reference: PILOT, \n') ;
    fprintf(fid,'        reference, CANOPY, %9.7f, %9.7f, %9.7f, \n', pilot.x );
    fprintf(fid,'        reference, CANOPY, eye, \n') ;
    fprintf(fid,'        reference, CANOPY, null, \n') ;
    fprintf(fid,'        reference, CANOPY, null; \n') ;
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PILOT NODE
fid = fopen([model_name, '/pilot.nod'],'w') ;
    write_copy(fid);
    fprintf(fid,'structural: PILOT, dynamic, \n') ;
    fprintf(fid,'        reference, PILOT, null, \n') ;
    fprintf(fid,'        reference, PILOT, eye, \n') ;
    fprintf(fid,'        reference, PILOT, null, \n') ;
    fprintf(fid,'        reference, PILOT, null; \n') ;
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PILOT BODY
fid = fopen([model_name, '/pilot.elm'],'w') ;
  write_copy(fid);
  fprintf(fid,'body: PILOT, PILOT, variable mass, \n');
  fprintf(fid,'   const, %6.4f, \n', pilot.mass);
  fprintf(fid,'   component, \n');
  fprintf(fid,'       const, 0., \n');
  fprintf(fid,'       array, %d,    \n', pilot.Ncyc );
  for i = 1 : pilot.Ncyc
    fprintf(fid,'       cosine, %9.7f, %9.7f, %9.7f, %s, 0., \n', (2*i-2)*(pilot.tau) + pilot.t0, 2*pi/pilot.tau,  pilot.offset, pilot.type);
    % fprintf(fid,'       cosine, %9.7f, %9.7f, %9.7f, %s, 0., \n', (2*i-1)*(pilot.tau) + pilot.t0, 2*pi/pilot.tau,  -pilot.offset, pilot.type);
  end

  fprintf(fid,'       const, 0., \n');
  fprintf(fid,'   component, diag, \n');
  fprintf(fid,'       const, %6.4f, \n', pilot.Ixx);
  fprintf(fid,'       const, %6.4f, \n', pilot.Iyy);
  fprintf(fid,'       const, %6.4f, \n', pilot.Izz);
  fprintf(fid,'   component, diag, \n');
  fprintf(fid,'       const, 0., \n');
  fprintf(fid,'       const, 0., \n');
  fprintf(fid,'       const, 0.; \n');

% (simple) Aerodynamic drag force
  fprintf(fid,'force: PILOT + 50, absolute,\n');
  fprintf(fid,'   PILOT, position, reference, PILOT, 0.5, 0., 0., \n');
  fprintf(fid,'   component, \n');
  fprintf(fid,'   string, "-Cd*S_pilot*rho*0.5*model::xvelocity(PILOT)*model::velocity(PILOT)", \n');
  fprintf(fid,'   string, "-Cd*S_pilot*rho*0.5*model::yvelocity(PILOT)*model::velocity(PILOT)", \n');
  fprintf(fid,'   string, "-Cd*S_pilot*rho*0.5*model::zvelocity(PILOT)*model::velocity(PILOT)"; \n');
fclose(fid);
