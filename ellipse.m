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

function [ y, th ] = ellipse( x, param )
% ELLIPSE   Generate ellipse shape
% inputs:
%   - span position (y)
%   - shape parameter (a, b, ym)
%   - paramection parameter (x1, c0, type)
for i = 1 : length(x)
 % No paramection
  if (( strcmp(param.type,'none'))  || ( param.type == 0 ) )
    y(i) = param.b * sqrt(1 - (x(i)/param.a)^2) ;
    dy(i) = -param.b * ( x(i) / (param.a^2) ) * 1 / ( sqrt(1 - (x(i)/param.a)^2) );
 % No paramection
  elseif ( abs(x(i)) <= param.x1 ) && (~( strcmp(param.type, 'none') ) || ( param.type ~= 0 ) )
    y(i) = param.b * sqrt(1 - (x(i)/param.a)^2) ;
    dy(i) = -param.b * ( x(i) / (param.a^2) ) * 1 / ( sqrt(1 - (x(i)/param.a)^2) );
 % Exponential paramection
  elseif ( abs(x(i)) > param.x1 ) && ( param.type > 0  )
    y(i) = param.b * sqrt(1 - (x(i)/param.a)^2) - param.c0 * ((abs(x(i)) - param.x1)/(param.xm - param.x1))^param.type ;
    dy(i) = -param.b * ( x(i) / (param.a^2) ) * 1 / ( sqrt(1 - (x(i)/param.a)^2) ) ...
      -sign(x(i))*param.c0*param.type*((abs(x(i)) - param.x1)/(param.xm - param.x1))^(param.type-1)*(1/(param.xm - param.x1));
% Error
  else
    display('Error shape function !');
    y(i) = NaN ;
    dy(i) = NaN ;

  end

  th = atan(dy)' ;
end
end
