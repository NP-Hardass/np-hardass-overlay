# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit vcs-snapshot autotools

DESCRIPTION="Provides a GTK applet for managing internet connections with
Connman"
HOMEPAGE="https://github.com/tbursztyka/connman-ui"
SRC_URI="${HOMEPAGE}/archive/master.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.28
	    >=sys-apps/dbus-1.4
	    >=x11-libs/gtk+-3.0:3
	    >=net-misc/connman-1.0"

src_prepare() {
    eautoreconf
}

