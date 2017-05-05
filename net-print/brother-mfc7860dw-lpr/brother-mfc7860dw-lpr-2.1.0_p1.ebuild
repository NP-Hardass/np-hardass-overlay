# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rpm

MY_PN="${PN/brother-/}"
MY_PN="${MY_PN/-lpr/}"
MY_PV="${PV/_p/-}"

DESCRIPTION="LPR driver for Brother MFC-6490CW"
HOMEPAGE="http://welcome.solutions.brother.com/bsc/public_s/id/linux/en/download_prn.html"
SRC_URI="http://www.brother.com/pub/bsc/linux/dlf/${MY_PN}lpr-${MY_PV}.i386.rpm"
RESTRICT="mirror strip"

LICENSE="Brother"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( net-print/cups net-print/lprng )
	app-text/ghostscript-gpl
	app-text/a2ps"
DEPEND=""

S="${WORKDIR}"

src_install() {
	cp -R "${S}"/* "${D}"/ || die "Install failed"
}
