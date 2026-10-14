% Generate 3D (in Bohr!)
% Stepsize
grid.dx = 0.2;
grid.dy = 0.2;
grid.dz = 0.2;
grid.dV = grid.dx*grid.dy*grid.dz;
% Grid
grid.x = (-5: grid.dx: 5);
grid.y = (-5: grid.dy: 5);
grid.z = (-5: grid.dz: 5);
[grid.X, grid.Y, grid.Z] = meshgrid(grid.x,grid.y,grid.z);

% Basis info
basis.O = load_basis('gto_O');
basis.H = load_basis('gto_H');
% AO info
AO = construct_AO_info('coord.dat', basis);

% Load LCAO
homo_lcao = importdata('homo.dat');
lumo_lcao = importdata('lumo.dat');

% Generate GTOs
[GTO_homo.V, GTO_homo.norm] = gen_MO(homo_lcao, AO, basis, 'coord.dat', grid, 'Gaussian');
[GTO_lumo.V, GTO_lumo.norm] = gen_MO(lumo_lcao, AO, basis, 'coord.dat', grid, 'Gaussian');

% Generate STOs of H2O HOMO (Use gas-phase IP = 12.6 eV below vacuum level)
[STO_homo.V, STO_homo.norm] = gen_MO(homo_lcao, AO, basis, 'coord.dat', grid, 'Slater', 12.6, 'eV');

% Normalize
GTO_homo.Vnorm = GTO_homo.V/sqrt(GTO_homo.norm);
GTO_lumo.Vnorm = GTO_lumo.V/sqrt(GTO_lumo.norm);
STO_homo.Vnorm = STO_homo.V/sqrt(STO_homo.norm);

% Visualize orbitals
% Variables
orbV = GTO_homo.Vnorm; % Volumetric data
isoval = 0.1;          % Isosurface value
% Isosurface plot
figure
hold
s1 = isosurface(grid.X, grid.Y, grid.Z, orbV, isoval);
p1 = patch(s1);
set(p1, 'FaceColor', 'b');
set(p1, 'EdgeColor', 'none');
s2 = isosurface(grid.X, grid.Y, grid.Z, orbV, -isoval);
p2 = patch(s2);
set(p2, 'FaceColor', 'r');
set(p2, 'EdgeColor', 'none');
camlight
lighting gouraud
box on
axis equal
axis([min(grid.X(:)) max(grid.X(:)) min(grid.Y(:)) max(grid.Y(:)) min(grid.Z(:)) max(grid.Z(:))])
