# Font Package Acquisition Status Report

## Overview
This document tracks the progress of acquiring all 23 fonts listed in `step001.md` for the CoseismicBSD fonts package. As of the current date, we have successfully obtained 14 font packages from Debian repositories (for FreeBSD porting), with 9 fonts remaining to be acquired.

**Note:** This is the original Debian font acquisition status. For FreeBSD implementation, see `fixedplan.md` and the FreeBSD ports collection.

## Fonts Successfully Acquired (14/23)

### Clean Monospaced Fonts (5/6)
| Font Name | Debian Package | Package Size | Source Extracted | Font Files Found |
|-----------|----------------|--------------|------------------|------------------|
| **Fira Code** | `fonts-firacode_6.2-2_all.deb` | 1.49 MB | ✅ `fonts-firacode-6.2/` | Multiple OTF/TTF variants |
| **Hack** | `fonts-hack_3.003-3_all.deb` | 1.63 MB | ✅ `fonts-hack-3.003/` | 4 TTF files (Regular, Bold, Italic, BoldItalic) |
| **JetBrains Mono** | `fonts-jetbrains-mono_2.304+ds-5_all.deb` | 721 KB | ✅ `fonts-jetbrains-mono-2.304+ds/` | Multiple TTF variants |
| **Atkinson Hyperlegible** | `fonts-atkinson-hyperlegible_0.0~git20210430.1cb3116-3_all.deb` | 64 KB | ✅ `fonts-atkinson-hyperlegible-0.0~git20210430.1cb3116/` | 8 files (TTF + OTF variants) |
| **OpenDyslexic** | `fonts-opendyslexic_20160623-4_all.deb` | 352 KB | ✅ `fonts-opendyslexic-20160623/` | Multiple TTF files |

### Special Monospaced Fonts (1/3)
| Font Name | Debian Package | Package Size | Source Extracted | Notes |
|-----------|----------------|--------------|------------------|-------|
| **OpenDyslexic Mono** | Included in `fonts-opendyslexic` | 352 KB | ✅ | Part of OpenDyslexic package |
| **Intel One Mono** | ❌ Not Found | - | - | Not available in Debian repos |
| **Atkinson Hyperlegible Mono** | ❌ Not Found | - | - | May need custom build |

### Essential Variable-Width Fonts (4/14)
| Font Name | Debian Package | Package Size | Source Extracted | Legal Document Use |
|-----------|----------------|--------------|------------------|-------------------|
| **EB Garamond** | `fonts-ebgaramond_0.016+git20210310.42d4f9f2-1_all.deb` | 452 KB | ✅ `fonts-ebgaramond-0.016+git20210310.42d4f9f2/` | ✅ Garamond equivalent |
| **TeX Gyre** | `fonts-texgyre_20180621-6_all.deb` | 8.21 MB | ✅ `tex-gyre-20180621/` | ✅ Century Schoolbook, Palatino equivalents |
| **Cantarell** | `fonts-cantarell_0.303.1-4_all.deb` | 114 KB | ✅ `fonts-cantarell-0.303.1/` | Modern sans-serif |
| **Liberation** | `fonts-liberation_1%3a2.1.5-3_all.deb` | 1.48 MB | ❌ Source download timed out | ✅ Times New Roman, Arial equivalents |

### System/Console Fonts (4/4)
| Font Name | Debian Package | Package Size | Source Extracted | Conflict Level |
|-----------|----------------|--------------|------------------|----------------|
| **Terminus** | `fonts-terminus_1.2.0+ds2-4_all.deb` | 81 KB | ❌ Source download timed out | ⚠️ Medium |
| **DejaVu Core** | `fonts-dejavu-core_2.37-8_all.deb` | 840 KB | ❌ Source download timed out | 🔴 High (Core System) |
| **Noto Core** | `fonts-noto-core_20201225-2_all.deb` | 12.2 MB | ❌ Source download timed out | 🔴 High (Unicode Coverage) |
| **Console Setup** | `console-setup_1.242~deb13u1_all.deb` | 98 KB | ❌ Source download timed out | 🔴 Critical (Essential Package) |

## Fonts Still Missing (9/23)

### Clean Monospaced Missing
1. **Iosevka** - Not found in Debian repositories
2. **Source Code Pro** - Not found in Debian repositories

