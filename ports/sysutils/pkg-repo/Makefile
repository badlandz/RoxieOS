# Local Package Repository Port
# TODO: Implement local pkg repository
# Source: Debian apt repository concepts
# Features: Offline development, custom packages

PORTNAME=	pkg-repo
DISTVERSION=	1.0
CATEGORIES=	sysutils
MASTER_SITES=	# Local development

MAINTAINER=	roxieos@badlandz.dev
COMMENT=	Local package repository tools

LICENSE=	BSD2CLAUSE
LICENSE_FILE=	${WRKSRC}/LICENSE

NO_ARCH=	yes
NO_BUILD=	yes

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/bin
	${INSTALL_SCRIPT} ${WRKSRC}/bin/repo-* ${STAGEDIR}${PREFIX}/bin/
	${MKDIR} ${STAGEDIR}${PREFIX}/share/pkg-repo
	${CP} -r ${WRKSRC}/share/* ${STAGEDIR}${PREFIX}/share/pkg-repo/

.include <bsd.port.mk>