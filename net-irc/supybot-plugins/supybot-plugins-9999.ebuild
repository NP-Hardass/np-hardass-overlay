# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit eutils python-r1 git-r3

MY_PN="Supybot-plugins"

DESCRIPTION="Official set of extra plugins for Supybot"
HOMEPAGE="http://supybot.aperio.fr"
SRC_URI=""
EGIT_REPO_URI="git://github.com/ProgVal/${MY_PN}.git"
EGIT_BRANCH="master"

LICENSE="BSD"
SLOT="0"
#KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND=""
RDEPEND="net-irc/Limnoria
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/django[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/python-twitter
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/pygraphviz
	dev-python/oauth2[${PYTHON_USEDEP}]
	>=dev-python/twisted-conch-8.1.0
	>=dev-python/twisted-web-1.0"

src_unpack() {
	git-r3_src_unpack
}

src_install() {
	installation() {
		for plugin in *; do
			case ${plugin} in
				BadWords|Dunno|Success)
					# These plugins are part of supybot-0.83.4 now, so skip them here.
					continue
					;;
				*)
					;;
			esac

			insinto $(python_get_sitedir)/supybot/plugins/${plugin}
			doins ${plugin}/*
		done
	}
	python_execute_function installation
}

pkg_postinst() {
	python_mod_optimize supybot/plugins
}

pkg_postrm() {
	python_mod_cleanup supybot/plugins
}
