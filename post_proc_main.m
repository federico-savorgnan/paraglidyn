clear all
close all
clc

pkg load netcdf
load('wing_01/input_data.mat')
filename = 'wing_01/canopy.nc' ;

%% MODEL POST-PROC
time = ncread(filename, 'time');

listmn = ['                                            ',
          '   #----------------------------------#     ',
          '   |   1.  Pilot                      |     ',
          '   |   2.  Central Box orientation    |     ',
          '   |   3.  Aero elm                   |     ',
          '   |   4.  Pilot Efficiency           |     ',
          '   |   5.  Wing Shape                 |     ',
          '   |   6.  Lines Forces               |     ',
          '   |   7.  Wing Joint forces          |     ',
          '   |   8.  Joint disp                 |     ',
          '   |   0.  EXIT                       |     ',
          '   #----------------------------------#     ',
          '                                            ' ];

exit = 0 ;
ID_plot = 1 ;

while ~exit
  clc
  disp(listmn)
  M = input('  Insert choice: ') ;
  if M == 1
    [Pilot_x] = pilot_x(filename, ID_plot, N) ;
    [Pilot_v] = pilot_v(filename, ID_plot, time) ;
    [Pilot_Eff] = pilot_Eff(filename, ID_plot, time) ;
  elseif M == 2
    [Pilot_E] = pilot_E(filename, ID_plot, N, time) ;
  elseif M == 3
    [Pilot_alfa] = pilot_alfa(filename, ID_plot, N, time) ;
  elseif M == 4
    [Pilot_Eff] = pilot_Eff(filename, ID_plot, time) ;
  elseif M == 5
     wing_shape(filename, ID_plot, N, time) ;
  elseif M == 6
     lines_f(filename, ID_plot, N, time) ;
  elseif M == 7
     joint_f(filename, ID_plot, N, time) ;
  elseif M == 8
     joint_x(filename, ID_plot, N, time) ;
  else
    exit = 1 ;
  end
  ID_plot = ID_plot + 1 ;
end
