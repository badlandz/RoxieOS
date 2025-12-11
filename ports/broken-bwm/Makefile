# New ports collection makefile for:	bwm
# Date created:		7 Dec 2025
# Whom:			badlandz
#
# $FreeBSD$
#

PORTNAME=	bwm
PORTVERSION=	6.4
CATEGORIES=	x11-wm
MASTER_SITES=	https://dl.suckless.org/dwm/

MAINTAINER=	baux@roxieos.org
COMMENT=	BAUXBSD minimal window manager based on dwm
WWW=		https://roxieos.org

LICENSE=	MIT
LICENSE_FILE=	${WRKSRC}/LICENSE

LIB_DEPENDS=	libfontconfig.so:x11-fonts/fontconfig \
		libX11.so:x11/libX11 \
		libXft.so:x11-fonts/libXft \
		libXinerama.so:x11/libXinerama

USES=		pkgconfig xorg
USE_XORG=	x11

WRKSRC=		${WRKDIR}/dwm-${PORTVERSION}

post-patch:
	${CP} ${FILESDIR}/config.h ${WRKSRC}/config.h
	${CP} ${FILESDIR}/config.mk ${WRKSRC}/config.mk

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/bin
	${INSTALL_PROGRAM} ${WRKSRC}/dwm ${STAGEDIR}${PREFIX}/bin/bwm
	${INSTALL_SCRIPT} ${FILESDIR}/status.sh ${STAGEDIR}${PREFIX}/bin/status.sh
.include <bsd.port.mk>