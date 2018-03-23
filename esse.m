

function out = esse(x, param, ref)
  
  s = quadv (@ddy, 0, x, [], [], param);
  out = s - ref ;
  end
  