# New ports collection makefile for:	bbase
# Date created:		7 Dec 2025
# Whom:			badlandz
#
# $FreeBSD$
#

PORTNAME=	bbase
PORTVERSION=	0.1
CATEGORIES=	sysutils
MASTER_SITES=	# empty
DISTFILES=	# empty
EXTRACT_ONLY=	# empty

MAINTAINER=	robert.current@gmail.com
COMMENT=	BAUX base system with unified keymaps
WWW=		https://github.com/badlandz/RoxieOS

LICENSE=	MIT

NO_ARCH=	yes
NO_BUILD=	yes

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/share/syscons/keymaps
	${INSTALL_DATA} ${FILESDIR}/usr/local/share/syscons/keymaps/baux.kbd ${STAGEDIR}${PREFIX}/share/syscons/keymaps/baux.kbd
.include <bsd.port.mk>