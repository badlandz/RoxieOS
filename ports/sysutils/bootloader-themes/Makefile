# Bootloader Themes Port
# TODO: Implement GRUB theme system
# Source: Debian grub-theme-roxieos
# Features: Custom branding, accessibility design

PORTNAME=	bootloader-themes
DISTVERSION=	1.0
CATEGORIES=	sysutils
MASTER_SITES=	# Local development

MAINTAINER=	roxieos@badlandz.dev
COMMENT=	Bootloader themes for RoxieOS

LICENSE=	BSD2CLAUSE
LICENSE_FILE=	${WRKSRC}/LICENSE

NO_ARCH=	yes
NO_BUILD=	yes

do-install:
	${MKDIR} ${STAGEDIR}/boot/grub/themes/roxieos
	${INSTALL_DATA} ${WRKSRC}/themes/* ${STAGEDIR}/boot/grub/themes/roxieos/

.include <bsd.port.mk>