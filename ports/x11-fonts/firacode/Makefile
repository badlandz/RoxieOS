# FiraCode Font Port
# TODO: Implement FreeBSD port for FiraCode font
# Source: Debian fonts-firacode package
# Features: Extensive programming ligatures, high readability

PORTNAME=	firacode
DISTVERSION=	6.2
CATEGORIES=	x11-fonts
MASTER_SITES=	https://github.com/tonsky/FiraCode/releases/download/${DISTVERSION}/

MAINTAINER=	roxieos@badlandz.dev
COMMENT=	FiraCode font with programming ligatures

LICENSE=	OFL11
LICENSE_FILE=	${WRKSRC}/LICENSE

USES=		fonts
NO_ARCH=	yes
NO_BUILD=	yes

do-install:
	${MKDIR} ${STAGEDIR}${FONTSDIR}
	${INSTALL_DATA} ${WRKSRC}/distr/ttf/*.ttf ${STAGEDIR}${FONTSDIR}

.include <bsd.port.mk>