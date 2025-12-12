import sys
sys.path.insert(0, "v2-shared")
import asyncio

async def test_mesh():
    try:
        from baux_bot_shared.communication import BauxdClient
        
        client = BauxdClient()
        print("Testing bauxd connectivity...")
        
        # Test health check
        healthy = await client.health_check()
        print(f"Health check: {PASS if healthy else FAIL}")
        
        # Test session discovery
        sessions = await client.get_sessions()
        print(f"Found {len(sessions)} sessions")
        
        # Test AI server discovery
        ai_servers = await client.discover_ai_servers()
        print(f"Found {len(ai_servers)} AI servers")
        
        print("Mesh communication test: SUCCESS")
        
    except Exception as e:
        print(f"Mesh communication test: FAILED - {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    asyncio.run(test_mesh())
