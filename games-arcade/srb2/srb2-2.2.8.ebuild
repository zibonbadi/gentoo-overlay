# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Maintainer: Zibon Badi
# Based on the 2.2.8 PKGBUILD script by JJK16 ( https://gist.github.com/JJK96/106257f93e3a67813075d169a1ac9fb4 )

EAPI=7

DESCRIPTION="A 3D Sonic fan game based off of Doom Legacy (aka \"Sonic Robo Blast 2\")"
HOMEPAGE="http://www.srb2.org/"
SRC_URI="https://github.com/STJr/SRB2/archive/SRB2_release_${PV}.tar.gz https://github.com/STJr/SRB2/releases/download/SRB2_release_${PV}/SRB2-v${PV}-Full.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

#S="${WORKDIR}/${P}"
S="${WORKDIR}/SRB2-SRB2_release_${PV}"

RDEPEND="
	sdl2? ( media-libs/libsdl2 )
	image? ( media-libs/sdl2-image )
	mixer? ( media-libs/sdl2-mixer )
	png? ( media-libs/libpng )
	openmpt? ( media-libs/libopenmpt )
	gme? ( media-libs/game-music-emu )
	curl? ( net-misc/curl )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/unzip
	opengl? ( media-libs/mesa media-libs/glu )
	yasm? ( dev-lang/yasm )
	nasm? ( dev-lang/nasm )
"

IUSE="+sdl2 +image +mixer +curl +png nls opengl openmpt gme +nasm -yasm +zlib"
REQUIRED_USE="
	x86? ( ?? ( yasm nasm ) )
	amd64? ( ?? ( yasm nasm ) )
	image? ( sdl2 )
	mixer? ( sdl2 )
"

src_compile(){

	OPTIONS=""
	cd "src"

	if use image ;then
		OPTIONS="${OPTIONS} SDL_IMAGE=1"
	fi
	if ! use mixer ;then
		OPTIONS="${OPTIONS} NOMIXER=1"
	fi
	if ! use opengl ;then
		OPTIONS="${OPTIONS} NOHW=1"
	fi
	if ! use curl  ;then
		OPTIONS="${OPTIONS} NOCURL=1"
	fi
	if ! use png  ;then
		OPTIONS="${OPTIONS} NOPNG=1"
	fi
	if ! use gme ;then
		OPTIONS="${OPTIONS} NOGME=1"
	fi
	if ! use openmpt ;then
		OPTIONS="${OPTIONS} NOOPENMPT=1"
	fi
	if ! use nls ;then
		OPTIONS="${OPTIONS} NOGETTEXT=1"
	fi
	if ! use zlib ;then
		OPTIONS="${OPTIONS} NOZLIB=1"
	fi

	IS64BIT=""
	if use amd64 || use arm64 ;then IS64BIT="64"
	fi
	# do not upx binary, do not use version script (optional: show warnings, be verbose)
	emake CPPFLAGS+="-D_FORTIFY_SOURCE=0" LINUX$IS64BIT=1 NOUPX=1 NOVERSION=1 ${OPTIONS} #WARNINGMODE=1 ECHO=1

}

src_install(){
	ARCHDIR="Linux"
	if use amd64 || use arm64 ;then
		ARCHDIR="Linux64"
	fi

	# Binary
	install -Dm755 bin/$ARCHDIR/Release/lsdl2srb2 "${D}"/usr/bin/srb2

	# Game data
	install -d "${D}"/usr/share/games/SRB2
	install -d "${D}"/usr/share/games/SRB2/models
	install -m644 ../{player,music}.dta ../{srb2,zones,patch_music,patch}.pk3 ../models.dat -t "${D}"/usr/share/games/SRB2/
	cp -r -p=mode,timestamps ../models  -t "${D}"/usr/share/games/SRB2/models

	# icon + .desktop
	install -Dm644 src/sdl/SDL_icon.xpm "${D}"/usr/share/pixmaps/srb2.xpm
	install -Dm644 "${FILESDIR}/srb2.desktop" "${D}"/usr/share/applications/srb2.desktop
}
