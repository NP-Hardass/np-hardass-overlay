# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit linux-mod flag-o-matic

DESCRIPTION="Kernel module for Highpoint RocketRaid 62x raid cards"
HOMEPAGE="http://www.highpoint-tech.com/USA_new/series_rr600-overview.htm"

MOD="rr62x"
DATE="130822"
REV="17639"
A_DIR="${MOD}-linux-src-v${PV}"

#SRC_URI="http://www.highpoint-tech.com/BIOS_Driver/${MOD}/linux/${A_DIR}-${DATE}-${REV}.tar.gz -> ${P}.tar.gz"
#Not hosted by upstream anymore, only available via ubuntu
SRC_URI="https://help.ubuntu.com/community/RocketRaid?action=AttachFile&do=get&target=${A_DIR}-${DATE}-${REV}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror"

LICENSE="all-rights-reserved highpoint-rr"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

S="${WORKDIR}/${A_DIR}"

PATCHES=( "${FILESDIR}/${P}-support-kernel-4-Makefile.patch" )

pkg_pretend() {
	if kernel_is gt 3 10 5; then
		ewarn "Upstream has only confirmed that this package compiles for kernel "
		ewarn "versions up to 3.10.5.  That being said, package should compile"
		ewarn "up to, but not including 4.x."
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
	BUILD_TARGETS=" "
}

src_prepare() {
	#Fix broken version detection
	sed -i -e "s/MAJOR :=.*/MAJOR := ${KV_MAJOR}/g" inc/linux/Makefile.def || die "sed failed"
	sed -i -e "s/MINOR :=.*/MINOR := ${KV_MINOR}/g" inc/linux/Makefile.def || die "sed failed"

	#Fix -Werror=date-time
	sed -i 's/ (" __DATE__ " " __TIME__ ")//' product/rr62x/linux/config.c || die "sed failed"

	default
}
