# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1

DESCRIPTION="A simple URL shortening Python Lib, implementing the most famous shorteners."
HOMEPAGE="https://github.com/ellisonleao/pyshorteners/"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ellisonleao/${PN}.git"
else
	SRC_URI="https://github.com/ellisonleao/${PN}/archive/${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="dev-python/requests"
DEPEND="${RDEPEND}
	test? (
		dev-python/mock
		dev-python/flake8
		dev-python/nose
	)"

RESTRICT="test"

python_prepare(){
	# tests currently fail because there is no newline at the end of this file
	sed -i -e '$a\' tests/test_shorteners.py
	default
}

# tests run, but fail horribly
python_test() {
	make test
}
