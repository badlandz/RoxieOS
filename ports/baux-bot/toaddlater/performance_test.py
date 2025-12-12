#!/usr/bin/env python3
"""
BAUX-BOT v2.0 Performance Testing for Low-Power Devices
"""

import time
import psutil
import os
import sys
from pathlib import Path

# Add shared components to path
shared_path = Path(__file__).parent / "v2-shared"
sys.path.insert(0, str(shared_path))

def test_startup_time():
    """Test client startup time."""
    print("Testing startup time...")
    
    start_time = time.time()
    
    try:
        from baux_bot_shared.config import get_settings
        from baux_bot_shared.communication import BauxdClient, MeshCoordinator
        
        settings = get_settings()
        bauxd = BauxdClient()
        coordinator = MeshCoordinator()
        
        startup_time = time.time() - start_time
        
        print(f"Startup time: {startup_time:.3f}s")
        status = "PASS" if startup_time < 2.0 else "FAIL"
        print(f"Target: < 2.0s - {status}")
        
        return startup_time
        
    except Exception as e:
        startup_time = time.time() - start_time
        print(f"Startup failed after {startup_time:.3f}s: {e}")
        return None

def test_memory_usage():
    """Test memory usage."""
    print("\nTesting memory usage...")
    
    process = psutil.Process()
    initial_memory = process.memory_info().rss / 1024 / 1024
    
    # Import modules
    try:
        from baux_bot_shared.config import get_settings
        from baux_bot_shared.communication import BauxdClient, MeshCoordinator
        
        settings = get_settings()
        bauxd = BauxdClient()
        coordinator = MeshCoordinator()
        
        loaded_memory = process.memory_info().rss / 1024 / 1024
        memory_usage = loaded_memory - initial_memory
        
        print(f"Memory usage: {memory_usage:.1f} MB")
        status = "PASS" if memory_usage < 50 else "FAIL"
        print(f"Target: < 50 MB - {status}")
        
        return memory_usage
        
    except Exception as e:
        print(f"Memory test failed: {e}")
        return None

def test_platform_info():
    """Display platform information."""
    print("\nPlatform Information:")
    print(f"System: {os.uname().sysname}")
    print(f"Node: {os.uname().nodename}")
    print(f"Release: {os.uname().release}")
    print(f"Machine: {os.uname().machine}")
    print(f"Python: {sys.version.split()[0]}")

def main():
    """Run performance tests."""
    print("BAUX-BOT v2.0 Performance Test Suite")
    print("Week 5: Low-Power Device Optimization")
    print("=" * 50)
    
    test_platform_info()
    
    startup_time = test_startup_time()
    memory_usage = test_memory_usage()
    
    print("\n" + "=" * 50)
    print("PERFORMANCE SUMMARY:")
    
    if startup_time is not None:
        status = "PASS" if startup_time < 2.0 else "FAIL"
        print(f"Startup Time: {startup_time:.3f}s {status}")
    else:
        print("Startup Time: FAILED")
    
    if memory_usage is not None:
        status = "PASS" if memory_usage < 50 else "FAIL"
        print(f"Memory Usage: {memory_usage:.1f} MB {status}")
    else:
        print("Memory Usage: FAILED")
    
    # Overall assessment
    startup_ok = startup_time is not None and startup_time < 2.0
    memory_ok = memory_usage is not None and memory_usage < 50
    
    if startup_ok and memory_ok:
        print("\nALL PERFORMANCE TARGETS MET - Optimized for low-power devices!")
    elif startup_ok or memory_ok:
        print("\nPARTIAL SUCCESS - Some optimization needed")
    else:
        print("\nPERFORMANCE ISSUES - Requires optimization")

if __name__ == "__main__":
    main()
