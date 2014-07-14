# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils multilib

DESCRIPTION="A browser plugin which allows one to use windows-only plugins inside Linux browsers."
HOMEPAGE="http://fds-team.de/cms/index.html https://launchpad.net/pipelight"

#this will need to be set on a per version basis
S="${WORKDIR}/mmueller2012-pipelight-e2362eb15df6"

SRC_URI="https://bitbucket.org/mmueller2012/pipelight/get/v${PV}.tar.gz -> ${P}.tar.gz"
#	binary-pluginloader? ( http://repos.fds-team.de/pluginloader/v${PV}/pluginloader.tar.gz -> pluginloader-prebuilt-${PV}.tar.gz )"

LICENSE="GPL-2 LGPL-2.1 MPL-1.1"
SLOT="0"
KEYWORDS="amd64 ~x86"

LOCKED_PLUGINS="
	adobereader
	foxitpdf
	grandstream
	hikvision
	npactivex
	shockwave
	vizzedrgr
	viewright-caiway
	triangleplayer
	x64-unity3d
	x64-flash
"
UNLOCKED_PLUGINS="
	flash
	silverlight4
	silverlight5.0
	silverlight5.1
	unity3d
"
DEFAULT_PLUGINS="
	+silverlight5.0
	+silverlight5.1
	+unity3d
"
ALL_PLUGINS="
	${LOCKED_PLUGINS}
	${UNLOCKED_PLUGINS}
"
ALL_PLUGINS=`echo ${ALL_PLUGINS} | tr " " "\n"  | sort`

IUSE="+binary-pluginloader installation-dialogs static ${ALL_PLUGINS} ${DEFAULT_PLUGINS}"

DEPEND="!binary-pluginloader? ( cross-i686-w64-mingw32/gcc[cxx] )"
RDEPEND="${DEPEND}
	app-arch/cabextract
	>=app-emulation/wine-1.7.19-r1[abi_x86_32,pipelight]
	x11-apps/mesa-progs"

src_prepare() {
	# Just in case someone runs 'emerge -O pipelight'
	if use !binary-pluginloader ; then
		if ! has_version "cross-i686-w64-mingw32/gcc" ; then
			eerror
			eerror "In order to compile pluginloader.exe, you must have an appropriate cross compiler installed."
			eerror
			eerror "Run 'emerge -v crossdev'"
			eerror "Then run 'crossdev -t i686-w64-mingw32'"
			eerror
			eerror "Otherwise, emerge pipelight with the binary-pluginloader USE flag enabled."
			eerror
			die
		fi
	fi

	if use binary-pluginloader; then
		tar xf ${S}/pluginloader-${PV}.tar.gz -C ${S}
	fi

	# Makefiles don't seem to work on releases, only on git commits
	# Fix broken makefiles
	sed -i "s/^commit=.*/commit=v${PV}/" ${S}/src/*/Makefile
}

src_configure() {

	local myargs
	if use binary-pluginloader; then
		myargs="${myargs} --win32-prebuilt"
	elif use !binary-pluginloader; then
		if use static; then
			myargs="${myargs} --win32-static"
		else
			myargs="${myargs} --gcc-runtime-dlls=/usr/$(get_libdir)/gcc/i686-w64-mingw32/$(gcc -v |& grep 'gcc version' | awk '{print $3}')"
		fi
	fi
	if use installation-dialogs; then
		myargs="${myargs} --show-installation-dialogs"
	fi

	# We're not using econf because this is not an autotools configure script
	./configure \
		--prefix=/usr \
		--wine-path=/usr/bin/wine \
		--moz-plugin-path=/usr/$(get_libdir)/nsbrowser/plugins/ \
		${myargs}

}

src_install() {
	default
	#licenses.txt is taken from src/linux/basicplugin.c in the pipelight source code.
	dodoc ${FILESDIR}/licenses.txt debian/changelog
}

pkg_postinst() {
	einfo "Running update script..."
	pipelight-plugin --update

	einfo "Creating copies of libpipelight.so..."
	pipelight-plugin --create-mozilla-plugins
	ln -sf /usr/$(get_libdir)/pipelight/libpipelight.so /usr/$(get_libdir)/nsbrowser/plugins/libpipelight.so

	# Unlock all plugins selected by use flags
	plugins=($LOCKED_PLUGINS)
	for plugin in ${plugins[@]}
	do
		use $plugin && pipelight-plugin --unlock-plugin $plugin
		#pipelight-plugin --unlock-plugin $plugin
	done
	
	einfo "Enabling plugins..."
    # Setup symlinks to enable plugins based on USE flags
	plugins=($ALL_PLUGINS)
	for plugin in ${plugins[@]}
	do
		#use "$plugin" && pipelight-plugin --enable $plugin && ln -sf /usr/$(get_libdir)/pipelight/libpipelight-$plugin.so /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-$plugin.so
		#This avoids manual license checking for plugins enabled with use flags
		use "$plugin" && ln -sf /usr/$(get_libdir)/pipelight/libpipelight-$plugin.so /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-$plugin.so
	done

	echo
	elog "When you first start your browser after installing Pipelight, Pipelight will    "
	elog "download and install any enabled plugins. This may take a few minutes to        "
	elog "complete.                                                                       "
	elog
	elog "Some web sites will check what operating system you are using and will not      "
	elog "function properly if they detect Linux. For these sites, you will need to       "
	elog "install and enable a user agent string editor. The user agent string            "
	elog "recommended by upstream for many Silverlight apps is                            "
	elog "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120427 Firefox/15.0a1      "
	elog "and for many Unity 3D apps is                                                   "
	elog "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/534.55.3 (KHTML, like"
	elog " Gecko) Version/5.1.3 Safari/534.53.10                                          "
	elog "See https://answers.launchpad.net/pipelight/+faq/2351 for more information.     "
	elog
	elog "GPU acceleration is not enabled by default for all graphics cards. See          "
	elog "https://answers.launchpad.net/pipelight/+faq/2364 for more information.         "
	echo
}

pkg_prerm() {
	einfo "Removing copies of libpipelight.so..."
	pipelight-plugin --remove-mozilla-plugins

	einfo "Disabling plugins..."
	
	plugins=($ALL_PLUGINS)
	for plugin in ${plugins[@]}
	do
		pipelight-plugin --disable $plugin
		if [ -h /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-$plugin.so ] ; then
			rm /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-$plugin.so
		fi
	done
}
