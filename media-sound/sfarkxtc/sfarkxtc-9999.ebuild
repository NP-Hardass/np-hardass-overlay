# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/raboof/${PN}.git"
else
	SRC_URI="https://github.com/raboof/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="SoundFont compression CLI decompressor"
HOMEPAGE="https://github.com/raboof/sfarkxtc"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	media-libs/sfarklib
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

src_prepare(){
	# Change paths to not be local
	sed -i 's:/local::g' Makefile || die

	default
}
