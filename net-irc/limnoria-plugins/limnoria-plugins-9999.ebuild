# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit python-r1 git-r3

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
RDEPEND="|| (
		net-irc/limnoria
		net-irc/supybot
	)
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/django[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/python-twitter[$(python_gen_usedep 'python2_7')]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/pygraphviz[$(python_gen_usedep 'python2_7')]
	dev-python/oauth2[$(python_gen_usedep 'python2_7')]"

pkg_setup() {
	git-r3_pkg_setup
	python_setup
}

src_unpack() {
	git-r3_src_unpack
}

src_install() {
	installation() {
		for plugin in *; do
			[[ -d ${plugin} ]] || continue #skip over non-plugin files
			case ${plugin} in
				Twitter|WebStats)
					# These plugins only work in python 2
					if python_is_python3; then
						continue
					fi
					;;
				MegaHAL|GUI)
					# Omitted by maintainer decision
					continue
					;;
				*)
					;;
			esac

			insinto $(python_get_sitedir)/supybot/plugins/${plugin}
			doins ${plugin}/*
		done
	}
	python_foreach_impl installation || die "Plugin Installation failed"
}

python_test() {
	SUPYBOT_TEST=`which supybot-test`
	EXCLUDE_PLUGINS=( --exclude="./NoLatin1" ) # recommended by upstream
	EXCLUDE_PLUGINS+=( --exclude="./MegaHAL" --exclude="./GUI" ) # Omitted by maintainer decision
	if python_is_python3; then
		EXCLUDE_PLUGINS+=( --exclude="./Twitter" ) # python-twitter and oauth2 are py2 only
		EXCLUDE_PLUGINS+=( --exclude="./WebStats" ) # pygraphviz is py2 only
	fi
	PYTHONPATH="${PYTHONPATH}:."
	"${PYTHON}" "${SUPYBOT_TEST}" test --plugins-dir="." --no-network --disable-multiprocessing
}

src_test() {
	python_foreach_impl python_test || die "Testing failed"
}

pkg_postinst() {
	python_mod_optimize supybot/plugins
	ewarn "Many plugins require functionality that is only available for"
	ewarn "net-irc/limnoria, so support for the use of this pkg with"
	ewarn "net-irc/supybot will be limited."
}

pkg_postrm() {
	python_mod_cleanup supybot/plugins
}
