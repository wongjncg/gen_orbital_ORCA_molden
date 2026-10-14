function[atom_symbol] = get_elementsymbol(atomic_number)

%
%! Author: JCW(07/07/2025)
%! - Read the atomic number in coordinate file and assign the corresponding element symbol.
%

  element = readtable('element_table.dat');
  % Index lookup
  k = find(element{:,1}==atomic_number);
  atom_symbol = string(element{k,2});
end