# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Maintainer: Zibon Badi

EAPI=8

inherit git-r3

EGIT_REPO_URI="https://github.com/STJr/Kart-Public.git"
EGIT_COMMIT="tags/v${PV}"

DESCRIPTION="A kart racing game based on the 3D Sonic the Hedgehog fangame Sonic Robo Blast 2"
HOMEPAGE="https://mb.srb2.org/threads/srb2kart.25868/"
#SRC_URI="https://github.com/STJr/Kart-Public/releases/download/v${PV}/srb2kart-v${PV//./}-Installer.exe"
SRC_URI="https://github.com/STJr/Kart-Public/releases/download/v${PV}/AssetsLinuxOnly.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

#S="${WORKDIR}/${P}"
#S="${WORKDIR}/Kart-Public-${PV}"

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
	app-arch/p7zip
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

src_unpack(){
	unpack ${A}
	git-r3_src_unpack
	7z x "${DISTDIR}/srb2kart-v${PV//./}-Installer.exe"
}

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

	SYSFLAG="LINUX"
	if use amd64 || use arm64 ;then SYSFLAG="LINUX64"
	fi
	emake CPPFLAGS+="-D_FORTIFY_SOURCE=0" SYSFLAG=1 NOUPX=1 NOVERSION=1 ${OPTIONS}

}

src_install(){
	ARCHDIR="Linux"
	if use amd64 || use arm64 ;then
		ARCHDIR="Linux64"
	fi

	# Binary
	install -Dm755 bin/$ARCHDIR/Release/lsdl2srb2kart "${D}"/usr/bin/srb2kart

	# Game data
	install -d "${D}"/usr/share/games/SRB2Kart
	install -m644 ../{textures,gfx,music,sounds,chars,bonuschars,maps,patch}.kart ../srb2.srb ../mdls.dat -t "${D}"/usr/share/games/SRB2Kart/

	cp -r --preserve=mode,timestamps ../mdls  -t "${D}"/usr/share/games/SRB2Kart

	# icon + .desktop
	install -Dm644 src/sdl/SDL_icon.xpm "${D}"/usr/share/pixmaps/srb2kart.xpm
	install -Dm644 "${FILESDIR}/srb2kart.desktop" "${D}"/usr/share/applications/srb2kart.desktop
}
