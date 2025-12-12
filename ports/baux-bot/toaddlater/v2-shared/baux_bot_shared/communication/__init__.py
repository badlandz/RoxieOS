# baux_bot_shared/communication/__init__.py
"""
Mesh communication utilities for BAUX-BOT distributed AI ecosystem.
"""

try:
    from .mesh import BauxdClient, MeshCoordinator
    __all__ = ['BauxdClient', 'MeshCoordinator']
except ImportError:
    # Dependencies not available - provide dummy classes
    class BauxdClient:
        pass
    class MeshCoordinator:
        pass
    __all__ = ['BauxdClient', 'MeshCoordinator']