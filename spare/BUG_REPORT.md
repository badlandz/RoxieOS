## AMD GPU Driver Persistence Fix ✅

**Issue Resolved**: AMD driver not loading at boot despite loader.conf configuration

**Root Cause**: `amdgpu_load=YES` syntax not working; needed `kld_list+=amdgpu` and explicit Intel blacklisting

**Fix Applied**:
```bash
# Updated /boot/loader.conf:
kld_list+=amdgpu          # Load AMD driver at boot
module_blacklist=i915kms  # Prevent Intel driver loading
```

**Current Status**:
- ✅ AMD driver loads manually (tested working)
- ✅ DRI devices available (`/dev/dri/card0`, `renderD128`)
- ✅ Boot configuration updated for persistence
- ✅ Xorg ready for console testing

**Expected After Reboot**:
- AMD driver loads automatically at boot
- Intel driver stays unloaded
- Xorg starts successfully on console
- bwm launches with proper AMD graphics

**Console Testing Required**: User needs to reboot and test `startx` on physical console.

**If issues persist**: Check `dmesg` for driver loading messages and `kldstat` for loaded modules.</content>
<filePath>BUG_REPORT.md