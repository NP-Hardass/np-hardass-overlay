# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/pithos/pithos-20130808.ebuild,v 1.1 2013/08/08 21:24:48 chutzpah Exp $

EAPI=5
inherit eutils

if [[ ${PV} == 9999 ]]; then
	inherit git-2
	EGIT_REPO_URI="	git://github.com/r0m30/msed.git
					https://github.com/r0m30/msed.git
					git://github.com/NP-Hardass/msed.git
					https://github.com/NP-Hardass/msed.git"
else
	SRC_URI="https://github.com/r0m30/${PN}/archive/${PV}beta.tar.gz -> ${P}.tar.gz"	
	S="${WORKDIR}/${P}beta"
fi

DESCRIPTION="Managing Self Encrypting Drives
			Open source SED management and Pre-boot Authorization image"
HOMEPAGE="http://www.r0m30.com/msed/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"

DEPEND="dev-libs/crypto++"

RDEPEND="${DEPEND}"

src_prepare() {
	if ! use debug ; then
		sed -i "s/DEFAULTCONF=Debug/DEFAULTCONF=Release/" nbproject/Makefile-impl.mk || die
	fi
}

src_compile() {
	emake || die
}

src_install() {
	if use debug ; then
		_CONF=Debug
	else
		_CONF=Release
	fi
	if use amd64 ; then
		_ARCH=x86_64
	elif use x86; then
		_ARCH=x86
	else
		die "Unknown keyword"
	fi

	dobin dist/${_CONF}/GNU-Linux-${_ARCH}/msed
}
