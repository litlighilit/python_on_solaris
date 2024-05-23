
set -u
set -e
pkgadd -d http://get.opencsw.org/now
pkgu=/opt/csw/bin/pkgutil
$pkgu -U
$pkgu -y -i libssl_dev
$pkgu -y -i libssl1_0_0
$pkgu -y -i libreadline6 
$pkgu -y -i libreadline_dev 
$pkgu -y -i libncurses_dev
$pkgu -y -i libsqlite3_dev 
$pkgu -y -i libgdbm_dev 
$pkgu -y -i libbz2_dev
$pkgu -y -i tk_dev
$pkgu -y -i tk 
$pkgu -y -i pkgconfig

# ? ffi.h won't be placed to /opt/csw/include auto, but somewhere like /opt/csw/lib/libffi-3.2.1/include
$pkgu -y -i libffi_dev

prefix=/opt/csw/lib/libffi
suffix=include
for i in `"$pkgu" -L libffi_dev`; do
  if [[ "$i" == "$prefix"*"$suffix" ]]; then
    cp "$i"/*.h /opt/csw/include
    break
  fi
done

# To manually set it seems to be required,
# in x86x64, its value is `no`
F_END="ax_cv_c_float_words_bigendian=no"

# There used to be a `-L/opt/local/lib` but my machine seems to not contain this dir
./configure --with-openssl=/opt/csw/ "$F_END" LDFLAGS='-I/opt/csw/include -L/opt/csw/lib  -R/opt/csw/lib' PKG_CONFIG_PATH=/opt/csw/lib/amd64/pkgconfig/ CPPFLAGS='-I/opt/csw/include -L/opt/csw/lib -R/opt/csw/lib'

make
make install

