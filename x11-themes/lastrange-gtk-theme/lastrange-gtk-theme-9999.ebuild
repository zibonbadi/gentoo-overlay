# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Maintainer: Zibon Badi

EAPI=7
inherit git-r3

DESCRIPTION="A clean, simple GTK/XFCE theme for easy and focused computing."
HOMEPAGE="https://github.com/zibonbadi/lastrange-gtk-theme"

EGIT_REPO_URI="https://github.com/zibonbadi/lastrange-gtk-theme"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND=""
DEPEND="${RDEPEND}"
BDEPEND=""

IUSE=""
REQUIRED_USE=""

src_install(){
	insinto "/usr/share/themes"
	doins -r LaStrange/ LaStrange_Borderless/ LaStrange-industrial/ LaStrange-solarized/
}
