#!/bin/bash

# Make m4 accessible to bison
# https://github.com/conda-forge/bison-feedstock/issues/7#issuecomment-431602144
export M4=m4
export CPLUS_INCLUDE_PATH=${PREFIX}/include
export CPP_INCLUDE_PATH=${PREFIX}/include
export CXX_INCLUDE_PATH=${PREFIX}/include

# build
./install.sh

dest=${PREFIX}/bin
mkdir -p ${dest}

# copy over all relevant files for the package
for file in raxml-ng modeltest-ng astral.jar mpi-scheduler; do
  find . -type f -name ${file} -print -exec cp --parents '{}' ${dest} \;
done

for patt in ".*/pargenes/.*\.py" ".*\.so"; do
  find . -type f -regextype posix-egrep -regex "${patt}" -print -exec cp --parents '{}' ${dest} \;
done

cd ${dest}
ln -s pargenes/pargenes.py pargenes.py

echo -e "#!/usr/bin/env python\n$(cat pargenes/pargenes.py)" > pargenes/pargenes.py
