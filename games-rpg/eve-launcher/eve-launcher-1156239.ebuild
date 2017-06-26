# Copyright 1999-2017 Gentoo Foundation
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

src_prepare(){
	# Fails to connect to server without these symlinks
	ln -s libssl-compat.so.1.0.0 libssl.so.1.0.0 || die
	ln -s libssl-compat.so.1.0.0 libssl.so || die
	ln -s libcrypto-compat.so.1.0.0 libcrypto.so.1.0.0 || die
	ln -s libcrypto-compat.so.1.0.0 libcrypto.so || die

	default
}

src_install(){
	insinto /opt/CCP/${PN}
	doins -r *

	# Fix perms from insinto
	fperms +x /opt/CCP/${PN}/{${PN/-/},LogLite}{,.sh}
	fperms +x /opt/CCP/${PN}/QtWebEngineProcess
	find /opt/CCP/${PN} -type f -name "*.so*" -exec fperms +x {} \+ || die

	doicon "${FILESDIR}/${PN}.png"
	make_desktop_entry /opt/CCP/${PN}/${PN/-/}.sh "EVE Online Launcher"
}
