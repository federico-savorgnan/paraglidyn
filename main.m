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
function main(sim)
close all
clc

model_name = 'wing_01' ;

%% Overwrite model check
if exist(model_name)
    %overw = yes_or_no('!!! WARNING !!! : Overwrite model?  ') ;
 overw = 1 ;
    if overw
       disp('Deleting model') ;
      system(['rm -R ', model_name]);
    else
       disp('OK, Nothing to do.') ;
    end
end

%% MODEL PRE-PROCESSOR
if ~exist(model_name)
  disp('Creating new model') ;
  system(['mkdir ', model_name]);

  %% Input model data
    data_store
  %% Geometry generation
    geom_eng
    plot_model

  %% Main analysis deck files
    mdl_canopy
  %% Model variables
    mdl_set
  %% Wing reference
    mdl_ref
  %% Pilot model files
    mdl_pilot
  %% Nodes and Elements
    mdl_eng

  disp('MODEL SUCCESFULLY CREATED');
  %sim = yes_or_no('Launch model simulation ? ');

  if sim
    OUT = system(['/usr/local/mbdyn/bin/mbdyn ', model_name, '/canopy.mbd &']);
  end
end
