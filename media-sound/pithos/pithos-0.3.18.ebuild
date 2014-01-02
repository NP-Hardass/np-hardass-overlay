# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/pithos/pithos-20130808.ebuild,v 1.1 2013/08/08 21:24:48 chutzpah Exp $

EAPI=5
PYTHON_COMPAT=(python2_7)
inherit eutils distutils-r1

if [[ ${PV} == 99999999 ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/kevinmehall/pithos.git
					https://github.com/kevinmehall/pithos.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"	
	S="${WORKDIR}/${P}"
fi

DESCRIPTION="A Pandora Radio (pandora.com) player for the GNOME Desktop"
HOMEPAGE="http://pithos.github.io/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gnome"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

RDEPEND="dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/notify-python[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/gst-python[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pylast[${PYTHON_USEDEP}]
	media-plugins/gst-plugins-meta:0.10[aac,http,mp3]
	gnome? ( gnome-base/gnome-settings-daemon )
	!gnome? ( dev-libs/keybinder[python] )"

src_prepare() {
	epatch "${FILESDIR}/${P}-detect-datadir.patch"
	epatch "${FILESDIR}/${P}-dont-notify-volume.patch"
	
	# replace the build system with something more sane
	cp "${FILESDIR}"/setup.py "${S}"

	distutils-r1_src_prepare
}
