# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

# project is hosted on github.com, so git-2 is needed (git is deprecated)
inherit git-2 autotools

DESCRIPTION="gopenvpn is a gtk tray icon for openvpn"
HOMEPAGE="http://gopenvpn.sourceforge.net/"

EGIT_REPO_URI="git://gopenvpn.git.sourceforge.net/gitroot/gopenvpn/gopenvpn.git"
#https://github.com/dweeezil/gopenvpn.git
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-libs/glib:2
		x11-libs/gtk+:2
		gnome-base/libglade
		gnome-base/gnome-keyring
		sys-auth/polkit"
PDEPEND="app-editors/gedit"
src_prepare(){
		gettextize
		sed -i '124s/.*/AC_CONFIG_FILES([pixmaps\/Makefile/' configure.ac
		autoreconf -vif
		./configure
}
