# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit rpm

MY_PN="${PN/brother-/}"
MY_PN="${MY_PN/-cups/}"
MY_PN="${MY_PN^^}"
MY_PV="${PV/_p/-}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="CUPS driver for Brother MFC-6490CW"
HOMEPAGE="http://welcome.solutions.brother.com/bsc/public_s/id/linux/en/download_prn.html"
SRC_URI="http://www.brother.com/pub/bsc/linux/dlf/cupswrapper${MY_P}.i386.rpm"
RESTRICT="mirror strip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="net-print/cups
	app-text/psutils
	net-print/brother-${MY_PN,,}-lpr"
DEPEND="net-print/cups"

S="${WORKDIR}"
INSTALL_SCRIPT="${S}/usr/local/Brother/Printer/${MY_PN}/cupswrapper/cupswrapper${MY_PN}-${PV/_p*/}"
PRINTER_MODEL="MFC7860DW"
PPD_PATH="${S}/usr/share/cups/model"
FILTER_PATH="${S}/usr/lib/cups/filter"

src_prepare() {
	local installScriptNew="${S}/install.sh"

	echo '#!/bin/sh' >"${installScriptNew}"

	echo "ppd_file_name=${PPD_PATH}/${PRINTER_MODEL}.ppd" >>"${installScriptNew}"
	sed -n '/cat <<ENDOFPPDFILE/,/ENDOFPPDFILE/p' "${INSTALL_SCRIPT}" >>"${installScriptNew}" || die "Creating PPD file failed"

	echo "brotherlpdwrapper=${FILTER_PATH}/brlpdwrapper${PRINTER_MODEL}" >>"${installScriptNew}"
	sed -n '/cat <<!ENDOFWFILTER!/,/!ENDOFWFILTER!/p' "${INSTALL_SCRIPT}" >>"${installScriptNew}" || die "Creating filter wrapper failed"

	# Overwrite original INSTALL script
	mv "${installScriptNew}" "${INSTALL_SCRIPT}"

	mkdir -p "${PPD_PATH}"
	mkdir -p "${FILTER_PATH}"
	"/bin/sh" "${INSTALL_SCRIPT}" || die "Installation failed"

}

src_configure() {
	if use debug; then
		sed -i -e 's:^\(DEBUG\)=0:\1=1:' "${FILTER_PATH}/brlpdwrapper"* || die "Enabling debug output failed"
	fi
}

src_install() {
	rm -f "${INSTALL_SCRIPT}" || die
	insinto "/usr/local"
	doins -r "usr/local/Brother" || die
	fperms -R 755 "/usr/local/Brother" || die

	insinto "/usr/share/cups"
	doins -r "${PPD_PATH}" || die

	insinto "/usr/libexec/cups"
	doins -r "${FILTER_PATH}" || die
	fperms -R 755 "/usr/libexec/cups/filter" || die
}

pkg_postinst() {
	ewarn "Printer setup required"
	elog "Use the brprintconf_${MY_PN} command to change printer options."
	elog "For example, set the paper type to A4 right after installation"
	elog "otherwise your prints will be misaligned!"
	elog
	elog "To set A4 paper type:"
	elog "	brprintconf_${MY_PN} -pt A4"
	elog "To set quality to 'Fast Normal':"
	elog "	brprintconf_${MY_PN} -reso 300x300dpi"
	elog "To get an overview of all available options:"
	elog "	brprintconf_${MY_PN}"
}
