# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info toolchain-funcs

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/IntelRealSense/${PN}.git"
else
	SRC_URI="https://github.com/IntelRealSense/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Intel's RealSense 3D Camera API"
HOMEPAGE="https://github.com/IntelRealSense/librealsense"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+examples"

RDEPEND="
	virtual/libusb:1
	examples? ( =media-libs/glfw-3* )
"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers
	virtual/pkgconfig
"

CONFIG_CHECK="USB_VIDEO_CLASS"
ERROR_USB_VIDEO_CLASS="librealsense requires CONFIG_USB_VIDEO_CLASS enabled."

DOCS=( AUTHORS CLA.md CONTRIBUTING.md readme.md )

pkg_pretend() {
	kernel_is ge 4 4 || die "Upstream has deprecated support for kernels < 4.4."

	if tc-is-gcc && [[ gcc-version < 4.9 ]]; then
		die "Upstream requires at least GCC-4.9"
	fi
}

src_compile() {
	if use examples; then
		emake
	else
		emake library
	fi
}

src_install() {
	einstalldocs

	insinto /usr/$(get_libdir)
	doins lib/librealsense.so

	insinto /lib/udev/rules.d/
	doins config/99-realsense-libusb.rules

	insinto /usr/share/${PF}
	doins scripts/realsense-camera-formats.patch

	if use examples; then
		insinto /usr/share/${PF}/examples/src
		doins examples/*
		insinto /usr/share/${PF}/examples/bin
		insopts -m755
		doins bin/*
	fi
}

pkg_postinst() {
	ewarn "${PN} requires a patched usbvideo.ko to work properly. The patch is"
	ewarn "${EROOT%/}/usr/share/${PF}/realsense-camera-formats.patch"
	ewarn "This patch may be applied manually or autoapplied by copying it to"
	ewarn "/etc/portage/patches/sys-kernel/gentoo-sources"
}
