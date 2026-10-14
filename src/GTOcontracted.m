function[Rc] = GTOcontracted(l,x,y,z,cp,alpha)
%
%! Author: JCW(14/10/2026)
%! - Compute radial component of contracted Gaussian as a sum of unnormalized primitive Gaussians
%

  % Initialize
  Rc = 0;

  % R = sum( c*(r^l)*exp(-a*r^2) )
  % Loop over unnormalized primitive Gaussians
  for ip = 1:length(cp)
    Rp = GTOprimitive(l,x,y,z,alpha(ip));
    Rc = Rc + cp(ip)*Rp;
  end
end
