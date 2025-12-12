#!/usr/bin/env python3
"""
BAUX-BOT Client v2.0 - Direct GROK AI Integration (Isolated Mode)
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
    from baux_bot_shared.config.settings import get_settings
except ImportError as e:
    print(f"Error importing shared components: {e}")
    print("Make sure the shared components are properly installed.")
    sys.exit(1)

import aiohttp
import json


class BauxBotClient:
    """Direct GROK AI client for BAUX-BOT."""

    def __init__(self):
        self.settings = get_settings()

    async def check_grok_api(self) -> bool:
        """Check if GROK API is accessible."""
        print("🔗 Checking GROK API connectivity...")
        api_key = os.environ.get("GROK_API_KEY")
        if not api_key:
            print("❌ GROK_API_KEY not found in environment")
            return False
        
        try:
            # Simple test query
            test_response = await self.call_grok("Hello, test connection")
            if "Error" not in test_response:
                print("✅ GROK API connection established")
                return True
            else:
                print(f"❌ GROK API error: {test_response}")
                return False
        except Exception as e:
            print(f"❌ GROK API connection failed: {e}")
            return False

    async def call_grok(self, prompt: str) -> str:
        """Call GROK API directly."""
        api_key = os.environ.get("GROK_API_KEY")
        if not api_key:
            return "Error: GROK_API_KEY not set"

        url = "https://api.x.ai/v1/chat/completions"
        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {api_key}"
        }
        data = {
            "messages": [{"role": "user", "content": prompt}],
            "model": "grok-2-1212",
            "stream": False,
            "temperature": 0
        }

        try:
            async with aiohttp.ClientSession() as session:
                async with session.post(url, headers=headers, json=data) as response:
                    if response.status == 200:
                        result = await response.json()
                        return result["choices"][0]["message"]["content"]
                    else:
                        error_text = await response.text()
                        return f"Error: {response.status} - {error_text}"
        except Exception as e:
            return f"Error: {e}"

    async def process_query(self, query: str) -> str:
        """Process user query with GROK."""
        print(f"🤔 Processing: {query}")
        
        # Handle file reading commands
        if query.startswith("read file:"):
            file_path = query[10:].strip()
            try:
                with open(file_path, r) as f:
                    content = f.read()
                query = f"File content of {file_path}:\n\n{content}\n\nPlease analyze this file."
            except Exception as e:
                return f"Error reading file {file_path}: {e}"
        
        # Call GROK
        response = await self.call_grok(query)
        return response

    async def run_interactive(self):
        """Run interactive session."""
        print("🤖 BAUX-BOT Client v2.0 (Direct GROK Mode)")
        print("Type your questions or exit to quit")
        print("-" * 50)

        # Check API connectivity
        if not await self.check_grok_api():
            print("Cannot proceed without GROK API access.")
            return

        while True:
            try:
                user_input = input("you > ").strip()
                if user_input.lower() in [exit, quit, q]:
                    print("Goodbye!")
                    break
                
                if not user_input:
                    continue

                response = await self.process_query(user_input)
                print(f"grok > {response}")
                print()

            except KeyboardInterrupt:
                print("\nGoodbye!")
                break
            except Exception as e:
                print(f"Error: {e}")
                print()


async def main():
    client = BauxBotClient()
    await client.run_interactive()


if __name__ == "__main__":
    asyncio.run(main())
