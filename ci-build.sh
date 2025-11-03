#!/bin/bash

gdbVersion="16.3"
quartusVersion=23.1std

wget https://ftpmirror.gnu.org/gnu/gdb/gdb-${gdbVersion}.tar.xz
tar -xf gdb-${gdbVersion}.tar.xz

pushd gdb-${gdbVersion}
echo "[i] configuring"
./configure --enable-targets=all --with-python --without-auto-load-safe-path
echo "[i] starting build"
make all-gdb -j$(nproc)
strip gdb/.libs/gdb.exe
popd


echo "[i] copying data directory"
mkdir -p assets/intelFPGA_lite/${quartusVersion}/nios2eds/bin/gnu/H-x86_64-mingw32/nios2-elf/share/gdb
cp -r ./gdb-${gdbVersion}/gdb/data-directory/python ./assets/intelFPGA_lite/${quartusVersion}/nios2eds/bin/gnu/H-x86_64-mingw32/nios2-elf/share/gdb

echo "[i] copying gdb.exe and .dll files"
mkdir -p assets/intelFPGA_lite/${quartusVersion}/nios2eds/bin/gnu/H-x86_64-mingw32/bin
cp ./gdb-${gdbVersion}/gdb/.libs/gdb.exe ./assets/intelFPGA_lite/${quartusVersion}/nios2eds/bin/gnu/H-x86_64-mingw32/bin/gdb-multiarch.exe
cp /ucrt64/bin/*.dll ./assets/intelFPGA_lite/${quartusVersion}/nios2eds/bin/gnu/H-x86_64-mingw32/bin

echo "[i] get python dll from embeddeble source"
wget https://www.python.org/ftp/python/3.12.9/python-3.12.9-embed-amd64.zip
unzip python-3.12.9-embed-amd64.zip -d python3.12
cp -f ./python3.12/python312.dll ./assets/intelFPGA_lite/${quartusVersion}/nios2eds/bin/gnu/H-x86_64-mingw32/bin/libpython3.12.dll
cp -f ./python3.12/python312.zip ./assets/intelFPGA_lite/${quartusVersion}/nios2eds/bin/gnu/H-x86_64-mingw32/bin/

echo "gdb version: ${gdbVersion}" > assets/Readme.txt
echo "quartus version: ${quartusVersion}" >> assets/Readme.txt
echo " " >> assets/Readme.txt
echo "extract this in your quartus installation directory" >> assets/Readme.txt

pushd assets
echo "[i] tarballing final artifact"
tar -cJf ../nios-gdb.tar.xz .
popd
