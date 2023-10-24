# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Maintainer: Zibon Badi

EAPI=8

DESCRIPTION="Map creation tool for Sonic Robo Blast 2"
HOMEPAGE="https://git.do.srb2.org/STJr/UltimateZoneBuilder"
SRC_URI="https://git.do.srb2.org/STJr/UltimateZoneBuilder/-/archive/v${PV}/UltimateZoneBuilder-v${PV}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

S="${WORKDIR}/UltimateZoneBuilder-v${PV}"

DOCS=( README )

RDEPEND="
	dev-lang/mono
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/make
	sys-devel/gcc
	dev-lang/mono
	x11-libs/libX11
"

src_install(){
	# Binary
	install -Dm755 Build/builder "${D}"/usr/bin/ultimatezonebuilder

	# icon + .desktop
	install -Dm644 Setup/UZB_small.png "${D}"/usr/share/pixmaps/ultimatezonebuilder.png
	install -Dm644 "${FILESDIR}/ultimatezonebuilder.desktop" "${D}"/usr/share/applications/ultimatezonebuilder.desktop
}
