# Persistence Tools Port
# TODO: Implement enhanced USB persistence tools
# Source: Debian live-boot persistence concepts
# Features: Multiple persistence stores, encryption

PORTNAME=	persistence-tools
DISTVERSION=	1.0
CATEGORIES=	sysutils
MASTER_SITES=	# Local development

MAINTAINER=	roxieos@badlandz.dev
COMMENT=	USB persistence tools for live systems

LICENSE=	BSD2CLAUSE
LICENSE_FILE=	${WRKSRC}/LICENSE

NO_ARCH=	yes
NO_BUILD=	yes

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/bin
	${INSTALL_SCRIPT} ${WRKSRC}/bin/persist-* ${STAGEDIR}${PREFIX}/bin/
	${MKDIR} ${STAGEDIR}${PREFIX}/share/persistence-tools
	${CP} -r ${WRKSRC}/share/* ${STAGEDIR}${PREFIX}/share/persistence-tools/

.include <bsd.port.mk>