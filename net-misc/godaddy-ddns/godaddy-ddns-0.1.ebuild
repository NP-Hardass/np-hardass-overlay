# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_4,3_5} )
inherit python-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/CarlEdman/${PN}"
else
	SRC_URI="https://github.com/CarlEdman/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A script for dynamically updating a Godaddy DNS record"
HOMEPAGE="https://github.com/CarlEdman/godaddy-ddns"

LICENSE="Unlicense"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${PYTHON_DEPS}
	dev-python/urllib3[${PYTHON_USEDEP}]"

src_install(){
	default
	python_foreach_impl python_newscript ${PN/-/_}.py ${PN}
}
