# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit eutils games java-pkg-2

DESCRIPTION="A Minecraft launcher. Customize parameters, easily
load/unload mods, manage multiple MC versions"
HOMEPAGE="http://www.magiclauncher.com"
SRC_URI="http://www.magiclauncher.com/download.php?f=MagicLauncher_${PV}.jar -> $P.jar"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="mirror"

DEPEND=""

RDEPEND="games-action/minecraft
	|| ( 
		>=dev-java/icedtea-6[X]
		>=dev-java/icedtea-bin-6[X]
		>=dev-java/oracle-jre-bin-1.6[X]
		>=dev-java/oracle-jre-bin-1.6[X]
	)"

S="${WORKDIR}"

pkg_setup() {
	java-pkg-2_pkg_setup
	games_pkg_setup
}

src_install() {
	java-pkg_register-dependency minecraft
	java-pkg_dojar "${PN}.jar"

	# Launching with -jar seems to create classpath problems.
	java-pkg_dolauncher "${PN}" -into "${GAMES_PREFIX}"

	doicon "${FILESDIR}/${PN}.png" || die
	make_desktop_entry "${PN}" "MagicLauncher"

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}
