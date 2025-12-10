# Live Build System Port
# TODO: Implement FreeBSD live build system
# Source: Debian live-build concepts
# Features: ISO creation, package selection, bootloader config

PORTNAME=	live-build
DISTVERSION=	1.0
CATEGORIES=	sysutils
MASTER_SITES=	# Local development

MAINTAINER=	roxieos@badlandz.dev
COMMENT=	Live system build tools for RoxieOS

LICENSE=	BSD2CLAUSE
LICENSE_FILE=	${WRKSRC}/LICENSE

NO_ARCH=	yes
NO_BUILD=	yes

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/bin
	${INSTALL_SCRIPT} ${WRKSRC}/bin/live-build ${STAGEDIR}${PREFIX}/bin/
	${MKDIR} ${STAGEDIR}${PREFIX}/share/live-build
	${CP} -r ${WRKSRC}/share/* ${STAGEDIR}${PREFIX}/share/live-build/

.include <bsd.port.mk>