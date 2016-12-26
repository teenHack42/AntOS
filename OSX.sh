echo "Installing build tools for OSX"
echo "Downloading Binutils 2.27 ..."
mkdir -p ~/src
cd ~/src
wget "ftp://ftp.gnu.org/gnu/binutils/binutils-2.27.tar.gz"
tar -xvzf ./binutils-2.27.tar.gz
echo "Downloading GCC 3.6.0 ..."
wget "ftp://ftp.gnu.org/gnu/gcc/gcc-6.3.0/gcc-6.3.0.tar.gz"
tar -xvzf ./gcc-3.6.0.tar.gz
echo "Installing texinfo via Homebrew..."
brew install texinfo

export PREFIX="$HOME/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"

cd $HOME/src

mkdir -p build-binutils
cd build-binutils
echo "Building Binutils"
../binutils-2.27/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make
make install

cd $HOME/src

# The $PREFIX/bin dir _must_ be in the PATH. We did that above.
which -- $TARGET-as || echo $TARGET-as is not in the PATH

mkdir -p build-gcc
cd build-gcc
echo "building GCC"
../gcc-3.6.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc
make all-target-libgcc
make install-gcc
make install-target-libgcc

echo "Installing XORRISO with Homebrew..."
brew install xorriso


echo "Installing objconv..."
mkdir -p objconv
cd ~/objconv
wget "https://github.com/vertis/objconv/archive/master.zip"
unzip -a ./master.zip
cd master
g++ -o objconv -O2 src/*.cpp
export PATH="$HOME/objconv/objconv:$PATH"

echo "Installing grub..."
cd ~
git clone git://git.savannah.gnu.org/grub.git
cd grub
./autogen.sh
mkdir -p ~/buildgrub
cd ~/buildgrub
../grub/configure --disable-werror TARGET_CC=i686-elf-gcc TARGET_OBJCOPY=i686-elf-objcopy \
TARGET_STRIP=i686-elf-strip TARGET_NM=i686-elf-nm TARGET_RANLIB=i686-elf-ranlib --target=i686-elf

make
make install


echo "Removing intermediate programs and build directorys"
cd ~
rm -r objconv
rm -r buildgrub
rm -r grub
cd src
rm -r binutils-2.27
rm -r gcc-3.6.0





echo
echo "Add the line:"
echo "export PATH=\"$HOME/opt/cross/bin:$PATH\""
echo "to your ~/.profile"
