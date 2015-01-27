# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python based extensible IRC infobot and channel bot"
HOMEPAGE="http://supybot.aperio.fr/"
if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://github.com/ProgVal/Limnoria.git"
	EGIT_BRANCH="master"
	inherit git-r3
	SRC_URI=""
else
	SRC_URI=""#TODO
	KEYWORDS="amd64 ~arm ppc ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
fi

LICENSE="BSD"
SLOT="0"
IUSE="crypt encoding plugins test time twisted"

DEPEND="
	dev-python/ecdsa[${PYTHON_USEDEP}]
	dev-python/feedparser[${PYTHON_USEDEP}]
	dev-python/socksipy[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
	crypt? ( dev-python/python-gnupg[${PYTHON_USEDEP}] )
	encoding? ( dev-python/charade[${PYTHON_USEDEP}] )
	plugins? ( net-irc/supybot-plugins )
	time? (
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
	)
	twisted? (
		>=dev-python/twisted-core-8.1.0[crypt]
		>=dev-python/twisted-names-8.1.0
	)
	!net-irc/supybot
	!<net-irc/supybot-plugins-9999
	"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	test? ( dev-python/mock[${PYTHON_USEDEP}] )"

DOCS="ACKS RELNOTES docs/[!man]*"

src_unpack() {
	if [[ ${PV} == "9999" ]]; then
		git-r3_src_unpack
	else
		unpack ${P}.tar.gz
	fi
}

src_install() {
	distutils-r1_src_install
	doman docs/man/* || die "doman failed"
}

pkg_postinst() {
	elog "Use supybot-wizard to create a configuration file."
	if use twisted; then
		elog "If you want to use Twisted as your supybot.driver, add it to your config file:"
		elog "supybot.drivers.module = Twisted"
	else
		elog "To allow supybot to use Twisted as driver, reinstall supybot with \"twisted\" USE flag enabled."
	fi
	elog "You will need this for SSL connections."
}
