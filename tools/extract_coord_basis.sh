#!/bin/bash

# Extract section of orca_2mkl MOLDEN file containing atomic coordinates
# (excluding 1st column of atomic symbols).
# Then, extract GTO basis info for each atomic species.

moldenfile="$1"
out_coordfile="$2"

### Section: Extract coordinates
# Find subheader line with atomic coordinates in between
start_headerline=`grep -n '\[Atoms\]' $moldenfile | awk -F':' '{print $1}'`
end_headerline=`grep -n '\[GTO\]' $moldenfile | awk -F':' '{print $1}'`

# Extract coord
startline=$(($start_headerline+1))
endline=$(($end_headerline-1))
sed -n ${startline},${endline}p $moldenfile | awk '{print $2,$3,$4,$5,$6}' > $out_coordfile



### Section: Extract GTO basis info
# For each atomic species, find the corresponding index of first occurrence.
sed -n ${startline},${endline}p $moldenfile | awk '{print $1,$2}' | awk '!seen[$1]++' > temp_info

# Extract basis section of MOLDEN file
start_headerline=`grep -n '\[GTO\]' $moldenfile | awk -F':' '{print $1}'`
end_headerline=`grep -n '\[MO\]' $moldenfile | awk -F':' '{print $1}'`
sed -n ${start_headerline},${end_headerline}p $moldenfile > temp_GTO

# Print empty line numbers after each basis entry
awk '/^$/ {print NR}' temp_GTO > temp_empty

# Iterate over each atomic species
for i in $(seq 1 `wc -l temp_info | awk '{print $1}'`)
do
  atom_ind=`sed -n ${i}p temp_info | awk '{print $2}'`
  header=`grep -n " $atom_ind 0" temp_GTO | awk -F':' '{print $1}'`
  endspace=`sed -n ${atom_ind}p temp_empty`
  startline=$(($header+1))
  endline=$(($endspace-1))
  prefix=gto
  species=`sed -n ${i}p temp_info | awk '{print $1}'`
  sed -n ${startline},${endline}p temp_GTO > ${prefix}_${species}
done

# Delete temp. files
rm temp_info
rm temp_GTO
rm temp_empty
