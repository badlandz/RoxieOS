# New ports collection makefile for:	baux
# Date created:		7 Dec 2025
# Whom:			badlandz
#
# $FreeBSD$
#

PORTNAME=	baux
PORTVERSION=	0.3.0
CATEGORIES=	sysutils
MASTER_SITES=	# empty
DISTFILES=	# empty
EXTRACT_ONLY=	# empty

MAINTAINER=	robert.current@gmail.com
COMMENT=	BAUX session management and tmux integration
WWW=		https://github.com/badlandz/RoxieOS

LICENSE=	MIT

RUN_DEPENDS=	tmux:sysutils/tmux \
		neovim:editors/neovim

NO_ARCH=	yes
NO_BUILD=	yes

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/bin
	${MKDIR} ${STAGEDIR}${PREFIX}/share/baux
	${MKDIR} ${STAGEDIR}${PREFIX}/share/tmux
	${INSTALL_SCRIPT} ${FILESDIR}${PREFIX}/bin/baux \
		${STAGEDIR}${PREFIX}/bin/baux
	${INSTALL_DATA} ${FILESDIR}${PREFIX}/share/tmux/baux.conf \
		${STAGEDIR}${PREFIX}/share/tmux/

.include <bsd.port.mk>