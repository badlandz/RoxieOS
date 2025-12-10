# $FreeBSD$
#
# bauxd - BAUX daemon service for mesh coordination
#

PORTNAME=	bauxd
PORTVERSION=	0.1.0
CATEGORIES=	sysutils
MASTER_SITES=	# No distfiles needed

MAINTAINER=	baux@roxieos.org
COMMENT=	BAUX daemon for mesh session coordination and service discovery
LICENSE=	BSD2CLAUSE

RUN_DEPENDS=	baux:sysutils/baux \
		tmux:sysutils/tmux \
		socat:net/socat \
		jq:textproc/jq

NO_BUILD=	yes
NO_ARCH=	yes

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/bin
	${MKDIR} ${STAGEDIR}${PREFIX}/etc/rc.d
	${MKDIR} ${STAGEDIR}${PREFIX}/share/bauxd
	${INSTALL_SCRIPT} ${FILESDIR}${PREFIX}/bin/bauxd ${STAGEDIR}${PREFIX}/bin/bauxd
	${INSTALL_SCRIPT} ${FILESDIR}${PREFIX}/etc/rc.d/bauxd ${STAGEDIR}${PREFIX}/etc/rc.d/bauxd
	${INSTALL_DATA} ${FILESDIR}${PREFIX}/share/bauxd/config.json ${STAGEDIR}${PREFIX}/share/bauxd/config.json

post-install:
	@if [ ! -f /etc/rc.conf ]; then touch /etc/rc.conf; fi
	@if ! grep -q "^bauxd_enable=" /etc/rc.conf; then \
		echo 'bauxd_enable="YES"' >> /etc/rc.conf; \
	fi

.include <bsd.port.mk>