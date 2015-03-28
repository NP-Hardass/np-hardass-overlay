# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit linux-mod

DESCRIPTION="Kernel module for Highpoint RocketRaid 62x raid cards"
HOMEPAGE="http://www.highpoint-tech.com/USA_new/series_rr600-overview.htm"

MOD="rr62x"
DATE="120601"
REV="1355"
A_DIR="${MOD}-linux-src-v${PV}"

SRC_URI="http://www.highpoint-tech.com/BIOS_Driver/${MOD}/linux/${A_DIR}-${DATE}-${REV}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror"

LICENSE="all-rights-reserved highpoint-rr"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

S="${WORKDIR}/${A_DIR}"

pkg_pretend() {
	if kernel_is gt 2 6 31; then
		ewarn "Upstream has only confirmed that this package compiles for kernel "
		ewarn "versions up to 2.6.31. That said, this package should compile"
		ewarn "kernel versions up to, but not including 3.x"
		ewarn ""
		ewarn "You are free to utilize epatch_user to provide whatever"
		ewarn "support you feel is appropriate, but you will not receive"
		ewarn "support as a result of those changes."
		ewarn ""
		ewarn "Please do not file a bug report about this."
	fi
}

pkg_setup() {
	linux-mod_pkg_setup

	MODULE_NAMES="${MOD}(raid:${S}/product/${MOD}/linux:${S}/product/${MOD}/linux)"
	BUILD_PARAMS="KERNELDIR=${KERNEL_DIR}"
	BUILD_TARGETS="rr62x"
}

src_prepare() {
	#Fix broken version detection
	sed -i -e "s/MAJOR :=.*/MAJOR := ${KV_MAJOR}/g" inc/linux/Makefile.def || die "sed failed"
	sed -i -e "s/MINOR :=.*/MINOR := ${KV_MINOR}/g" inc/linux/Makefile.def || die "sed failed"

	epatch_user
}
