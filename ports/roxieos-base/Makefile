# $FreeBSD$
#
# roxieos-base - RoxieOS base system configuration
# Autologin, keymaps, X autostart, OS identification

PORTNAME=	roxieos-base
PORTVERSION=	1.0.0
CATEGORIES=	sysutils
MASTER_SITES=	# No distfiles needed

MAINTAINER=	roxieos@roxieos.org
COMMENT=	RoxieOS base system configuration and setup
WWW=		https://roxieos.org

LICENSE=	BSD2CLAUSE

NO_BUILD=	yes
NO_ARCH=	yes

RUN_DEPENDS=	x11-fonts/nerd-fonts

do-install:
	# Create RoxieOS OS release identification
	${MKDIR} ${STAGEDIR}${PREFIX}/share/roxieos
	${INSTALL_DATA} ${FILESDIR}${PREFIX}/share/roxieos/os-release ${STAGEDIR}${PREFIX}/share/roxieos/

	# Install system configuration scripts
	${MKDIR} ${STAGEDIR}${PREFIX}/etc/roxieos
	${INSTALL_SCRIPT} ${FILESDIR}${PREFIX}/etc/roxieos/setup-autologin ${STAGEDIR}${PREFIX}/etc/roxieos/
	${INSTALL_SCRIPT} ${FILESDIR}${PREFIX}/etc/roxieos/setup-keymap ${STAGEDIR}${PREFIX}/etc/roxieos/
	${INSTALL_SCRIPT} ${FILESDIR}${PREFIX}/etc/roxieos/setup-x11 ${STAGEDIR}${PREFIX}/etc/roxieos/

post-install:
	# Run setup scripts during installation
	@${ECHO_MSG} "Setting up RoxieOS base configuration..."
	${FILESDIR}${PREFIX}/etc/roxieos/setup-autologin
	${FILESDIR}${PREFIX}/etc/roxieos/setup-keymap
	${FILESDIR}${PREFIX}/etc/roxieos/setup-x11

.include <bsd.port.mk>