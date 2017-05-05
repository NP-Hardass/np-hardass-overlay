# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=(python2_{6,7})
inherit eutils distutils-r1

SRC_URI="mirror://sabayon/${CATEGORY}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

DESCRIPTION="A Pandora Radio (pandora.com) player for the GNOME Desktop"
HOMEPAGE="http://kevinmehall.net/p/pithos/"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND=">=dev-python/python-distutils-extra-2.10"

RDEPEND="dev-python/pyxdg
	dev-python/pygobject
	dev-python/notify-python
	dev-python/pygtk
	dev-python/gst-python:0.10
	dev-python/dbus-python
	media-libs/gst-plugins-good:0.10
	media-libs/gst-plugins-bad:0.10
	media-plugins/gst-plugins-faad:0.10
	media-plugins/gst-plugins-soup:0.10
	|| ( gnome-base/gnome-settings-daemon mate-base/mate-settings-daemon
		dev-libs/keybinder )
"

#RESTRICT_PYTHON_ABIS="2.[45] 3.*"
DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES="1"

src_prepare() {
	# hacky way to build when DISPLAY not set
	# https://bugs.launchpad.net/pithos/+bug/778522
	epatch "${FILESDIR}"/${P}-fix-build.patch
	distutils-r1_src_prepare

	# bug #216009
	# avoid writing to /root/.gstreamer-0.10/registry.xml
	export GST_REGISTRY="${T}"/registry.xml
}

src_install() {
	distutils-r1_src_install

	dosym  ../icons/hicolor/scalable/apps/${PN}.svg \
		/usr/share/pixmaps/${PN}.svg || die "dosym failed"
}
