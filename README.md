# gen_orbital_ORCA_molden

Code for generating orbitals in MATLAB from `orca_2mkl` MOLDEN file.

First extract from MOLDEN file, the info (including coordinates, basis set, LCAO coefficients) needed to construct the orbitals:
```
extract_coord_basis.sh <moldenfile> <coord_outfile>
extract_lcao.sh <moldenfile> <lcao_outfile>
```
ORCA outputs MOLDEN files in atomic units (Bohr). The angular components are in spherical coordinates (5D, 7F, 9G,...).

## MATLAB functions
The code stores all the basis set in a single structure array. Load basis set info of each atomic species using `load_basis.m`. For example:
```
basis.C = load_basis('gto_C')
basis.H = load_basis('gto_H')
```

Then, use `construct_AO_info.m` to map the coordinate and atomic orbital angular info (l,m) to each LCAO coefficient. Also assigns the contracted Gaussian file to read for Gaussian-type orbitals (GTOs). Output is stored as a single structure array. Run example:
```
AO = construct_AO_info('coord.dat', basis)
```
The total number of AOs must match the number of LCAO coefficients. Atomic numbers are mapped to element symbols in 'element_table.txt'. Add to the file if the atomic species of interest does not exist.

Before running `gen_MO.m`, you must first define a 3D grid (in atomic units) stored as a structure array that contains the following info:
- **X, Y, Z**: 3D grid coordinates. Works with both `ndgrid` and `meshgrid` in MATLAB.
- **dV**: Unit volume

For each MO, run `gen_MO.m`. The function can generate either Gaussian-type or Slater-type orbitals from the LCAO coefficients. Inputs needed:
- LCAO coefficients (in a single column)
- AO info for each coefficients
- Basis info
- Coordinate file
- Grid info
- Orbital type of choice: **'Gaussian'** or **'Slater'**
- Ionization Potential (IP) or Electron Affinity (EA) energy below vacuum level (if **'Slater'**)
- IP/EA unit (if **'Slater'**)

Output:
- Volumetric data
- Norm

**Note: Volumetric data output by `gen_MO.m` is unnormalized by default!** Check output norm and normalize data accordingly.

See `/examples` for sample MATLAB script to setup and run the code.

## Additional information:
- Shell script to extract from MOLDEN file is based on `orca_2mkl` from ORCA version 5.0.3.
- The code only implements angular components up to $l = 2$ (d-orbitals).
- All calculations in MATLAB are done in atomic units. Units for IP/EA energy values must be defined for proper conversion.
- Equation for radial component of contracted GTOs in terms of Gaussian primitives:
```math
R_l(r) = \sum_p c_p r^l e^{-\alpha_p r^2}
```
- Equation for radial component of STOs:
```math
R_l(r) = r^l e^{-\zeta r}
```
```math
\zeta = \frac{\sqrt{2 E m_e}}{\hbar}
```
