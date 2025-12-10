# Plymouth Themes Port
# TODO: Implement Plymouth boot splash screens
# Source: Debian plymouth-theme-roxieos
# Features: Smooth boot experience, branding

PORTNAME=	plymouth-themes
DISTVERSION=	1.0
CATEGORIES=	sysutils
MASTER_SITES=	# Local development

MAINTAINER=	roxieos@badlandz.dev
COMMENT=	Plymouth themes for RoxieOS boot

LICENSE=	BSD2CLAUSE
LICENSE_FILE=	${WRKSRC}/LICENSE

USES=		plymouth
NO_ARCH=	yes
NO_BUILD=	yes

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/share/plymouth/themes/roxieos
	${INSTALL_DATA} ${WRKSRC}/themes/* ${STAGEDIR}${PREFIX}/share/plymouth/themes/roxieos/

.include <bsd.port.mk>