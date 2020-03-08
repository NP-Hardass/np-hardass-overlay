# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )
inherit gnome2-utils meson python-r1

if [[ ${PV} =~ [9]{4,} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Pandora.com client for the GNOME desktop"
HOMEPAGE="https://pithos.github.io/"

LICENSE="GPL-3"
SLOT="0"
IUSE="libnotify appindicator +keybinder"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/pylast[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	>=dev-python/pygobject-3.12[${PYTHON_USEDEP}]
	dev-libs/appstream-glib[introspection]
	x11-libs/pango[introspection]
	media-libs/gstreamer:1.0[introspection]
	media-plugins/gst-plugins-meta:1.0[aac,http,mp3]
	>=x11-libs/gtk+-3.14:3[introspection]
	x11-themes/gnome-icon-theme-symbolic
	libnotify? ( x11-libs/libnotify[introspection] )
	appindicator? ( dev-libs/libappindicator:3[introspection] )
	keybinder? ( dev-libs/keybinder:3[introspection] )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

pkg_setup() {
	python_setup
}

src_configure() {
	python_foreach_impl meson_src_configure
}

src_compile() {
	python_foreach_impl meson_src_compile
}

pithos_src_install() {
	pushd "${BUILD_DIR}" || die
	emake DESTDIR="${D}" install
	python_doscript "${D}"/usr/bin/pithos
	popd || die
}

src_install() {
	installing() {
		meson_src_install
		python_optimize
	}
	python_foreach_impl installing
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}
pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}
pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}
