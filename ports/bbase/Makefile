# New ports collection makefile for:	bbase
# Date created:		7 Dec 2025
# Whom:			badlandz
#
# $FreeBSD$
#

PORTNAME=	bbase
PORTVERSION=	0.1
CATEGORIES=	sysutils
MASTER_SITES=	# empty
DISTFILES=	# empty
EXTRACT_ONLY=	# empty

MAINTAINER=	robert.current@gmail.com
COMMENT=	BAUX base system with unified keymaps
WWW=		https://github.com/badlandz/RoxieOS

LICENSE=	MIT

NO_ARCH=	yes
NO_BUILD=	yes

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/share/syscons/keymaps
	${INSTALL_DATA} ${FILESDIR}/baux.kbd ${STAGEDIR}${PREFIX}/share/syscons/keymaps/baux.kbd

post-install:
	@${ECHO_MSG} ""
	@${ECHO_MSG} "BAUX keymap installed to ${PREFIX}/share/syscons/keymaps/baux.kbd"
	@${ECHO_MSG} "To activate system-wide, add to /etc/rc.conf:"
	@${ECHO_MSG} "  keymap=\"baux\""
	@${ECHO_MSG} "To test immediately:"
	@${ECHO_MSG} "  sudo kbdcontrol -l ${PREFIX}/share/syscons/keymaps/baux.kbd"
	@${ECHO_MSG} ""

.include <bsd.port.mk>