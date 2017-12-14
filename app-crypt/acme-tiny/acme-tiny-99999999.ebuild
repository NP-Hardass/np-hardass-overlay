# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
inherit distutils-r1

if [[ ${PV} == 99999999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/diafygi/${PN}.git"
	KEYWORDS=""
else
	HASH="4ed13950c0a9cf61f1ca81ff1874cde1cf48ab32"
	SRC_URI="https://github.com/diafygi/${PN}/archive/${HASH}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${HASH}"
fi

ACME_GENTOO_V="20170626"
ACME_GENTOO="${PN}-gentoo-${ACME_GENTOO_V}"
SRC_URI="${SRC_URI}
	script? ( https://dev.gentoo.org/~np-hardass/distfiles/${PN}/${ACME_GENTOO}.tar.gz )"

DESCRIPTION="A tiny, auditable script for Let's Encrypt's ACME Protocol"
HOMEPAGE="https://github.com/diafygi/acme-tiny"

LICENSE="MIT"
SLOT="0"

IUSE="minimal script"

DEPEND="dev-python/setuptools_scm[${PYTHON_USEDEP}]"
RDEPEND="
	script? (
		net-misc/wget
	)
	dev-libs/openssl:0"

REQUIRED_USE="minimal? ( !script )"

PATCHES=( "${FILESDIR}/${PN}-PR50-setup.py.patch" )

pkg_setup() {
	if [[ ${PV} != 99999999 ]]; then
		export SETUPTOOLS_SCM_PRETEND_VERSION="0.1.dev79+n${HASH:0:7}.d$(date +%Y%m%d)"
	fi
}

src_unpack() {
	if [[ ${PV} == 99999999 ]]; then
		git-r3_src_unpack
	fi
	default
}

src_prepare() {
	if ! use minimal; then
		PATCHES+=(
			"${FILESDIR}/${PN}-PR87-readmefix.patch"
			"${FILESDIR}/${PN}-PR101-contactinfo.patch"
		)
	fi
	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install
	if use script; then
		exeinto /etc/cron.monthly
		doexe "${WORKDIR}/acme-tiny-gentoo/acme-tiny-renew-certs"

		insinto /etc/
		doins "${WORKDIR}/acme-tiny-gentoo/acme-tiny.conf.sample"
	fi
}

pkg_postinst() {
	if use script; then
		einfo "To use the cron script, cp /etc/acme-tiny.conf{.sample,}"
		einfo "and customize the config to suite your machine"
	fi
}
