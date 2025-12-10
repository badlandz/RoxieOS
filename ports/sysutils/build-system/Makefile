# Build System Tools Port
# TODO: Implement automated package building
# Source: Debian build system concepts
# Features: poudriere integration, build farm

PORTNAME=	build-system
DISTVERSION=	1.0
CATEGORIES=	sysutils
MASTER_SITES=	# Local development

MAINTAINER=	roxieos@badlandz.dev
COMMENT=	Automated package building tools

LICENSE=	BSD2CLAUSE
LICENSE_FILE=	${WRKSRC}/LICENSE

RUN_DEPENDS=	poudriere>0:ports-mgmt/poudriere

NO_ARCH=	yes
NO_BUILD=	yes

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/bin
	${INSTALL_SCRIPT} ${WRKSRC}/bin/build-* ${STAGEDIR}${PREFIX}/bin/
	${MKDIR} ${STAGEDIR}${PREFIX}/etc/build-system
	${INSTALL_DATA} ${WRKSRC}/etc/* ${STAGEDIR}${PREFIX}/etc/build-system/

.include <bsd.port.mk>