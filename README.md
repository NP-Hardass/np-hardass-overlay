Welcome to NP-Hardass' Gentoo Overlay!
======================================

Repoman Status: [![Build Status](https://travis-ci.org/NP-Hardass/np-hardass-overlay.svg?branch=master)](https://travis-ci.org/NP-Hardass/np-hardass-overlay)

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
| [app-crypt/msed](app-crypt/msed)						| Manage Self Encrypting Drive tool and Pre-Boot-Authentication Image	| I am the author and maintainer of this ebuild					|
| [app-laptop/dellfand](app-laptop/dellfand)					| Dell laptop fan regulator						| Copied from foo-overlay							|
| [games-action/minecraft](games-action/minecraft)				| A cube based sandbox game						| Copied from Sabayon, fixed icedtea-bin dependency issue			|
| [games-action/minecraft-magiclauncher](games-action/minecraft-magiclauncher)	| An alternative launcher for Minecraft					|      										|
| [games-roguelike/dwarf-fortress](games-roguelike/dwarf-fortress)		| A single-player fantasy game						| Copied from Sabayon, version bump + amd64 fix					|
| [media-sound/pithos](media-sound/pithos)					| A Python GTK Pandora Internet Radio Client				| Copied from Gentoo, version bump + dependency fixes				|
| [net-misc/gopenvpn](net-misc/gopenvpn)					| GTK GUI for OpenVPN							| Currently has a bug(upstream), editing configurations in the GUI doesn't work	|
| [net-misc/linuxptp](net-misc/linuxptp)					| Precision Time Protocol application					| Copied from rion								|
| [sys-apps/915resolution](sys-apps/915resolution)				| Utility to patch VBIOS of Intel Chipsets				| Copied from Gentoo								|
| [sys-apps/gprename](sys-apps/gprename)					| Perl GUI for batch file/folder renaming				| Copied from BGO, version bump							|
| [www-client/palemoon](www-client/palemoon)					| A Firefox fork							| Copied from farmboy0, version bump						|
| [x11-themes/shiki-colors](x11-themes/shiki-colors)				| Shiki-Colors theme for Gnome						| Copied from Gentoo, MATE dependency hacks					|

Installation
------------

Layman allows for the easy management of overlays.

If you haven’t used layman yet, just run these commands:

	emerge -av layman
	echo PORTDIR_OVERLAY=\"\" >> /etc/portage/make.conf
	echo "source /var/lib/layman/make.conf" >> /etc/make.conf
	layman -f


Then you can add this overlay with:

	layman -o https://raw.githubusercontent.com/NP-Hardass/np-hardass-overlay/master/overlays.xml -f -a np-hardass-overlay

Or the easier to type:

	layman -o https://git.io/xnmB -f -a np-hardass-overlay

To sync the overlay via layman:

	layman -s np-hardass-overlay

To delete the overlay:

	layman -d np-hardass-overlay
