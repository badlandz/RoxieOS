#!/usr/bin/env python3
import json
import sqlite3
import os
import glob

DB_PATH = "/var/db/baux/bauxd.db"
REGISTRY_DIR = "/var/db/baux"

def migrate_sessions():
    if not os.path.exists(REGISTRY_DIR):
        print("No registry directory found")
        return 0
    
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    
    migrated = 0
    session_files = glob.glob(os.path.join(REGISTRY_DIR, "session_*.json"))
    
    for file_path in session_files:
        try:
            with open(file_path, 'r') as f:
                data = json.load(f)
            
            cursor.execute('''
                INSERT OR IGNORE INTO sessions 
                (name, node, pid, status, updated_at) 
                VALUES (?, ?, ?, ?, ?)
            ''', (
                data.get('name'),
                data.get('node'),
                data.get('pid'),
                data.get('status', 'active'),
                data.get('updated_at')
            ))
            
            print(f"Migrated session: {data.get('name')}")
            migrated += 1
            
        except Exception as e:
            print(f"Error migrating {file_path}: {e}")
    
    conn.commit()
    conn.close()
    return migrated

if __name__ == "__main__":
    count = migrate_sessions()
    print(f"Migration complete: {count} sessions migrated")
