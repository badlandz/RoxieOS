import sys
from pathlib import Path
shared_path = Path(__file__).parent / "v2-shared"
sys.path.insert(0, str(shared_path))
try:
    from baux_bot_shared.config import get_settings
    settings = get_settings()
    print("SUCCESS: node_id=" + settings.node_id)
    print("bauxd: " + settings.bauxd_host + ":" + str(settings.bauxd_port))
except Exception as e:
    print("ERROR: " + str(e))
