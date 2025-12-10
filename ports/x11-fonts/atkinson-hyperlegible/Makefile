# Atkinson Hyperlegible Font Port
# TODO: Implement FreeBSD port for Atkinson Hyperlegible font
# Source: Debian fonts-atkinson-hyperlegible package
# Features: Maximum readability for visual impairments

PORTNAME=	atkinson-hyperlegible
DISTVERSION=	0.0
CATEGORIES=	x11-fonts
MASTER_SITES=	https://github.com/googlefonts/atkinson-hyperlegible/releases/download/v${DISTVERSION}/

MAINTAINER=	roxieos@badlandz.dev
COMMENT=	Atkinson Hyperlegible font for maximum readability

LICENSE=	OFL11
LICENSE_FILE=	${WRKSRC}/OFL.txt

USES=		fonts
NO_ARCH=	yes
NO_BUILD=	yes

do-install:
	${MKDIR} ${STAGEDIR}${FONTSDIR}
	${INSTALL_DATA} ${WRKSRC}/fonts/ttf/*.ttf ${STAGEDIR}${FONTSDIR}
	${INSTALL_DATA} ${WRKSRC}/fonts/otf/*.otf ${STAGEDIR}${FONTSDIR}

.include <bsd.port.mk>