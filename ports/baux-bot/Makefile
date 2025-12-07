# $FreeBSD$
#
# baux-bot - BAUXBSD AI assistant

PORTNAME=	baux-bot
PORTVERSION=	0.1.0
CATEGORIES=	misc
MASTER_SITES=	# No distfiles needed

MAINTAINER=	baux@roxieos.org
COMMENT=	BAUXBSD AI assistant with Ollama integration

LICENSE=	BSD2CLAUSE

RUN_DEPENDS=	ollama:misc/ollama \
		bash:shells/bash

NO_BUILD=	yes
NO_ARCH=	yes

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/bin
	${MKDIR} ${STAGEDIR}${PREFIX}/share/baux-bot
	${INSTALL_SCRIPT} ${FILESDIR}/usr/local/bin/baux-bot ${STAGEDIR}${PREFIX}/bin/baux-bot
	${INSTALL_SCRIPT} ${FILESDIR}/usr/local/bin/baux-bot-setup ${STAGEDIR}${PREFIX}/bin/baux-bot-setup
	${INSTALL_SCRIPT} ${FILESDIR}/usr/local/bin/xai-chat ${STAGEDIR}${PREFIX}/bin/xai-chat
	${INSTALL_SCRIPT} ${FILESDIR}/usr/local/bin/dev-assist ${STAGEDIR}${PREFIX}/bin/dev-assist

.include <bsd.port.mk>