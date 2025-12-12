# baux_bot_shared/config/settings.py
"""
Configuration management for BAUX-BOT distributed AI ecosystem.
"""

import os
from pathlib import Path
from typing import Dict, List, Optional


class Settings:
    """Global settings for BAUX-BOT components."""

    def __init__(self):
        # Component identification
        self.component_type = os.getenv("BAUX_BOT_COMPONENT", "unknown")
        self.node_id = os.getenv("BAUX_BOT_NODE_ID", os.uname().nodename)

        # Network configuration
        self.bauxd_host = os.getenv("BAUXD_HOST", "localhost")
        self.bauxd_port = int(os.getenv("BAUXD_PORT", "9999"))

        # Mesh configuration
        self.mesh_enabled = os.getenv("BAUX_MESH_ENABLED", "true").lower() == "true"
        self.mesh_timeout = int(os.getenv("BAUX_MESH_TIMEOUT", "30"))

        # AI backend priorities
        priority_str = os.getenv("BAUX_BACKEND_PRIORITY", "ollama,grok,gemini,claude,replicate,together,huggingface")
        self.backend_priority = [b.strip() for b in priority_str.split(",")]

        # Performance settings
        self.max_concurrent_requests = int(os.getenv("BAUX_MAX_CONCURRENT", "10"))
        self.request_timeout = int(os.getenv("BAUX_REQUEST_TIMEOUT", "60"))

        # Storage paths
        self.config_dir = Path.home() / ".baux-bot"
        self.cache_dir = self.config_dir / "cache"
        self.log_dir = self.config_dir / "logs"

        # Development settings
        self.debug_mode = os.getenv("BAUX_DEBUG", "false").lower() == "true"
        self.log_level = os.getenv("BAUX_LOG_LEVEL", "INFO")

        # Ensure directories exist
        self.config_dir.mkdir(parents=True, exist_ok=True)
        self.cache_dir.mkdir(parents=True, exist_ok=True)
        self.log_dir.mkdir(parents=True, exist_ok=True)


# Global settings instance
_settings: Optional[Settings] = None


def get_settings() -> Settings:
    """Get the global settings instance."""
    global _settings
    if _settings is None:
        _settings = Settings()
    return _settings


def reload_settings() -> Settings:
    """Reload settings from environment."""
    global _settings
    _settings = Settings()
    return _settings