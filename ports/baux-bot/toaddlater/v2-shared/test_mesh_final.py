import asyncio
import sys
sys.path.insert(0, ".")

async def test_mesh():
    try:
        from baux_bot_shared.communication import BauxdClient
        
        client = BauxdClient()
        print("Testing bauxd connectivity...")
        
        # Test health check
        healthy = await client.health_check()
        print("Health check: PASS" if healthy else "Health check: FAIL")
        
        # Test session discovery
        sessions = await client.get_sessions()
        print("Found " + str(len(sessions)) + " sessions")
        
        # Test AI server discovery
        ai_servers = await client.discover_ai_servers()
        print("Found " + str(len(ai_servers)) + " AI servers")
        
        print("Mesh communication test: SUCCESS")
        
    except Exception as e:
        print("Mesh communication test: FAILED - " + str(e))
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    asyncio.run(test_mesh())
