# $FreeBSD$
#
# chaos - BAUXBSD component

PORTNAME=	chaos
PORTVERSION=	0.1.0
CATEGORIES=	sysutils
MASTER_SITES=	# No distfiles needed

MAINTAINER=	baux@roxieos.org
COMMENT=	BAUXBSD chaos component

LICENSE=	BSD2CLAUSE

NO_BUILD=	yes
NO_ARCH=	yes

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/bin
	${INSTALL_SCRIPT} ${FILESDIR}/chaos ${STAGEDIR}${PREFIX}/bin/chaos 2>/dev/null || true

.include <bsd.port.mk>
