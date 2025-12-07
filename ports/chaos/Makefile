# $FreeBSD$
#
# chaos - BAUXBSD anti-burn-in screensaver

PORTNAME=	chaos
PORTVERSION=	0.1.0
CATEGORIES=	sysutils
MASTER_SITES=	# No distfiles needed

MAINTAINER=	baux@roxieos.org
COMMENT=	BAUXBSD anti-burn-in screensaver for tmux

LICENSE=	BSD2CLAUSE

RUN_DEPENDS=	tmux:sysutils/tmux \
		btop:sysutils/btop \
		cmatrix:misc/cmatrix \
		fastfetch:sysutils/fastfetch

NO_BUILD=	yes
NO_ARCH=	yes

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/bin
	${INSTALL_SCRIPT} ${WRKSRC}/chaos.sh ${STAGEDIR}${PREFIX}/bin/chaos

.include <bsd.port.mk>
