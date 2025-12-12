# baux_bot_shared/communication/mesh.py
"""
Mesh communication utilities for BAUX-BOT distributed AI ecosystem.
"""

import asyncio
import aiohttp
import json
import logging
from typing import Dict, List, Optional, Any
from ..config.settings import get_settings

# Configure logging
logger = logging.getLogger(__name__)


class BauxdClient:
    """Client for communicating with bauxd service."""

    def __init__(self):
        self.settings = get_settings()
        self.base_url = f"http://{self.settings.bauxd_host}:{self.settings.bauxd_port}"

    async def health_check(self) -> bool:
        """Check if bauxd service is healthy."""
        try:
            timeout = aiohttp.ClientTimeout(total=5.0)
            async with aiohttp.ClientSession(timeout=timeout) as session:
                async with session.get(f"{self.base_url}/health") as response:
                    if response.status == 200:
                        data = await response.json()
                        return data.get("status") == "healthy"
                    else:
                        logger.warning(f"bauxd health check returned status {response.status}")
        except aiohttp.ClientError as e:
            logger.error(f"Network error checking bauxd health: {e}")
        except asyncio.TimeoutError:
            logger.error("Timeout checking bauxd health")
        except json.JSONDecodeError as e:
            logger.error(f"Invalid JSON response from bauxd health check: {e}")
        except Exception as e:
            logger.error(f"Unexpected error checking bauxd health: {e}")
        return False

    async def get_sessions(self) -> List[Dict[str, Any]]:
        """Get all sessions from bauxd registry."""
        try:
            timeout = aiohttp.ClientTimeout(total=10.0)
            async with aiohttp.ClientSession(timeout=timeout) as session:
                async with session.get(f"{self.base_url}/sessions") as response:
                    if response.status == 200:
                        data = await response.json()
                        if isinstance(data, list):
                            return data
                        else:
                            logger.warning(f"bauxd sessions endpoint returned non-list data: {type(data)}")
                            return []
                    else:
                        logger.warning(f"bauxd sessions endpoint returned status {response.status}")
        except aiohttp.ClientError as e:
            logger.error(f"Network error getting sessions from bauxd: {e}")
        except asyncio.TimeoutError:
            logger.error("Timeout getting sessions from bauxd")
        except json.JSONDecodeError as e:
            logger.error(f"Invalid JSON response from bauxd sessions: {e}")
        except Exception as e:
            logger.error(f"Unexpected error getting sessions from bauxd: {e}")
        return []

    async def discover_ai_servers(self) -> List[Dict[str, Any]]:
        """Discover AI servers in the mesh via bauxd."""
        try:
            sessions = await self.get_sessions()
            if not sessions:
                logger.info("No sessions found in bauxd registry")
                return []

            # Filter for AI servers and validate structure
            ai_servers = []
            for session in sessions:
                if not isinstance(session, dict):
                    logger.warning(f"Invalid session format: {type(session)}")
                    continue

                if session.get("type") == "ai-server":
                    # Validate required fields
                    required_fields = ["name", "node", "capabilities"]
                    if all(key in session for key in required_fields):
                        # Additional validation
                        if not isinstance(session.get("capabilities"), list):
                            logger.warning(f"AI server {session.get('name')} has invalid capabilities format")
                            continue
                        ai_servers.append(session)
                    else:
                        missing = [key for key in required_fields if key not in session]
                        logger.warning(f"AI server session missing required fields: {missing}")

            logger.info(f"Discovered {len(ai_servers)} valid AI servers")
            return ai_servers
        except Exception as e:
            logger.error(f"AI server discovery error: {e}")
            return []

    async def register_service(self, service_type: str, metadata: Dict[str, Any]) -> bool:
        """Register this service with bauxd (future extension)."""
        # TODO: Implement when bauxd API supports service registration
        # For now, services are registered via external means
        return True

    async def get_service_status(self, service_name: str) -> Optional[Dict[str, Any]]:
        """Get detailed status for a specific service."""
        try:
            sessions = await self.get_sessions()
            for session in sessions:
                if isinstance(session, dict) and session.get("name") == service_name:
                    return session
            logger.info(f"Service '{service_name}' not found in registry")
        except Exception as e:
            logger.error(f"Error getting status for service '{service_name}': {e}")
        return None


class MeshCoordinator:
    """Coordinates distributed operations across BAUX mesh."""

    def __init__(self):
        self.bauxd = BauxdClient()
        self.settings = get_settings()

    async def discover_services(self, service_type: str) -> List[Dict[str, Any]]:
        """Discover services of a specific type in the mesh."""
        try:
            if service_type == "ai-server":
                return await self.bauxd.discover_ai_servers()
            elif service_type == "ai-router":
                # Routers would be registered differently
                logger.info("Router discovery not yet implemented")
                return []
            elif service_type == "baux-node":
                # All BAUX nodes
                sessions = await self.bauxd.get_sessions()
                nodes = [s for s in sessions if isinstance(s, dict) and "node" in s]
                logger.info(f"Discovered {len(nodes)} BAUX nodes")
                return nodes
            else:
                logger.warning(f"Unknown service type: {service_type}")
                return []
        except Exception as e:
            logger.error(f"Error discovering services of type '{service_type}': {e}")
            return []

    async def find_optimal_server(self, requirements: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """Find the best AI server for given requirements using intelligent selection."""
        servers = await self.discover_services("ai-server")

        if not servers:
            return None

        # Enhanced selection logic
        scored_servers = []
        for server in servers:
            score = 0

            # Prefer servers with matching capabilities
            required_caps = requirements.get("capabilities", [])
            server_caps = server.get("capabilities", [])
            if any(cap in server_caps for cap in required_caps):
                score += 10

            # Prefer lower load servers
            load = server.get("load", 0)
            score += max(0, 10 - load)

            # Prefer servers with better response times
            latency = server.get("avg_latency", 1000)
            score += max(0, 10 - (latency // 100))

            scored_servers.append((score, server))

        # Return highest scoring server
        if scored_servers:
            scored_servers.sort(key=lambda x: x[0], reverse=True)
            return scored_servers[0][1]

        return None

    async def route_request(self, request_data: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """Route a request to the optimal server with load balancing."""
        server = await self.find_optimal_server(request_data)

        if server:
            return {
                "server": server,
                "routed": True,
                "timestamp": __import__("time").time(),  # Add proper timestamp
                "request": request_data
            }

        return None

    async def update_server_load(self, server_name: str, load_delta: int) -> bool:
        """Update load information for a server (for future load balancing)."""
        # TODO: Implement when bauxd supports load reporting
        return True