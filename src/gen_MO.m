function[V,norm] = gen_MO(LCAO,AO_info,basis,coordfile,grid,orbitaltype,en,en_unit)

%{
Author: JCW(14/10/2026)
- Construct orbital (MO/Dyson) via linear combination of atomic orbitals (LCAO) from ORCA Molden file
- Atomic basis are defined in spherical coordinates
- Use either Slater or Gaussian-type orbitals for radial component
- Read info on atomic positions, and angular component (l,m) values
- For Gaussian-type basis:
-- Construct using unnormalized primitive Gaussians
-- Contracted Gaussians are normalized by convention
- For Slater-type basis:
-- Unnormalized radial components are used
-- Exponent factor 'zeta' computed as a function of IP/EA
-- IP and EA values defined wrt. energy below the vacuum level
%}

  % Load coordinate file
  if ischar(coordfile) == 1
    coord = importdata(coordfile);
  else
    coord = coordfile;
  end

  % Error
  if any(strcmpi(orbitaltype, {'Slater','STO','S'}))
    if en < 0
      error('en < 0 detected! Set en > 0 wrt. energy below vacuum level.')
    end
  end

  % AO info array
  ind = AO_info.pos_ind; % Atomic position index
  l = AO_info.l;         % Orbital angular momentum
  m = AO_info.m;         % Magnetic quantum number
  if any(strcmpi(orbitaltype, {'Gaussian','GTO','G'}))
    cG = AO_info.cG;     % Contracted Gaussian file to read
  end

  % Initialize output based on input 3D grid size
  V = zeros(size(grid.X));
  % Atomic index counter (to reduce number of 3D grid computations)
  ind_counter = 0;

  % Compute LCAO
  for i = 1:length(ind)
    if ind_counter ~= ind(i)
      ind_counter = ind(i); % Update counter
      % Cartesian 3D grid values wrt. individual atom position
      pos.X = grid.X - coord(ind_counter,3);
      pos.Y = grid.Y - coord(ind_counter,4);
      pos.Z = grid.Z - coord(ind_counter,5);
    end
    % Compute radial component based on basis type
    if any(strcmpi(orbitaltype, {'Gaussian','GTO','G'}))
      % Set which contracted Gaussian file to read
      cG_file = strcat('cGaussian',num2str(cG(i)));
      elem = get_elementsymbol(coord(ind(i),2)); % Atomic species
      cp = basis.(elem).(cG_file).cp;
      alpha = basis.(elem).(cG_file).alpha;
      % Sum contracted Gaussian over primitives
      Rl = GTOcontracted(l(i),pos.X,pos.Y,pos.Z,cp,alpha);
    elseif any(strcmpi(orbitaltype, {'Slater','STO','S'}))
      Rl = STOradial(l(i),pos.X,pos.Y,pos.Z,en,en_unit);
    end
    % Compute unnormalized real angular component
    Ylm = SphericalHarmonics(l(i),m(i),pos.X,pos.Y,pos.Z,0);
    % AO norm
    norm_AO = sum(abs(Rl.*Ylm).^2,'all')*grid.dV;
    % Sum LCAO over entire grid
    V = V + LCAO(i)*Rl.*Ylm/sqrt(norm_AO);
  end
  % Compute norm of MO
  norm = sum(V.^2,'all')*grid.dV;
end
