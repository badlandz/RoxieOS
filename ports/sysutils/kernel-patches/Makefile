# Kernel Patches Port
# TODO: Implement accessibility-enhanced kernel
# Source: Debian linux-image-roxanne concepts
# Features: Accessibility patches, custom config

PORTNAME=	kernel-patches
DISTVERSION=	1.0
CATEGORIES=	sysutils
MASTER_SITES=	# Local development

MAINTAINER=	roxieos@badlandz.dev
COMMENT=	Kernel patches for accessibility

LICENSE=	BSD2CLAUSE
LICENSE_FILE=	${WRKSRC}/LICENSE

NO_ARCH=	yes
NO_BUILD=	yes

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/share/kernel-patches
	${INSTALL_DATA} ${WRKSRC}/patches/* ${STAGEDIR}${PREFIX}/share/kernel-patches/

.include <bsd.port.mk>