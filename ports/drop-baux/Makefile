PORTNAME=	drop-baux
PORTVERSION=	0.1
CATEGORIES=	sysutils
MASTER_SITES=	# empty
DISTFILES=	# empty

MAINTAINER=	badlandz@users.noreply.github.com
COMMENT=	Distributed storage system for BAUX
WWW=		https://github.com/badlandz/RoxieOS

LICENSE=	BSD2CLAUSE

NO_BUILD=	yes
NO_ARCH=	yes

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/bin
	${MKDIR} ${STAGEDIR}${PREFIX}/share/drop-baux
	${INSTALL_SCRIPT} ${FILESDIR}${PREFIX}/bin/drop-baux ${STAGEDIR}${PREFIX}/bin/drop-baux

.include <bsd.port.mk>