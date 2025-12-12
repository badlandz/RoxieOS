#!/usr/bin/env python3
import sys
from pathlib import Path

# Add shared path
shared_path = Path(__file__).parent.parent / "v2-shared"
sys.path.insert(0, str(shared_path))

try:
    from baux_bot_shared.config import get_settings
    settings = get_settings()
    print(f"Settings loaded: node_id={settings.node_id}")
    print(f"bauxd config: {settings.bauxd_host}:{settings.bauxd_port}")
    print(f"Backend priority: {settings.backend_priority[:3]}")
    print("SUCCESS: Shared components working!")
except Exception as e:
    print(f"ERROR: {e}")
    import traceback
    traceback.print_exc()