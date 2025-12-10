# $FreeBSD$
#
# bterm - BAUXBSD bterm component
# st with BAUX theming, scaling fonts, and nerd font support

PORTNAME=	bterm
PORTVERSION=	0.1.0
CATEGORIES=	x11
MASTER_SITES=	https://dl.suckless.org/st/
DISTNAME=	st-${PORTVERSION}

MAINTAINER=	baux@roxieos.org
COMMENT=	BAUXBSD bterm - st terminal with scaling fonts and BAUX theming

LICENSE=	MIT
LICENSE_FILE=	${WRKSRC}/LICENSE

LIB_DEPENDS=	libfontconfig.so:x11-fonts/fontconfig \
		libfreetype.so:print/freetype2 \
		libX11.so:x11/libX11 \
		libXft.so:x11-fonts/libXft

USES=		pkgconfig xorg
USE_XORG=	x11

WRKSRC=		${WRKDIR}/st-${PORTVERSION}

# BAUX patches for enhanced functionality
PATCH_SITES=	https://st.suckless.org/patches/
PATCHFILES=	xresources/st-xresources-20230320-45a15676.diff \
		font2/st-font2-0.8.5.diff \
		scrollback/st-scrollback-0.8.5.diff \
		ligatures/st-ligatures-20230105-2c5833f.diff

# Copy BAUX config before building
pre-build:
	${CP} ${FILESDIR}${PREFIX}/share/bterm/config.def.h ${WRKSRC}/config.def.h

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/bin
	${MKDIR} ${STAGEDIR}${PREFIX}/share/bterm
	${INSTALL_PROGRAM} ${WRKSRC}/st ${STAGEDIR}${PREFIX}/bin/bterm
	${INSTALL_DATA} ${FILESDIR}${PREFIX}/share/bterm/config.def.h ${STAGEDIR}${PREFIX}/share/bterm/

.include <bsd.port.mk>