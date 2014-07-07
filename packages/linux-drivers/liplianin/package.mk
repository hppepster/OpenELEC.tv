################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="liplianin-v39"
PKG_VERSION="4457d4a"
LIPLIANIN_VERSION="2014-04-28"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://bitbucket.org/CrazyCat/s2-liplianin-v39"
# PKG_URL="$DISTRO_SRC/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_URL="http://mycvh.de/openelec/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET=""
PKG_BUILD_DEPENDS_TARGET="toolchain linux"
PKG_PRIORITY="optional"
PKG_SECTION="driver"
PKG_SHORTDESC="Build system to use the latest experimental drivers/patches without needing to replace the entire Kernel"
PKG_LONGDESC="Build system to use the latest experimental drivers/patches without needing to replace the entire Kernel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_make_target() {
  export KERNEL_VER=$(get_module_dir)
  # dont use our LDFLAGS, use the KERNEL LDFLAGS
  export LDFLAGS=""
}

# dont build parallel
  MAKEFLAGS=-j1

make_target() {

  sed -i "s|/sbin/depmod|$ROOT/$TOOLCHAIN/bin/depmod|g" v4l/scripts/make_makefile.pl
  sed -i "s|strip --strip-debug|$STRIP --strip-debug|g" v4l/scripts/make_makefile.pl
  sed -i 's|\\\\nRemoving obsolete files from \\$(KDIR26)|Removing obsolete files from \\$(DESTDIR)\\$(KDIR26)|g' v4l/scripts/make_makefile.pl

  LDFLAGS="" make DIR=$(kernel_path) prepare
  LDFLAGS="" make DIR=$(kernel_path)
}

makeinstall_target() {
  mkdir -p $INSTALL/lib/modules/$KERNEL_VER/updates/liplianin
  find $ROOT/$PKG_BUILD/v4l/ -name \*.ko -exec $STRIP --strip-debug {} \;
  find $ROOT/$PKG_BUILD/v4l/ -name \*.ko -exec cp {} $INSTALL/lib/modules/$KERNEL_VER/updates/liplianin \;

  mkdir -p $INSTALL/lib/firmware/
  cp $ROOT/$PKG_BUILD/v4l/firmware/*.fw $INSTALL/lib/firmware/
}
