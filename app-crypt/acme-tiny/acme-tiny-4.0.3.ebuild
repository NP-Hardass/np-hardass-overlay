# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
inherit distutils-r1 eapi7-ver

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/diafygi/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/diafygi/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

ACME_GENTOO_V="20180320"
ACME_GENTOO="${PN}-gentoo-${ACME_GENTOO_V}"
SRC_URI="${SRC_URI}
	script? ( https://dev.gentoo.org/~np-hardass/distfiles/${PN}/${ACME_GENTOO}.tar.gz )"

DESCRIPTION="A tiny, auditable script for Let's Encrypt's ACME Protocol"
HOMEPAGE="https://github.com/diafygi/acme-tiny"

LICENSE="MIT"
SLOT="0"

IUSE="script"

DEPEND="dev-python/setuptools_scm[${PYTHON_USEDEP}]"
RDEPEND="
	script? (
		net-misc/wget
	)
	dev-libs/openssl:0"

pkg_setup() {
	if [[ ${PV} != 9999 ]]; then
		export SETUPTOOLS_SCM_PRETEND_VERSION="${PV}"
	fi
}

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	fi
	default
}

src_prepare() {
	sed -i 's|#!/usr/bin/sh|#!/bin/sh|g' README.md || die

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
	for v in ${REPLACING_VERSIONS}; do
		if ver_test "$v" "-lt" "4.0.3" || ver_test "$v" "-ge" "9999"; then
			einfo "The --account-email flag has been changed to --contact and"
			einfo "has different syntax."
			einfo "Please update your scripts and/or configs accordingly"
		fi
	done

	if use script; then
		einfo "To use the cron script, cp /etc/acme-tiny.conf{.sample,}"
		einfo "and customize the config to suite your machine"
	fi
}
