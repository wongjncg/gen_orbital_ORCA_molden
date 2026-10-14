function[Rp] = GTOprimitive(l,x,y,z,alpha)
%
%! Author: JCW(04/07/2025)
%! - Calculate radial component of unnormalized primitive Gaussian
%

  r = sqrt(x.^2 + y.^2 + z.^2);
  % Primitive Gaussian
  Rp = r.^(l).*exp(-alpha*(r.^2));
end
