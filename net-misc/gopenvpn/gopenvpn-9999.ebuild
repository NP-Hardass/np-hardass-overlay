# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# project is hosted on github.com, so git-2 is needed (git is deprecated)
inherit git-r3 autotools

DESCRIPTION="A GTK tray icon and GUI for managing OpenVPN connections"
HOMEPAGE="http://gopenvpn.sourceforge.net/"

#EGIT_REPO_URI="git://gopenvpn.git.sourceforge.net/gitroot/gopenvpn/gopenvpn.git"
EGIT_REPO_URI="git://git.code.sf.net/u/samm2/gopenvpn u-samm2-gopenvpn.git"
#EGIT_REPO_URI="https://github.com/dweeezil/gopenvpn.git"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-libs/glib:2
		x11-libs/gtk+:2
		gnome-base/libglade
		gnome-base/gnome-keyring
		sys-auth/polkit"
#this doesn't seem to be working, so let's just remove the gedit dependency
#PDEPEND="app-editors/gedit"
src_prepare(){
		#gettextize runs in interactive mode.  This hack forces it to be non-interactive
		cp $(type -p gettextize) "${T}"/ || die
		sed -i -e 's:read dummy < /dev/tty::' "${T}/gettextize" || die
		einfo "Running gettextize -f --no-changelog..."
		"${T}"/gettextize -f --no-changelog > /dev/null || die "gettexize failed"

		sed -i '124s/.*/AC_CONFIG_FILES([pixmaps\/Makefile/' configure.ac
		#sed -i '125s/.*/AC_CONFIG_FILES([pixmaps\/Makefile/' configure.ac

		eautoreconf
		eautoconf
}

src_install() {
	domenu "${FILESDIR}/gopenvpn.desktop"

	default
}
