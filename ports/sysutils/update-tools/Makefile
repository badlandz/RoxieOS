# Update Tools Port
# TODO: Implement secure update distribution
# Source: Debian update concepts
# Features: Package signing, delta updates

PORTNAME=	update-tools
DISTVERSION=	1.0
CATEGORIES=	sysutils
MASTER_SITES=	# Local development

MAINTAINER=	roxieos@badlandz.dev
COMMENT=	Secure update distribution tools

LICENSE=	BSD2CLAUSE
LICENSE_FILE=	${WRKSRC}/LICENSE

NO_ARCH=	yes
NO_BUILD=	yes

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/bin
	${INSTALL_SCRIPT} ${WRKSRC}/bin/update-* ${STAGEDIR}${PREFIX}/bin/
	${MKDIR} ${STAGEDIR}${PREFIX}/share/update-tools
	${CP} -r ${WRKSRC}/share/* ${STAGEDIR}${PREFIX}/share/update-tools/

.include <bsd.port.mk>