### Special Monospaced Missing
3. **Intel One Mono** - Not found in Debian repositories
4. **Atkinson Hyperlegible Mono** - May need custom build from Atkinson Hyperlegible

### Variable-Width Missing (Legal Documents)
5. **Century Schoolbook** - Should be in TeX Gyre package as equivalent
6. **Times New Roman** - Should be covered by Liberation fonts
7. **Georgia** - Not found, may need Microsoft fonts or equivalent
8. **Book Antiqua** - Not found, Palatino equivalent may be in TeX Gyre
9. **Caslon** - Not found in Debian repositories
10. **Baskerville** - Not found in Debian repositories
11. **Equity** - Commercial font, not in Debian repositories
12. **Bookman Old Style** - Not found in Debian repositories
13. **Helvetica** - Not found, may need URW equivalents
14. **Calibri** - Microsoft font, not in Debian repositories
15. **Montserrat** - Not found in Debian repositories

## Conflict Analysis

### 🔴 Critical Conflicts (Will Break System)
- `console-setup` - Essential: yes package, cannot conflict
- `fonts-dejavu-core` - Core system font, removing breaks many applications
- `fonts-noto-core` - Required for emoji and CJK support

### ⚠️ Medium Conflicts (Manageable)
- `fonts-terminus` - Console font, can be replaced safely
- `fonts-liberation2` - Transitional package, depends on fonts-liberation

### ✅ No Conflicts
- All custom fonts (Fira Code, Hack, JetBrains Mono, etc.)
- TeX Gyre fonts
- Cantarell
- Atkinson Hyperlegible
- OpenDyslexic

## Recommendations for Remaining Fonts

### 1. Check Alternative Package Names
```bash
# Search for missing fonts with different naming
apt-cache search fonts | grep -i "iosevka\|source-code\|intel.*mono\|montserrat\|georgia"
apt-cache search fonts | grep -i "caslon\|baskerville\|bookman\|helvetica"
```

### 2. Check Multiverse/Contrib Repositories
Some fonts may be in non-free sections:
```bash
# Enable non-free repositories if not already enabled
sudo apt-add-repository non-free
sudo apt update
```

### 3. Consider Google Fonts Direct Download
For fonts like Montserrat, Georgia alternatives:
- Download directly from Google Fonts
- Package as part of roxieos-fonts
- Ensure proper licensing (OFL 1.1)

### 4. Commercial Fonts (Equity, Calibri, etc.)
- **Equity**: Commercial license required from Butterick
- **Calibri**: Microsoft proprietary, consider Carlito替代
- **Helvetica**: Use URW Nimbus Sans equivalents

### 5. Custom Builds Required
- **Iosevka**: Build from source (GitHub: be5invis/Iosevka)
- **Intel One Mono**: Download from Intel Open Source site
- **Atkinson Hyperlegible Mono**: Custom build from regular version

## Next Steps

1. **Immediate**: Complete source extraction for timed-out downloads
2. **Research**: Investigate alternative package names and repositories
3. **Direct Download**: Acquire fonts from official sources when not in Debian
4. **Custom Builds**: Set up build process for Iosevka and Intel One Mono
5. **Licensing Review**: Ensure all fonts have compatible licenses for redistribution

## File Structure
```
src-deb/
├── *.deb                    # 14 downloaded packages
├── fonts-firacode-6.2/      # Extracted source
├── fonts-hack-3.003/        # Extracted source
├── fonts-jetbrains-mono-2.304+ds/  # Extracted source
├── fonts-atkinson-hyperlegible-0.0~git20210430.1cb3116/  # Extracted source
├── fonts-opendyslexic-20160623/  # Extracted source
├── fonts-ebgaramond-0.016+git20210310.42d4f9f2/  # Extracted source
├── tex-gyre-20180621/       # Extracted source
└── fonts-cantarell-0.303.1/  # Extracted source
```

## Summary
- **Progress**: 14/23 fonts acquired (61%)
- **Immediate Issues**: 4 source extractions timed out
- **Major Challenge**: 9 fonts not available in Debian repositories
- **Conflict Strategy**: Focus on non-conflicting fonts first, handle system fonts separately

---
*Last Updated: 2025-11-26*
*Total Font Files Found: 71 TTF/OTF files*