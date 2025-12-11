# New ports collection makefile for:	baux-registry
# Date created:		2025-12-11
# Whom:			BAUX Development Team
#
# $FreeBSD$
#

PORTNAME=	baux-registry
PORTVERSION=	1.0
CATEGORIES=	sysutils
MASTER_SITES=	# empty
DISTFILES=	# empty

MAINTAINER=	badlandz@gmail.com
COMMENT=	BAUX session registry database service

LICENSE=	MIT

NO_BUILD=	yes
NO_ARCH=	yes

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/bin
	${INSTALL_SCRIPT} ${FILESDIR}${PREFIX}/bin/baux-registry ${STAGEDIR}${PREFIX}/bin/baux-registry
	${MKDIR} ${STAGEDIR}${PREFIX}/share/baux-registry
	${INSTALL_DATA} ${FILESDIR}${PREFIX}/share/baux-registry/schema.sql ${STAGEDIR}${PREFIX}/share/baux-registry/schema.sql

.include <bsd.port.mk>
