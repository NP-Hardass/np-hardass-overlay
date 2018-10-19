# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Native Launcher for EVE Online"
HOMEPAGE="https://eveonline.com"
SRC_URI="https://binaries.eveonline.com/${PN/-/}-${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN/-/}"

RESTRICT="mirror bindist strip"

LICENSE="EVE-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

QA_PREBUILT="/opt/CCP/${PN}/*"

src_install(){
	insinto /opt/CCP/${PN}
	doins -r *

	# Fix perms from insinto
	fperms +x /opt/CCP/${PN}/{${PN/-/},LogLite}{,.sh}
	fperms +x /opt/CCP/${PN}/QtWebEngineProcess
	find "${D}/opt/CCP/${PN}" -type f -name '*.so*' -exec chmod +x {} \+ || die

	doicon "${FILESDIR}/${PN}.png"
	make_desktop_entry /opt/CCP/${PN}/${PN/-/}.sh "EVE Online Launcher"
}
