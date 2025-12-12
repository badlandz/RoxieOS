import sys
sys.path.insert(0, ".")
try:
    from baux_bot_shared.communication.mesh import BauxdClient
    print("Direct import: SUCCESS")
except Exception as e:
    print("Direct import: FAILED -", str(e))
