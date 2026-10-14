# gen_orbital_ORCA_molden

Code for generating orbitals in MATLAB from orca_2mkl MOLDEN file.

First extract from MOLDEN file, the info (inc. coordinates, basis set, LCAO coefficients) needed to construct the orbitals:
```
extract_coord_basis.sh <moldenfile> <coord_outfile>
extract_lcao.sh <moldenfile> <lcao_outfile>
```
The script is designed based on `orca_2mkl` from ORCA version 5.0.3. Coordinates are in atomic units (Bohr). ORCA uses spherical coordinates for the angular component (5D,7F,9G...). p-orbitals (l=1) are ordered as (x,y,z) or (1,-1,0). d-orbitals (l=2) are ordered as (d_z^2,d_xz,d_yz,d_x^2-y^2,d_xy) or (0,1,-1,2,-2). Note that the code only implements angular components up to d-orbitals!

## MATLAB fuctions
The code stores all the basis set in a single structure array. Load basis set info of each atomic species using `load_basis.m`. For example:
```
basis.C = load_basis('gto_C')
basis.H = load_basis('gto_H')
```

Then, use `construct_AO_info.m` to map the coordinate and atomic orbital angular info (l,m) to each LCAO coefficient. If using Gaussian type orbitals (GTOs), also assign the contracted Gaussian info. Output as a single structure array. Run as:
```
AO = construct_AO_info('coord.dat', basis)
```
The total number of AOs must match the length of LCAO coefficients. Atomic numbers are mapped to element symbols in 'element_table.dat'. Add to the file if the atomic species of interest does not exist.

Before running `gen_MO.m`, you must first define a 3D grid (in atomic units) stored as a structure array that contains the following info:
- X,Y,Z: 3D grid coordinates. Works with both `ndgrid` and `meshgrid` in MATLAB.
- dV: Unit volume

For each MO, run `gen_MO.m`. The function can generate either Gaussian-type or Slater-type orbitals from the LCAO coefficients. Inputs needed:
- LCAO coefficients (as a single column)
- AO info for each coefficients
- Basis info
- Coordinate file or filename
- Grid info
- Orbital type of choice: 'Gaussian' or 'Slater'
- Ionization Potential (IP) or Electron Affinity (EA) below vacuum level (if 'Slater')
- IP/EA units (if 'Slater')
Output:
- Volumetric data
- Norm

###Additional information:
- All calculations are done in atomic units. For IP/EA input values, units must be defined.
- Check the calculated norm outputted by `gen_MO.m` and normalize the data accordingly!
- Radial component of Gaussian-type orbitals: sum( c\*(r^l)\*exp(-a\*r^2) )
- Radial component of Slater-type orbitals: r^l\*exp(-zeta\*r) where zeta = sqrt(2\*E\*m_e/hbar)
