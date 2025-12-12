# $FreeBSD$
#
# baux-bot - BAUX AI assistant

PORTNAME=	baux-bot
PORTVERSION=	2.0.0
CATEGORIES=	misc
MASTER_SITES=	# No distfiles needed

MAINTAINER=	baux@roxieos.org
COMMENT=	BAUX-BOT v2.0 distributed AI ecosystem client

LICENSE=	BSD2CLAUSE

RUN_DEPENDS=	python311:lang/python311 \
		poetry:devel/poetry \
		aiohttp:www/py-aiohttp \
		py311-pyyaml:devel/py-pyyaml \
		py311-click:devel/py-click \
		bash:shells/bash

NO_BUILD=	yes
NO_ARCH=	yes

do-install:
	# Install v1.x compatibility scripts
	${MKDIR} ${STAGEDIR}${PREFIX}/bin
	${INSTALL_SCRIPT} ${FILESDIR}/usr/local/bin/baux-bot ${STAGEDIR}${PREFIX}/bin/baux-bot
	${INSTALL_SCRIPT} ${FILESDIR}/usr/local/bin/baux-bot-client ${STAGEDIR}${PREFIX}/bin/baux-bot-client
	${INSTALL_SCRIPT} ${FILESDIR}/usr/local/bin/baux-bot-setup ${STAGEDIR}${PREFIX}/bin/baux-bot-setup
	${INSTALL_SCRIPT} ${FILESDIR}/usr/local/bin/xai-chat ${STAGEDIR}${PREFIX}/bin/xai-chat
	${INSTALL_SCRIPT} ${FILESDIR}/usr/local/bin/dev-assist ${STAGEDIR}${PREFIX}/bin/dev-assist
	${INSTALL_SCRIPT} ${FILESDIR}/usr/local/bin/gemini-chat ${STAGEDIR}${PREFIX}/bin/gemini-chat
	${INSTALL_SCRIPT} ${FILESDIR}/usr/local/bin/dev-gemini ${STAGEDIR}${PREFIX}/bin/dev-gemini
	${INSTALL_SCRIPT} ${FILESDIR}/usr/local/bin/grok-workshop ${STAGEDIR}${PREFIX}/bin/grok-workshop
	
	# Install v2.0 components
	${MKDIR} ${STAGEDIR}${PREFIX}/share/baux/baux-bot
	${CP} -r ${WRKSRC}/v2-shared ${STAGEDIR}${PREFIX}/share/baux/baux-bot/
	${CP} -r ${WRKSRC}/v2-client ${STAGEDIR}${PREFIX}/share/baux/baux-bot/
	${CP} -r ${WRKSRC}/v2-router ${STAGEDIR}${PREFIX}/share/baux/baux-bot/
	${CP} -r ${WRKSRC}/v2-server ${STAGEDIR}${PREFIX}/share/baux/baux-bot/

.include <bsd.port.mk>
