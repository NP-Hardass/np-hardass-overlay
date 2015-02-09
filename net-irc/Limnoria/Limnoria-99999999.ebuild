# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

MY_PV="${PV:0:4}-${PV:4:2}-${PV:6:2}"

if [[ ${PV} == "99999999" ]]; then
	EGIT_REPO_URI="git://github.com/ProgVal/Limnoria.git"
	EGIT_BRANCH="master"
	inherit git-r3
	SRC_URI=""
else
	SRC_URI="https://github.com/ProgVal/${PN}/archive/master-${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/Limnoria-master-${MY_PV}"
fi

DESCRIPTION="Python based extensible IRC infobot and channel bot"
HOMEPAGE="http://supybot.aperio.fr/"
LICENSE="BSD"
SLOT="0"
IUSE="crypt test"

RDEPEND="
	dev-python/charade[${PYTHON_USEDEP}]
	dev-python/ecdsa[${PYTHON_USEDEP}]
	dev-python/feedparser[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/socksipy[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
	crypt? ( dev-python/python-gnupg[${PYTHON_USEDEP}] )
	!net-irc/supybot
	!net-irc/supybot-plugins
	"
DEPEND="${RDEPEND}
	test? ( dev-python/mock[${PYTHON_USEDEP}] )"

DOCS="ACKS RELNOTES ChangeLog README.md"

src_unpack() {
	if [[ ${PV} == "99999999" ]]; then
		git-r3_src_unpack
	else
		unpack ${P}.tar.gz
	fi
}

src_install() {
	distutils-r1_src_install
	doman man/* || die "doman failed"
}

python_test() {
	PLUGINS_DIR="${BUILD_DIR}/lib/supybot/plugins"
	EXCLUDE_PLUGINS=( --exclude="${PLUGINS_DIR}/Scheduler" ) # recommended by upstream
	EXCLUDE_PLUGINS+=( --exclude="${PLUGINS_DIR}/Filter" ) # recommended by upstream
	EXCLUDE_PLUGINS+=( --exclude="${PLUGINS_DIR}/Unix" ) # We seem to have sandbox issues with this one
	"${PYTHON}" ./scripts/supybot-test test --plugins-dir="${PLUGINS_DIR}" --no-network --disable-multiprocessing "${EXCLUDE_PLUGINS[@]}"
}

pkg_postinst() {
	elog "Complete user documentation is available at https://limnoria-doc.readthedocs.org/"
	elog ""
	elog "Use supybot-wizard to create a configuration file."
	elog ""
	elog "There are additional plugins available in net-im/limnoria-plugins"
	elog ""
}
