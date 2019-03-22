# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_5,3_6} )
inherit distutils-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/iheanyi/${PN}"
else
	inherit versionator
	MY_PV="$(replace_version_separator 3 '-')"
	SRC_URI="https://github.com/iheanyi/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="Simple python script to download Bandcamp albums"
HOMEPAGE="https://github.com/iheanyi/bandcamp-dl"

LICENSE="Unlicense"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/demjson[${PYTHON_USEDEP}]
	dev-python/docopt[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/unicode-slugify[${PYTHON_USEDEP}]
	media-libs/mutagen[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
