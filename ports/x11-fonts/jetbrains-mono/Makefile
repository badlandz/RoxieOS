# JetBrains Mono Font Port
# TODO: Implement FreeBSD port for JetBrains Mono font
# Source: Debian fonts-jetbrains-mono package
# Features: Programming ligatures, multiple weights, accessibility optimized

PORTNAME=	jetbrains-mono
DISTVERSION=	2.304
CATEGORIES=	x11-fonts
MASTER_SITES=	https://github.com/JetBrains/JetBrainsMono/releases/download/v${DISTVERSION}/

MAINTAINER=	roxieos@badlandz.dev
COMMENT=	JetBrains Mono font with programming ligatures

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