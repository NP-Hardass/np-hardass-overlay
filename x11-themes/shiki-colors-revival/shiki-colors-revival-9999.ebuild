# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils git-r3

DESCRIPTION="Shiki-Colors-Revival is a GTK+3 recreation of Shiki-Colors"
HOMEPAGE="https://github.com/somasis/shiki-colors-revival/"

EGIT_REPO_URI="https://github.com/somasis/shiki-colors-revival.git"
if ! [[ ${PV} == 9999 ]]; then
	EGIT_COMMIT="v${PV}"
fi

LICENSE="GPL-3"
SLOT="0"
if ! [[ ${PV} == 9999 ]]; then
	KEYWORDS="~amd64 ~x86"
fi
IUSE=""

RDEPEND="
	|| ( x11-wm/marco x11-wm/muffin x11-wm/mutter xfce-base/xfwm4 )
	x11-themes/gtk-engines:2
"
DEPEND=""
RESTRICT="binchecks strip"

pkg_setup(){
	# Makefile doesn't support parallel ops
	MAKEOPTS="-j1"
}

src_prepare() {
	# Allow splitting of prepare and generate
	sed -i "s/generate: prepare/generate:/" Makefile || die

	no_git="true" emake prepare
}

src_compile() {
	emake generate
}

src_install() {
	default
	dodoc README.md
	newdoc .mailmap CREDITS
	docinto numix-themes
	dodoc numix-themes/{CREDITS,LICENSE,README.md}
}
