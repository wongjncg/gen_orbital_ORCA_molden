function[R] = STOradial(l,x,y,z,en,en_unit)

%{
Author: JCW(14/10/2026)
- Compute the radial component of unnormalized Slater-type orbital in atomic units.
- Convert energy to atomic units (Hartree) if in other units.
%}

  % Unit conversion
  if any(strcmpi(en_unit, {'Hartree','Ha','au'}))
    E = en;
  elseif any(strcmpi(en_unit, {'Ry','Rydberg'}))
    E = en/2;
  elseif any(strcmpi(en_unit, {'eV'}))
    E = en/27.211386;
  elseif any(strcmpi(en_unit, {'kJ/mol'}))
    E = en/2625.5;
  else
    error('Units for energy undefined/unavailable! Options: Ha, Ry, eV, kJ/mol')
  end

  zeta = sqrt(2*E); % zeta = sqrt(2*E*m_e)/hbar, where E>0 if below vacuum level.
  r = sqrt(x.^2 + y.^2 + z.^2);
  R = r.^(l).*exp(-zeta.*r);
end
