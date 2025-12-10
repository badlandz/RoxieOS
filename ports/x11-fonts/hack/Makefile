# Hack Font Port
# TODO: Implement FreeBSD port for Hack font
# Source: Debian fonts-hack package
# Features: Optimized for source code, high readability

PORTNAME=	hack-fonts
DISTVERSION=	3.003
CATEGORIES=	x11-fonts
MASTER_SITES=	https://github.com/source-foundry/Hack/releases/download/v${DISTVERSION}/

MAINTAINER=	roxieos@badlandz.dev
COMMENT=	Hack font optimized for source code

LICENSE=	OFL11
LICENSE_FILE=	${WRKSRC}/LICENSE.md

USES=		fonts
NO_ARCH=	yes
NO_BUILD=	yes

do-install:
	${MKDIR} ${STAGEDIR}${FONTSDIR}
	${INSTALL_DATA} ${WRKSRC}/build/ttf/*.ttf ${STAGEDIR}${FONTSDIR}

.include <bsd.port.mk>