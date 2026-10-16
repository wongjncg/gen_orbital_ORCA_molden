function[Y] = SphericalHarmonics(l,m,x,y,z,cplx_flag)

%{
Author: JCW (02/07/2025)
- Given the corresponding l and m values, provide the unnormalized spherical harmonics from the list of stored values.
- Implemented up to l=2 only!!!
%}

  r = sqrt(x.^2 + y.^2 + z.^2);
  % Complex spherical harmonics
  if cplx_flag == 1
    if l == 0
      Y = 1;
    elseif l == 1
      if m == -1
        Y = complex(x,-y)./r;
      elseif m == 0
        Y = z./r;
      elseif m == 1
        Y = -complex(x,y)./r;
      end
    elseif l == 2
      if m == -2
        Y = complex(x,-y).^2./r.^2;
      elseif m == -1
        Y = complex(x,-y).*z./r.^2;
      elseif m == 0
        Y = (3*z.^2-r.^2)./r.^2;
      elseif m == 1
        Y = -complex(x,y).*z./r.^2;
      elseif m == 2
        Y = complex(x,y).^2./r.^2;
      end
    end

  % Real spherical harmonics
  elseif cplx_flag == 0
    if l == 0
      Y = 1;
    elseif l == 1
      if m == -1 %p_y
        Y = y./r;
      elseif m == 0 %p_z
        Y = z./r;
      elseif m == 1 %p_x
        Y = x./r;
      end
    elseif l == 2
      if m == -2 %d_xy
        Y = x.*y./r.^2;
      elseif m == -1 %d_yz
        Y = y.*z./r.^2;
      elseif m == 0 %d_z^2
        Y = (3*z.^2-r.^2)./r.^2;
      elseif m == 1 %d_xz
        Y = x.*z./r.^2;
      elseif m == 2 %d_x^2-y^2
        Y = (x.^2-y.^2)./r.^2;
      end
    end
  end

  % Set NaN values of 0/0 for x=y=z=r=0 to zero.
  % In the AO, 1/r^l in angular component cancels out with r^l in radial component.
  Y(isnan(Y)) = 0;

end
