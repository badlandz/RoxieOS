# $FreeBSD$
#
# roxieos-fonts - BAUXBSD custom fonts

PORTNAME=	roxieos-fonts
PORTVERSION=	0.1.0
CATEGORIES=	x11-fonts
MASTER_SITES=	# No distfiles needed

MAINTAINER=	baux@roxieos.org
COMMENT=	BAUXBSD custom font collection

LICENSE=	OFL11

NO_BUILD=	yes
NO_ARCH=	yes

FONTDIR=	${PREFIX}/share/fonts/roxieos

do-install:
	${MKDIR} ${STAGEDIR}${FONTDIR}
	${INSTALL_DATA} ${FILESDIR}/*.ttf ${STAGEDIR}${FONTDIR}/
	${INSTALL_DATA} ${FILESDIR}/*.otf ${STAGEDIR}${FONTDIR}/

.include <bsd.port.mk>
