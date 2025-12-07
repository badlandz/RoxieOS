# New ports collection makefile for:	bvi
# Date created:		7 Dec 2025
# Whom:			badlandz
#
# $FreeBSD$
#

PORTNAME=	bvi
PORTVERSION=	0.1
CATEGORIES=	editors
MASTER_SITES=	# empty
DISTFILES=	# empty
EXTRACT_ONLY=	# empty

MAINTAINER=	robert.current@gmail.com
COMMENT=	BAUX neovim wrapper with fallback support
WWW=		https://github.com/badlandz/RoxieOS

LICENSE=	MIT

RUN_DEPENDS=	neovim:editors/neovim

NO_ARCH=	yes
NO_BUILD=	yes

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/bin
	${MKDIR} ${STAGEDIR}${PREFIX}/etc/bvi
	${MKDIR} ${STAGEDIR}${PREFIX}/share/bvi
	${INSTALL_SCRIPT} ${FILESDIR}${PREFIX}/bin/bvi \
		${STAGEDIR}${PREFIX}/bin/bvi
	${INSTALL_DATA} ${FILESDIR}${PREFIX}/share/bvi/config/options.lua \
		${STAGEDIR}${PREFIX}/etc/bvi/
	${INSTALL_DATA} ${FILESDIR}${PREFIX}/share/bvi/plugins/colorscheme.lua \
		${STAGEDIR}${PREFIX}/etc/bvi/

.include <bsd.port.mk>