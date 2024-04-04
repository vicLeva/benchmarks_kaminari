#!/usr/bin/bash

# Script to install COBS, PAC, RAMBO, kmindex, RAPTOR, metaprofi, fulgor
# assuming all requirements are met, it installs everything but it might 
# be better to go one by one and check for errors

cd softs/

##############################################################
# MANUAL INSTALL SOFTS
##############################################################

#COBS https://github.com/bingmann/cobs  ========================================

# bugs with cmake >=3.26.4, works with source /local/env/envcmake-3.21.3.sh

git clone --recursive https://github.com/bingmann/cobs.git;
mkdir cobs/build;
cd cobs/build;
cmake ..;
make -j;

cd ../..;

#RUN with ./cobs/build/src/cobs ARGS


#PAC https://github.com/Malfoy/PAC  ============================================

#had to install zlib from https://zlib.net/
#then add `-I../include/zlib/include` at the end of CFLAGS=
#and `-L../include/zlib/lib` at the end of LDFLAGS=

git clone --depth 1 --recursive https://github.com/Malfoy/PAC.git
cd PAC
make

cd ..

#RUN with ./PAC/PAC ARGS


#RAMBO https://github.com/RUSH-LAB/RAMBO  ======================================

#had to run these commands after error on ./configure
#libtoolize --force
#aclocal
#autoheader
#automake --force-missing --add-missing
#autoconf
#./configure

git clone --recursive https://github.com/RUSH-LAB/RAMBO.git
cd RAMBO
./configure
make 
make install

cd ..

#RUN with ./RAMBO/bin/rambo ARGS



#FULGOR https://github.com/jermp/fulgor  =======================================

#if rust not installed : 
#curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

git clone --recursive https://github.com/jermp/fulgor.git
cd fulgor && mkdir build && cd build && cmake ..
make -j

cd ../..

#RUN with ./fulgor/build/fulgor ARGS


##############################################################
# CONDA SOFTS
##############################################################


#METAPROFI https://github.com/kalininalab/metaprofi  ===========================

conda create -p metaprofi_env python==3.8 pigz
conda activate ./metaprofi_env

git clone https://github.com/kalininalab/metaprofi.git
#pip install Cython==0.29.28 numpy==1.22.3 if error with SharedArray
pip install ./metaprofi

#RUN with metaprofi ARGS



#need other env for kmindex & raptor, different dependancies than for metaprofi
conda deactivate
conda create -p kmindex_raptor_env
conda activate ./kmindex_raptor_env


#KMINDEX https://github.com/tlemane/kmindex  ===================================

conda install -c conda-forge -c tlemane kmindex

#git clone --recursive https://github.com/tlemane/kmindex 
#cd kmindex && ./install.sh && cd .. 

#RUN with kmindex ARGS


#RAPTOR https://github.com/seqan/raptor  =======================================

conda install -c bioconda -c conda-forge raptor

#git clone --recursive https://github.com/seqan/raptor
#cd raptor && mkdir build && cd build && cmake .. && make && cd ../..

#RUN with raptor ARGS