# EB Garamond Font Port
# TODO: Implement FreeBSD port for EB Garamond font
# Source: Debian fonts-ebgaramond package
# Features: Elegant serif font for documentation

PORTNAME=	ebgaramond
DISTVERSION=	0.016
CATEGORIES=	x11-fonts
MASTER_SITES=	https://github.com/georgd/EB-Garamond/releases/download/v${DISTVERSION}/

MAINTAINER=	roxieos@badlandz.dev
COMMENT=	EB Garamond font family

LICENSE=	OFL11
LICENSE_FILE=	${WRKSRC}/OFL.txt

USES=		fonts
NO_ARCH=	yes
NO_BUILD=	yes

do-install:
	${MKDIR} ${STAGEDIR}${FONTSDIR}
	${INSTALL_DATA} ${WRKSRC}/fonts/otf/*.otf ${STAGEDIR}${FONTSDIR}

.include <bsd.port.mk>