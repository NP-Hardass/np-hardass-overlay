# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit dotnet

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pfn/${PN}.git"
	SRC_URI="" # Needed due to SRC_URI assignment in dotnet eclass
else
	SRC_URI="https://github.com/pfn/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="KeePass plugin to expose password entries securely (256bit AES/CBC) over HTTP"
HOMEPAGE="https://github.com/pfn/keepasshttp"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND=">=app-admin/keepass-2.20"
RDEPEND="${DEPEND}"

pkg_setup() {
	KPDIR="/usr/$(get_libdir)/keepass"
	dotnet_pkg_setup
}

src_prepare() {
	sed -i "s|<HintPath>C:.*|<HintPath>${KPDIR}/KeePass.exe</HintPath>|" KeePassHttp/KeePassHttp.csproj || die
	default
}

src_compile() {
	xbuild /p:Configuration="Release" /p:Platform="Any CPU" KeePassHttp.sln || die "Compilation failed"
}

src_install() {
	fperms 644 KeePassHttp.plgx
	insinto ${KPDIR}
	doins KeePassHttp.plgx
}

pkg_postinst() {
	elog "Restart KeePass to complete the installation."
}
