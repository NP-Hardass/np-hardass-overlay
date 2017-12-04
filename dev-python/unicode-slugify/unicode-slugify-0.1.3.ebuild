# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 )
inherit distutils-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mozilla/${PN}"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A slug generator that turns strings into unicode slugs"
HOMEPAGE="https://github.com/mozilla/unicode-slugify"

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/unidecode[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"
