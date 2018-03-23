function out = ddy(x, param)
  [ y, th ] = ellipse( x, param );
  
  dy = tan(th) ;
  out = sqrt(1 + dy.^2) ;
  end
  
  
  