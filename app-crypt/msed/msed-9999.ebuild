# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="	git://github.com/r0m30/msed.git
					https://github.com/r0m30/msed.git
					git://github.com/NP-Hardass/msed.git
					https://github.com/NP-Hardass/msed.git"
else
	SRC_URI="https://github.com/r0m30/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${P}"
fi

DESCRIPTION="Managing Self Encrypting Drives
			Open source SED management and Pre-boot Authorization image"
HOMEPAGE="http://www.r0m30.com/msed/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug"

DEPEND="dev-libs/crypto++"

RDEPEND="${DEPEND}"

set_target() {
	if use debug ; then
		_REL=Debug
	else
		_REL=Release
	fi
	if use amd64 ; then
		_ARCH=x86_64
	elif use x86; then
		_ARCH=x86
	else
		die "Unknown keyword"
	fi
	_TARGET="${_REL}_${_ARCH}"
}

src_compile() {
	set_target
	emake CONF=${_TARGET} build || die
}

src_install() {
	set_target
	dobin dist/${_TARGET}/msed
}
