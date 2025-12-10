# Tex Gyre Font Port
# TODO: Implement FreeBSD port for Tex Gyre fonts
# Source: Debian tex-gyre package
# Features: High-quality serif and sans fonts

PORTNAME=	tex-gyre
DISTVERSION=	20180621
CATEGORIES=	x11-fonts
MASTER_SITES=	https://www.gust.org.pl/projects/e-foundry/tex-gyre/whole/tg${DISTVERSION//./}src.tar.gz

MAINTAINER=	roxieos@badlandz.dev
COMMENT=	TeX Gyre font collection

LICENSE=	GFL
LICENSE_FILE=	${WRKSRC}/doc/GUST-FONT-LICENSE.txt

USES=		fonts
NO_ARCH=	yes
NO_BUILD=	yes

do-install:
	${MKDIR} ${STAGEDIR}${FONTSDIR}
	${INSTALL_DATA} ${WRKSRC}/fonts/opentype/public/tex-gyre/*.otf ${STAGEDIR}${FONTSDIR}

.include <bsd.port.mk>