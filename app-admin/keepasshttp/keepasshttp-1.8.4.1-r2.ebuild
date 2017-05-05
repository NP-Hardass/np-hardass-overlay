# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VIRTUALX_REQUIRED="manual"
inherit dotnet mono-env virtualx

MY_PN="KeePassHttp"

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
IUSE="+plgx"

DEPEND="
	plgx? ( ${VIRTUALX_DEPEND} )
	>=app-admin/keepass-2.20"
RDEPEND="${DEPEND}"

pkg_setup() {
	KPDIR="/usr/$(get_libdir)/keepass"
	dotnet_pkg_setup
	mono-env_pkg_setup
}

src_prepare() {
	# Fix HintPath
	sed -i "s|<HintPath>C:.*|<HintPath>${KPDIR}/KeePass.exe</HintPath>|" \
		${MY_PN}/${MY_PN}.csproj || die

	# Remove prebuilt plgx
	rm ${MY_PN}.plgx || die

	default
}

src_compile() {
	if use plgx; then
		virtx mono "${KPDIR}/KeePass.exe" --plgx-create ${MY_PN}
	else
		exbuild ${MY_PN}.sln
	fi
}

src_install() {
	insinto "${KPDIR}"

	if use plgx; then
		doins ${MY_PN}.plgx
	else
		doins ${MY_PN}/bin/Release/*
	fi
}

pkg_postinst() {
	elog "KeePass must be restarted to load the plugin."
}
