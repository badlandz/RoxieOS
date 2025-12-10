# Cantarell Font Port
# TODO: Implement FreeBSD port for Cantarell font
# Source: Debian fonts-cantarell package
# Features: GNOME sans font, excellent readability

PORTNAME=	cantarell-fonts
DISTVERSION=	0.303.1
CATEGORIES=	x11-fonts
MASTER_SITES=	https://download.gnome.org/sources/cantarell-fonts/${DISTVERSION:R}/

MAINTAINER=	roxieos@badlandz.dev
COMMENT=	Cantarell font family

LICENSE=	OFL11
LICENSE_FILE=	${WRKSRC}/COPYING

USES=		fonts
NO_ARCH=	yes
NO_BUILD=	yes

do-install:
	${MKDIR} ${STAGEDIR}${FONTSDIR}
	${INSTALL_DATA} ${WRKSRC}/fonts/*.otf ${STAGEDIR}${FONTSDIR}

.include <bsd.port.mk>