# New ports collection makefile for:	baux
# Date created:		7 Dec 2025
# Whom:			badlandz
#
# $FreeBSD$
#

PORTNAME=	baux
PORTVERSION=	0.3.0
CATEGORIES=	sysutils
MASTER_SITES=	# empty
DISTFILES=	# empty
EXTRACT_ONLY=	# empty

MAINTAINER=	robert.current@gmail.com
COMMENT=	BAUX session management and tmux integration
WWW=		https://github.com/badlandz/RoxieOS

LICENSE=	MIT

RUN_DEPENDS=	tmux:sysutils/tmux \
		neovim:editors/neovim \
		rsync:net/rsync

NO_ARCH=	yes
NO_BUILD=	yes

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/bin
	${MKDIR} ${STAGEDIR}${PREFIX}/share/baux
	${MKDIR} ${STAGEDIR}${PREFIX}/share/baux/scripts
	${MKDIR} ${STAGEDIR}${PREFIX}/share/baux/nvim
	${MKDIR} ${STAGEDIR}${PREFIX}/share/baux/nvim/lua
	${MKDIR} ${STAGEDIR}${PREFIX}/share/baux/nvim/lua/config
	${MKDIR} ${STAGEDIR}${PREFIX}/share/baux/nvim/lua/plugins
	${MKDIR} ${STAGEDIR}${PREFIX}/share/baux/nvim/colors
	${MKDIR} ${STAGEDIR}${PREFIX}/share/tmux
	${INSTALL_SCRIPT} ${FILESDIR}${PREFIX}/bin/baux \
		${STAGEDIR}${PREFIX}/bin/baux
	${INSTALL_DATA} ${FILESDIR}${PREFIX}/share/tmux/baux.conf \
		${STAGEDIR}${PREFIX}/share/tmux/
	${INSTALL_SCRIPT} ${FILESDIR}${PREFIX}/share/baux/scripts/baux-hosts \
		${STAGEDIR}${PREFIX}/share/baux/scripts/baux-hosts
	${INSTALL_SCRIPT} ${FILESDIR}${PREFIX}/share/baux/scripts/baux-pull \
		${STAGEDIR}${PREFIX}/share/baux/scripts/baux-pull
	${INSTALL_SCRIPT} ${FILESDIR}${PREFIX}/share/baux/scripts/baux-push \
		${STAGEDIR}${PREFIX}/share/baux/scripts/baux-push
	${INSTALL_SCRIPT} ${FILESDIR}${PREFIX}/share/baux/scripts/baux-switch \
		${STAGEDIR}${PREFIX}/share/baux/scripts/baux-switch
	${INSTALL_DATA} ${FILESDIR}${PREFIX}/share/baux/nvim/init.lua \
		${STAGEDIR}${PREFIX}/share/baux/nvim/
	${INSTALL_DATA} ${FILESDIR}${PREFIX}/share/baux/nvim/lua/config/*.lua \
		${STAGEDIR}${PREFIX}/share/baux/nvim/lua/config/
	${INSTALL_DATA} ${FILESDIR}${PREFIX}/share/baux/nvim/lua/plugins/*.lua \
		${STAGEDIR}${PREFIX}/share/baux/nvim/lua/plugins/
	${INSTALL_DATA} ${FILESDIR}${PREFIX}/share/baux/nvim/colors/*.vim \
		${STAGEDIR}${PREFIX}/share/baux/nvim/colors/

.include <bsd.port.mk>