# $FreeBSD$
#
# bshot - BAUXBSD screenshot utility

PORTNAME=	bshot
PORTVERSION=	0.1.0
CATEGORIES=	graphics
MASTER_SITES=	# No distfiles needed

MAINTAINER=	baux@roxeios.org
COMMENT=	BAUXBSD screenshot utility for X11 and framebuffer

LICENSE=	BSD2CLAUSE

RUN_DEPENDS=	maim:graphics/maim \
		ImageMagick:graphics/ImageMagick \
		xclip:x11/xclip \
		fbgrab:graphics/fbgrab

NO_BUILD=	yes
NO_ARCH=	yes

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/bin
	${INSTALL_SCRIPT} ${FILESDIR}/baux-shot.sh ${STAGEDIR}${PREFIX}/bin/bshot
	${MKDIR} ${STAGEDIR}${PREFIX}/share/doc/bshot
	${INSTALL_DATA} ${FILESDIR}/README.md ${STAGEDIR}${PREFIX}/share/doc/bshot/

.include <bsd.port.mk>