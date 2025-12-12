#!/usr/bin/env python3
"""
BAUX-BOT Client v2.0 - Lightweight interface for distributed AI ecosystem.

This client connects to BAUX-BOT routers and servers in the mesh to provide
AI assistance without requiring local AI processing capabilities.
"""

import asyncio
import sys
import os
from pathlib import Path
from typing import Optional, Dict, Any

# Add shared components to path
shared_path = Path(__file__).parent.parent / "v2-shared"
sys.path.insert(0, str(shared_path))

try:
    from baux_bot_shared.config import get_settings
    from baux_bot_shared.communication import BauxdClient, MeshCoordinator
except ImportError as e:
    print(f"Error importing shared components: {e}")
    print("Make sure the shared components are properly installed.")
    sys.exit(1)


class BauxBotClient:
    """Lightweight BAUX-BOT client for mesh-based AI assistance."""

    def __init__(self):
        self.settings = get_settings()
        self.bauxd = BauxdClient()
        self.coordinator = MeshCoordinator()

    async def check_mesh_connectivity(self) -> bool:
        """Check if we can connect to the BAUX mesh."""
        print(f"🔗 Checking mesh connectivity to {self.settings.bauxd_host}:{self.settings.bauxd_port}...")
        healthy = await self.bauxd.health_check()
        if healthy:
            print("✅ Mesh connection established")
        else:
            print("❌ Cannot connect to BAUX mesh")
        return healthy

    async def discover_services(self):
        """Discover available AI services in the mesh."""
        print("🔍 Discovering AI services in mesh...")
        servers = await self.bauxd.discover_ai_servers()
        if servers:
            print(f"✅ Found {len(servers)} AI server(s):")
            for server in servers:
                print(f"   - {server.get('name', 'Unknown')} at {server.get('ip', 'Unknown')}")
        else:
            print("❌ No AI servers found in mesh")
        return servers

    async def route_request(self, user_input: str) -> Optional[Dict[str, Any]]:
        """Route a user request to the optimal AI server in the mesh."""
        try:
            # Determine request requirements based on input
            requirements = {
                "capabilities": ["text-generation"],  # Basic requirement
                "input_length": len(user_input)
            }

            # Route to optimal server
            routing_result = await self.coordinator.route_request({
                "type": "text-generation",
                "input": user_input,
                "requirements": requirements
            })

            if routing_result:
                server = routing_result["server"]
                print(f"🔄 Routed to server: {server.get('name', 'Unknown')} at {server.get('node', 'Unknown')}")
                print(f"📊 Server capabilities: {', '.join(server.get('capabilities', []))}")

                # TODO: Actually send request to server and get response
                # For now, simulate response
                return {
                    "response": f"Simulated response from {server.get('name', 'AI Server')}",
                    "server": server,
                    "routed": True
                }
            else:
                print("❌ No suitable AI servers available in mesh")
                return None

        except Exception as e:
            print(f"❌ Error routing request: {e}")
            return None

    async def interactive_session(self):
        """Start an interactive AI session."""
        print("🤖 BAUX-BOT Client v2.0")
        print("Type your questions or 'exit' to quit")
        print("-" * 50)

        while True:
            try:
                user_input = input("you > ").strip()
                if user_input.lower() in ['exit', 'quit']:
                    break

                if not user_input:
                    continue

                print(f"🤔 Processing: {user_input}")

                # Route request to optimal AI server
                result = await self.route_request(user_input)

                if result:
                    print(f"🤖 {result['response']}")
                else:
                    print("❌ Unable to process request - no AI servers available")

            except KeyboardInterrupt:
                print("\n👋 Goodbye!")
                break
            except EOFError:
                break


async def main():
    """Main client entry point."""
    client = BauxBotClient()

    # Parse command line arguments
    if len(sys.argv) > 1:
        command = sys.argv[1].lower()

        if command == "check":
            success = await client.check_mesh_connectivity()
            sys.exit(0 if success else 1)

        elif command == "discover":
            await client.discover_services()
            sys.exit(0)

        elif command == "help":
            print("BAUX-BOT Client v2.0")
            print("Usage: baux-bot-client [command]")
            print("")
            print("Commands:")
            print("  check     - Check mesh connectivity")
            print("  discover  - Discover AI services in mesh")
            print("  help      - Show this help")
            print("  (no args) - Start interactive session")
            sys.exit(0)

        else:
            print(f"Unknown command: {command}")
            print("Use 'baux-bot-client help' for usage information")
            sys.exit(1)

    # No arguments - start interactive session
    mesh_ok = await client.check_mesh_connectivity()
    if not mesh_ok:
        print("⚠️  Warning: Mesh connectivity issues detected")
        print("   Some features may not work properly")

    await client.interactive_session()


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\n👋 Goodbye!")
    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)