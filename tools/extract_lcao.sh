#!/bin/bash

# Extract LCAO coefficients for all MOs and store it as a (n_AO,n_MO) array

moldenfile="$1"
outfile="$2"

# Find subheader 'Sym' line numbers of all MOs
# Then count number of lines between first and second entries
grep -n 'Sym= ' $moldenfile | awk -F':' '{print $1}' > temp_headline
# Extract line number of first and second MOs, then count number of lines in between
first=`head -n1 temp_headline`
second=`sed -n 2p temp_headline`
nlines=$(($second-$first))

# First MO iteration
# Define lines of first and last LCAO coefficients
line=`sed -n 1p temp_headline`
startline=$(($line+4))
endline=$(($line+$nlines-1))
sed -n ${startline},${endline}p $moldenfile | awk '{print $2}' > temp

# Loop through all subsequent orbitals
for i in $(seq 2 `wc -l temp_headline | awk '{print $1}'`)
do
  # Define lines of first LCAO and last LCAO coefficients
  line=`sed -n ${i}p temp_headline`
  startline=$(($line+4))
  endline=$(($line+$nlines-1))
  sed -n ${startline},${endline}p $moldenfile | awk '{print $2}' > dummy
  paste -d' ' temp dummy > temp2
  mv temp2 temp
done
mv temp $outfile

# Delete temp. files
rm temp_headline
rm dummy
