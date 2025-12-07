# New ports collection makefile for:	mango-pi
# Date created:		7 Dec 2025
# Whom:			badlandz
#
# $FreeBSD$

PORTNAME=	mango-pi
PORTVERSION=	0.1
CATEGORIES=	sysutils
MASTER_SITES=	# empty
DISTFILES=	# empty
EXTRACT_ONLY=	# empty

MAINTAINER=	robert.current@gmail.com
COMMENT=	Mango Pi RISC-V board support for BAUXBSD
WWW=		https://github.com/badlandz/RoxieOS

LICENSE=	MIT
LICENSE_FILE=	${WRKSRC}/LICENSE

NO_ARCH=	yes
NO_BUILD=	yes

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/bin
	${INSTALL_SCRIPT} ${FILESDIR}${PREFIX}/bin/mango-setup ${STAGEDIR}${PREFIX}/bin/mango-setup

.include <bsd.port.mk>