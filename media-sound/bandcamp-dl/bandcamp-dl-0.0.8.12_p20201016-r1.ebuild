# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_6,3_7,3_8,3_9} )
inherit distutils-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/iheanyi/${PN}"
elif [[ ${PV} =~ _p ]]; then
	SHA="0b9ce91621f3c1c0886091c44543db974a02d55d"
	SRC_URI="https://github.com/iheanyi/${PN}/archive/${SHA}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${SHA}"
else
	inherit eapi7-ver
	MY_PV="$(vers_rs 3 '-')"
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
	dev-python/python-slugify[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	media-libs/mutagen[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
