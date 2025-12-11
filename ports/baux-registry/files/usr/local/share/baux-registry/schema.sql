-- BAUX Session Registry Database Schema
-- Tracks session locations across the mesh network

CREATE TABLE IF NOT EXISTS sessions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    node TEXT NOT NULL,           -- Node hostname/IP where session is located
    pid INTEGER,                  -- Process ID of the session
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_seen DATETIME DEFAULT CURRENT_TIMESTAMP,
    status TEXT DEFAULT active  -- active, inactive, migrated
);

CREATE TABLE IF NOT EXISTS nodes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    hostname TEXT NOT NULL UNIQUE,
    ip_address TEXT,
    last_seen DATETIME DEFAULT CURRENT_TIMESTAMP,
    status TEXT DEFAULT online  -- online, offline, unknown
);

CREATE INDEX IF NOT EXISTS idx_sessions_name ON sessions(name);
CREATE INDEX IF NOT EXISTS idx_sessions_node ON sessions(node);
CREATE INDEX IF NOT EXISTS idx_sessions_status ON sessions(status);
CREATE INDEX IF NOT EXISTS idx_nodes_hostname ON nodes(hostname);

-- Insert default nodes
INSERT OR IGNORE INTO nodes (hostname, ip_address) VALUES 
(baux01, 192.168.33.101),
(baux-scale, bs.coseismic.org),
(localhost, 127.0.0.1);
