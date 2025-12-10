# OpenDyslexic Font Port
# TODO: Implement FreeBSD port for OpenDyslexic font
# Source: Debian fonts-opendyslexic package
# Features: Specialized for dyslexia support

PORTNAME=	opendyslexic
DISTVERSION=	20160623
CATEGORIES=	x11-fonts
MASTER_SITES=	https://github.com/antijingoist/open-dyslexic/releases/download/v${DISTVERSION}/

MAINTAINER=	roxieos@badlandz.dev
COMMENT=	OpenDyslexic font for dyslexia support

LICENSE=	OFL11
LICENSE_FILE=	${WRKSRC}/OFL.txt

USES=		fonts
NO_ARCH=	yes
NO_BUILD=	yes

do-install:
	${MKDIR} ${STAGEDIR}${FONTSDIR}
	${INSTALL_DATA} ${WRKSRC}/otf/*.otf ${STAGEDIR}${FONTSDIR}

.include <bsd.port.mk>