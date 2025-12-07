# $FreeBSD$
#
# baux-welcome - BAUXBSD component

PORTNAME=	baux-welcome
PORTVERSION=	0.1.0
CATEGORIES=	sysutils
MASTER_SITES=	# No distfiles needed

MAINTAINER=	baux@roxieos.org
COMMENT=	BAUXBSD baux-welcome component

LICENSE=	BSD2CLAUSE

NO_BUILD=	yes
NO_ARCH=	yes

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/bin
	${INSTALL_SCRIPT} ${FILESDIR}/baux-welcome ${STAGEDIR}${PREFIX}/bin/baux-welcome 2>/dev/null || true

.include <bsd.port.mk>
