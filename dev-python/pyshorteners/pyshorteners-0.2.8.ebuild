# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1

DESCRIPTION="A simple URL shortening Python Lib, implementing the most famous shorteners."
HOMEPAGE="https://github.com/ellisonleao/pyshorteners/"
SRC_URI="https://github.com/ellisonleao/pyshorteners/archive/${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	test? ( 
		dev-python/mock
		dev-python/flake8
		dev-python/nose
	)"
DEPEND="${RDEPEND}
	dev-python/requests"

RESTRICT="test"

python_test() {
	make test
}
