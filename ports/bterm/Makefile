# $FreeBSD$
#
# bterm - BAUXBSD component

PORTNAME=	bterm
PORTVERSION=	0.1.0
CATEGORIES=	sysutils
MASTER_SITES=	# No distfiles needed

MAINTAINER=	baux@roxieos.org
COMMENT=	BAUXBSD bterm component

LICENSE=	BSD2CLAUSE

NO_BUILD=	yes
NO_ARCH=	yes

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/bin
	${INSTALL_SCRIPT} ${FILESDIR}/bterm ${STAGEDIR}${PREFIX}/bin/bterm 2>/dev/null || true

.include <bsd.port.mk>
