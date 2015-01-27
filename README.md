Welcome to NP-Hardass' Gentoo Overlay!
======================================

Important Note
--------------
This overlay contains some system packages like glibc.  As such, you should
probably consider this overlay to be "unsafe" and treat it as such.
To do so for an example package `cat-egory/pkgname`:
	# echo "*/*::np-hardass-overlay" >> /etc/portage/package.mask
	# echo "cat-egory/pkgname::np-hardass-overlay" >> /etc/portage/package.unmask

Packages
--------

This is a list of packages and any associated notes:

| Package									| Description								| Notes										|
| ----------------------------------------------------------------------------- | --------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| [app-arch/engrampa](app-arch/engrampa)					| Archive manager for MATE						| Copied from Gentoo, bugfix for USE="-caja"					|
| [app-crypt/msed](app-crypt/msed)						| Manage Self Encrypting Drive tool and Pre-Boot-Authentication Image	| I am the author and maintainer of this ebuild					|
| [app-emulation/wine](app-emulation/wine)					| Free implementation of Windows(tm) on Unix				| Copied from Gentoo, wine-staging and live fixes, version bumps		|
| [app-emulation/winetricks](app-emulation/winetricks)				| A tool for managing wine DLLs						| Copied from Gentoo, MATE dependency hacks					|
| [app-laptop/dellfand](app-laptop/dellfand)					| Dell laptop fan regulator						| Copied from foo-overlay							|
| [games-action/minecraft](games-action/minecraft)				| A cube based sandbox game						| Copied from Sabayon, fixed icedtea-bin dependency issue			|
| [games-action/minecraft-magiclauncher](games-action/minecraft-magiclauncher)	| An alternative launcher for Minecraft					|      										|
| [games-roguelike/dwarf-fortress](games-roguelike/dwarf-fortress)		| A single-player fantasy game						| Copied from Sabayon, version bump + amd64 fix					|
| [gnome-base/gdm](gnome-base/gdm)						| Gnome Desktop Manager							| Copied from Gentoo, maintain old version: Gnome 2 branch			|
| [gnome-base/libgdu](gnome-base/libgdu)					| Gnome Disk Utility libraries						| Copied from Gentoo, maintain old version: Gnome 2 branch			|
| [media-sound/pithos](media-sound/pithos)					| A Python GTK Pandora Internet Radio Client				| Copied from Gentoo, version bump + dependency fixes				|
| [media-video/cheese](media-video/cheese)					| A program for interacting with your webcam				| Copied from Gentoo, MATE dependency hacks					|
| [net-fs/openafs](net-fs/openafs)						| OpenAFS distributed filesystem					| Copied from Gentoo, version bump						|
| [net-fs/openafs-kernel](net-fs/openafs-kernel)				| OpenAFS kernel module							| Copied from Gentoo, version bump						|
| [net-misc/connman-ui-gtk](net-misc/connman-ui-gtk)				| GTK applet for Connman network config tool				| Copied from BGO, live ebuild							|
| [net-misc/gopenvpn](net-misc/gopenvpn)					| GTK GUI for OpenVPN							| Currently has a bug(upstream), editing configurations in the GUI doesn't work	|
| [net-misc/linuxptp](net-misc/linuxptp)					| Precision Time Protocol application					| Copied from rion								|
| [sys-apps/915resolution](sys-apps/915resolution)				| Utility to patch VBIOS of Intel Chipsets				| Copied from Gentoo								|
| [sys-apps/gnome-disk-utility](sys-apps/gnome-disk-utility)			| Utility for analyzing disk usage					| Copied from Gentoo, maintain old version: Gnome 2 branch			|
| [sys-apps/gprename](sys-apps/gprename)					| Perl GUI for batch file/folder renaming				| Copied from BGO, version bump							|
| [sys-apps/glibc](sys-apps/glibc)						| GNU libc6								| Copied from Gentoo, patches for valgrind+strlen issues			|
| [www-client/palemoon](www-client/palemoon)					| A Firefox fork							| Copied from farmboy0, version bump						|
| [www-plugins/pipelight](www-plugins/pipelight)				| A Windows NSPlugin compatibility program				| Copied from sabayon, version bump						|
| [x11-themes/gdm-themes](x11-themes/gdm-themes)				| GDM Themes								| Copied from Gentoo, maintain old version: Gnome 2 branch			|
| [x11-themes/shiki-colors](x11-themes/shiki-colors)				| Shiki-Colors theme for Gnome						| Copied from Gentoo, MATE dependency hacks					|

Installation
------------

Layman allows for the easy management of overlays.

If you haven’t used layman yet, just run these commands:

	emerge -av layman
	echo PORTDIR_OVERLAY=\"\" >> /etc/portage/make.conf
	echo "source /var/lib/layman/make.conf" >> /etc/make.conf
	layman -f


Then you can add this overlay wih:

	layman -o https://raw.githubusercontent.com/NP-Hardass/np-hardass-overlay/master/overlays.xml -f -a np-hardass-overlay

To sync the overlay via layman:

	layman -s np-hardass-overlay

To delete the overlay:

	layman -d np-hardass-overlay
