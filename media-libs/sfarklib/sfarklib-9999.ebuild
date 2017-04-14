# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

MY_PN="sfArkLib"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/raboof/${MY_PN}.git"
else
	SRC_URI="https://github.com/raboof/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

DESCRIPTION="SoundFont compression library"
HOMEPAGE="https://github.com/raboof/sfArkLib"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"

src_prepare(){
	# Change paths to not be local
	sed -i 's:/local::g' Makefile || die

	# Change libdir to correct one
	sed -i "s:/lib/:/$(get_libdir)/:g" Makefile || die

	default
}
