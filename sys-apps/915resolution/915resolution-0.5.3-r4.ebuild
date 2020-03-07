# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils flag-o-matic

DESCRIPTION="Utility to patch VBIOS of Intel 855 / 865 / 915 chipsets"
HOMEPAGE="http://915resolution.mango-lang.org/"
SRC_URI="http://915resolution.mango-lang.org/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

PATCHES=(
	"${FILESDIR}/${P}-freebsd.patch"
	# add support for 965GM (bug #186661)
	"${FILESDIR}/${P}-965GM.patch"
	"${FILESDIR}/${P}-945GME.patch"
)

DOCS="README.txt changes.log chipset_info.txt dump_bios"

src_compile() {
	filter-flags -O*
	emake clean
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	dosbin ${PN}
	newconfd "${FILESDIR}/confd" ${PN}
	newinitd "${FILESDIR}/initd" ${PN}
}

pkg_postinst() {
	elog
	elog "${PN} alters your video BIOS in a non-permanent way, this means"
	elog "that there is no risk of permanent damage to your video card, but"
	elog "it also means that it must be run at every boot. To set it up, "
	elog "edit /etc/conf.d/${PN} to add your configuration and type the"
	elog "following command to add it the your defautl runlevel:"
	elog
	elog "    \"rc-update add ${PN} default\""
	elog
}
