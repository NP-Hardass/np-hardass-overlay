# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit games versionator

MY_PV=$(replace_all_version_separators _ "$(get_version_component_range 2-)")
MY_PN=df
MY_P=${MY_PN}_${MY_PV}

DESCRIPTION="A single-player fantasy game"
HOMEPAGE="http://www.bay12games.com/dwarves"
SRC_URI="http://www.bay12games.com/dwarves/${MY_P}_linux.tar.bz2"

LICENSE="Dwarf-Fortress"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE=""
# this is all precompiled and only available at SRC_URI
RESTRICT="strip mirror"

# Almost all of these were determined from ldd'ing the
# binary.  libsndfile, openal, and libXcursor were
# determined from runtime errors in the game
RDEPEND="
	app-arch/bzip2[abi_x86_32]
	dev-libs/atk[abi_x86_32]
	dev-libs/expat[abi_x86_32]
	dev-libs/glib[abi_x86_32]
	dev-libs/libffi[abi_x86_32]
	media-gfx/graphite2[abi_x86_32]
	media-libs/fontconfig[abi_x86_32]
	media-libs/freetype[abi_x86_32]
	media-libs/harfbuzz[abi_x86_32]
	media-libs/libpng:0[abi_x86_32]
	media-libs/libsdl[opengl,video,X,abi_x86_32]
	media-libs/libsndfile[alsa,abi_x86_32]
	media-libs/mesa[abi_x86_32]
	media-libs/openal[abi_x86_32]
	media-libs/sdl-image[png,tiff,jpeg,abi_x86_32]
	media-libs/sdl-ttf[abi_x86_32]
	amd64? ( sys-libs/glibc[multilib] )
	x86? ( sys-libs/glibc )
	sys-libs/zlib[abi_x86_32]
	virtual/glu[abi_x86_32]
	virtual/opengl[abi_x86_32]
	x11-libs/cairo[xcb,X,abi_x86_32]
	x11-libs/gdk-pixbuf[abi_x86_32]
	x11-libs/gtk+:2[xinerama,abi_x86_32]
	x11-libs/libdrm[abi_x86_32]
	x11-libs/libX11[abi_x86_32]
	x11-libs/libXau[abi_x86_32]
	x11-libs/libXcomposite[abi_x86_32]
	x11-libs/libXcursor[abi_x86_32]
	x11-libs/libXdamage[abi_x86_32]
	x11-libs/libXdmcp[abi_x86_32]
	x11-libs/libXfixes[abi_x86_32]
	x11-libs/libXinerama[abi_x86_32]
	x11-libs/libXrender[abi_x86_32]
	x11-libs/libXxf86vm[abi_x86_32]
	x11-libs/libxcb[abi_x86_32]
	x11-libs/libxshmfence[abi_x86_32]
	x11-libs/pango[X,abi_x86_32]
	x11-libs/pixman[abi_x86_32]"
DEPEND=""

S=${WORKDIR}/${MY_PN}_linux

src_install() {
	# install config stuff
	insinto "${GAMES_SYSCONFDIR}"/${PN}
	doins -r data/init/* || die

	# keep saves, movies and objects directories
	keepdir "${GAMES_STATEDIR}"/${PN}/save \
		"${GAMES_STATEDIR}"/${PN}/movies \
		"${GAMES_STATEDIR}"/${PN}/objects || die

	# install data-files and libs
	local gamesdir="${GAMES_PREFIX_OPT}/${PN}"
	insinto "${gamesdir}"
	rm -r data/{movies,init} || die
	doins -r raw data libs || die

	# install our wrapper
	newgamesbin "${FILESDIR}"/${PN}-wrapper ${PN} || die

	# install docs
	dodoc README.linux *.txt || die

	# create symlinks for several directories we want to have 
	# in a different place
	dosym "${GAMES_SYSCONFDIR}"/${PN} "${gamesdir}"/data/init || die
	dosym "${GAMES_STATEDIR}"/${PN}/save "${gamesdir}"/data/save || die
	dosym "${GAMES_STATEDIR}"/${PN}/movies "${gamesdir}"/data/movies || die
	dosym "${GAMES_STATEDIR}"/${PN}/objects "${gamesdir}"/data/objects || die

	prepgamesdirs

	# fix a few permissions
	fperms 0755 \
		"${gamesdir}"/libs/{Dwarf_Fortress,libgcc_s.so.1,libgraphics.so,libstdc++.so.6} || die
	fperms -R g+w "${GAMES_STATEDIR}"/${PN} || die
	fperms g+w "${gamesdir}"/data/index || die
	fperms -R g+w "${gamesdir}"/data/{announcement,dipscript,help} || die
}
