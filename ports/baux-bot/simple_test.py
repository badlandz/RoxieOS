import sys
sys.path.insert(0, "v2-shared")
try:
    from baux_bot_shared.config.settings import get_settings
    settings = get_settings()
    print("SUCCESS: node_id=" + settings.node_id)
    print("bauxd: " + settings.bauxd_host + ":" + str(settings.bauxd_port))
except Exception as e:
    print("ERROR: " + str(e))
