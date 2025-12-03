# FONTS

### Critical issues you must fix before the first build

1. **You cannot safely Conflict with `console-setup`**  
   `console-setup` is an Essential: yes package on Debian. Declaring `Conflicts: console-setup` will make `apt` refuse to install your package on any normal system and will break upgrades.  
   → Remove `console-setup` (and `keyboard-configuration`) from the Conflicts/Replaces list completely.  
   → Instead, ship your own `/etc/default/console-setup` as a conffile and have postinst run `setupcon --force`. This is the supported way.

2. **Do not purge 15–20 font packages in postinst with “apt-get purge -y …”**  
   That is extremely fragile (breaks on network loss, policy-rc.d, apt sandbox, etc.) and is forbidden by Debian Policy §7.2 for non-essential packages.  
   → The correct, policy-compliant way:  
     - Declare `Conflicts` + `Replaces` on the exact packages you want gone (fonts-dejavu-core, fonts-liberation2, fonts-texgyre, fonts-noto-core, etc.).  
     - Let `apt`/`dpkg` remove them automatically during install/upgrade.  
     - Do NOT call apt/dpkg from maintainer scripts to remove other packages.

3. **Do not overwrite Lat2-Terminus16.psf.gz directly**  
   That file is conffile-owned by the `console-setup` package. Overwriting it will generate dpkg conffile prompts or diverged conffiles.  
   → Ship your preferred console font under a different name (e.g. `RoxieOS-16.psf.gz`) and make `/etc/default/console-setup` point to it (`FONT=RoxieOS-16`). This is 100 % clean and upgrade-safe.

4. **fonts-noto-core is still needed for emoji and CJK in many apps**  
   Completely removing it will break Slack, Teams, VS Code webviews, many websites, etc.  
   → Either keep `fonts-noto-color-emoji` + `fonts-noto-cjk` (or the smaller `fonts-noto-ui-core`), or ship the few emoji you actually need inside your own package (Nerd Fonts already contain most Powerline + dev icons anyway).

5. **Missing break of circular dependency risk**  
   If you Conflict with `fonts-liberation2`, LibreOffice will still pull it in as a Recommends → hard dependency in Trixie.  
   → Add `Breaks: libreoffice-*` (or make your package Provide + Replace the exact font files LibreOffice expects) or simply keep Liberation2 as a very low-priority fallback instead of removing it outright.

### Minor polish recommendations

- Use `/usr/share/fonts/opentype/roxieos-fonts/` instead of truetype for the newer OTF/TTF variable fonts (Georgia, EB Garamond, etc.).
- Ship a 99-roxieos-defaults.conf that contains `<alias><family>monospace</family><prefer><family>FiraCode Nerd Font</family>…` with very high priority (e.g. priority 90) instead of trying to delete every other font.
- Include a README.roxieos-fonts.txt in `/usr/share/doc/roxieos-fonts/` that explains exactly what was replaced and how to revert (one-liner: `apt install --reinstall fonts-recommended console-setup`).

Once those are corrected, you can confidently start the first build and push `roxieos-fonts_1.0_all.deb` into your internal repo. Happy packaging!


### Part 1: Potential System Impact of Including the Default Console Font in the Package

Including Lat2-Terminus16.psf.gz (or a custom replacement for it) in the RoxieOS-fonts package poses minimal risk of breaking the system, as console fonts are modular bitmap files (PSF/PSFU format) that can be safely swapped without affecting core kernel or boot functionality. The Debian console-setup package is designed for this, allowing users to select from /usr/share/consolefonts/ via dpkg-reconfigure console-setup, and changes persist via /etc/default/console-setup. Community efforts, such as the upstream Terminus Font project (by Dimitar Kirov and contributors, hosted on GitHub and integrated into Debian's console-terminus package), have successfully replaced it for over a decade—e.g., Arch Linux and many Debian derivatives default to Terminus variants for better readability. Reddit threads (e.g., r/debian, r/linux4noobs) and Unix.SE discussions report thousands of users doing this routinely without issues, often praising Terminus for reduced eye strain.

Glyph problems are rare but possible: PSF fonts support only 256-512 glyphs (vs. Unicode's thousands), so custom conversions from TTF/OTF (e.g., your patched monospaced fonts) may lose accents, Cyrillic/Greek symbols, or box-drawing if not using PSFU (Unicode-mapped) variants. Boot issues can arise with large fonts (>16x32 pixels) on low-res framesbuffers, causing garbled text or initramfs failures (Debian Bug #908789 documents this on Atom hardware or with mismatched naming like heightxwidth vs. widthxheight). Framebuffer resets (e.g., by NVIDIA drivers disabling Nouveau) can revert fonts temporarily, per ArchWiki and Debian forums. However, these are proven resolvable: (1) Use the official kbd package's psfadd tool or terminus-font's build scripts to generate PSFU files with full Latin-2/Unicode mappings, ensuring 512 glyphs and compression (.gz) for boot efficiency—tested safe in LFS and Debian builds. (2) Add a postinst hook to run setupcon --force and update-initramfs -u, or kernel-param fbcon=font:YourCustom to lock it early; this handles systemd mismatches (Bug #759657) and has been user-verified on Reddit for persistent application across TTYs.

### Part 2: Updated Instructions for Creating the RoxieOS-fonts .deb Package

The goal is to produce one professionally structured Debian package (e.g., `roxieos-fonts_1.0_all.deb`) that can be installed or upgraded on any Debian Trixie workstation in the office, places all fonts in the correct system locations, registers them cleanly with fontconfig, forces replacements of default family aliases by conflicting with key packages, and can be revised and redeployed later without manual cleanup. This aggressive replacement ensures RoxieOS-fonts is the sole font provider where possible, purging or masking defaults during install for a "clean slate" (e.g., removing 20+ font packages to leave only essentials like fontconfig). Conflicts are deferred: the package installs successfully first, but attempting to add conflicting packages later (e.g., via apt install fonts-dejavu-core) will fail with an error like "roxieos-fonts 1.0 conflicts with fonts-dejavu-core," preventing breakage—users must remove RoxieOS-fonts to proceed, restoring defaults via dpkg-reconfigure console-setup or apt autoremove.

1. **Create a Proper Debian Packaging Skeleton**  
   Set up a standard Debian source package directory structure with the required control files (control, copyright, changelog, rules, etc.). Declare the package as architecture-independent (`all`). In control, add strict `Conflicts` and `Replaces` fields for these Trixie defaults: fonts-dejavu-core (monospace/serif fallback), fonts-liberation (Arial/Times equivalents), fonts-liberation2 (modern sans/serif), fonts-texgyre (Garamond/Palatino clones), fonts-noto-core (Unicode basics), fonts-cantarell (GNOME sans), fonts-ubuntu (Ubuntu sans), console-terminus (Terminus console), and console-setup (for PSF overrides). Recommend fontconfig and kbd for tools, but no hard depends. This forces apt to block those installs post-RoxieOS-fonts, with removal of RoxieOS-fonts required to resolve.

2. **Decide on Package Behavior Regarding Conflicts**  
   The package will aggressively replace defaults during install by purging conflicted packages (via prerm script) if present, ensuring RoxieOS-fonts dominates—e.g., removing fonts-dejavu-core et al. leaves no fallbacks, with your fonts as the only options in fontconfig aliases and console-setup. On Trixie (testing as of 2025), this targets ~15-20 bloat packages (full list via apt-cache search fonts | grep -E 'dejavu|liberation|noto|texgyre|cantarell|ubuntu|terminus|console'), minimizing to fontconfig alone for rendering. Conflicts only trigger later: if a user tries apt install fonts-noto-core, it aborts with a conflict notice, preserving the clean state; they must uninstall RoxieOS-fonts first, which auto-reinstalls defaults via postrm hooks.

3. **Collect Original Upstream Sources**  
   For every font in the list, download the original upstream release (not a third-party ZIP from a random site). This means:  
   - Nerd Fonts pre-patched releases for Fira Code, JetBrains Mono, Hack, Source Code Pro, and Iosevka (they already include ligatures and glyphs).  
   - Official Intel One Mono, OpenDyslexic Mono, and Atkinson Hyperlegible from their respective repositories.  
   - For variable-width fonts: use the TeX Gyre fonts (for Century Schoolbook, Palatino, etc.), EB Garamond, Adobe Source Serif Pro, Google Fonts releases (Georgia, Montserrat), and Microsoft core fonts (if legally allowed in your jurisdiction) or the high-quality Croscore/Liberation equivalents. For console (monospaced only), include Lat2-Terminus16.psf.gz as a fallback, but prioritize custom PSFU conversions.

4. **Patch the Remaining Fonts in a Reproducible Way**  
   For any monospaced font that does not already come from Nerd Fonts (e.g., Intel One Mono, Atkinson Hyperlegible Mono, OpenDyslexic Mono), run the official Nerd Fonts font-patcher script during the package build. Store the exact patcher version and a small wrapper script inside the debian/ directory so the build is 100% reproducible. Preserve original ligatures by using the “complete” or “symbols-only” preset as appropriate. For console PSF, use kbd's psfadd or terminus build tools to convert TTF to PSFU, ensuring Unicode glyphs; test for glyph loss (e.g., via showconsolefont) and include a variant matching Lat2-Terminus16's 512 glyphs.

5. **Standardize Naming and Organize Files**  
   Install all TrueType/OpenType files into `/usr/share/fonts/truetype/roxieos-fonts/` (create subdirectories if desired, e.g., `monospaced`, `serif`, `sans`). Install any console PSF versions (generated from the monospaced fonts) into `/usr/share/consolefonts/`, overwriting Lat2-Terminus16.psf.gz. Include a small metadata file for each font family declaring upstream source and license. In prerm, purge /usr/share/fonts/truetype/* from conflicted packages.

6. **Supply Fontconfig Configuration Files**  
   Ship ready-made configuration snippets in `debian/roxieos-fonts.fonts/` (or directly in `/etc/fonts/conf.d/` post-install) that:  
   - Raise the priority of your fonts for the generic families (`monospace`, `serif`, `sans-serif`).  
   - Add proper aliasing (e.g., make FiraCode Nerd Font the default monospace, TeX Gyre Schola the default serif, etc.).  
   - Optionally disable or lower the priority of any remaining defaults (e.g., post-purge Noto remnants) so they become fallbacks only.

7. **Add Post-Installation Hooks**  
   In the maintainer scripts (postinst):  
   - Purge conflicted packages (e.g., apt-get purge -y fonts-dejavu-core fonts-liberation etc.) if detected.  
   - Rebuild the font cache.  
   - Update the console setup if PSF fonts were installed (run setupcon --force; update-initramfs -u).  
   - Optionally restart running desktop environments (via dbus or a simple “restart your session” message) so that new defaults are picked up immediately. In postrm (on removal), reinstall defaults via apt-get install -y fonts-recommended console-setup.

8. **Handle Licenses and Copyright Properly**  
   Include a `debian/copyright` file that lists every upstream font, its exact version, license (OFL, Apache, MIT, etc.), and source URL. This is mandatory for policy compliance and for future audits.

9. **Build the Package Reproducibly**  
   Use a clean build environment (e.g., pbuilder, sbuild, or a Docker container with Debian Trixie) so that every build produces a byte-identical .deb when the sources are unchanged. Sign the package with your office GPG key if you maintain an internal apt repository. Test conflicts by simulating installs on a Trixie VM.

10. **Test the Resulting Package Thoroughly**  
    - Install on a fresh Debian Trixie VM → verify no broken dependencies, defaults purged, and only RoxieOS-fonts remains.  
    - Check that terminals, IDEs, LibreOffice, LaTeX, and browsers immediately use the new defaults.  
    - Confirm console (Ctrl-Alt-F3) shows a usable monospaced font with basic glyphs, no boot garble.  
    - Upgrade from an older version of your own package → verify smooth transition.  
    - Attempt post-install conflicts (e.g., apt install fonts-noto-core) → confirm abort and note in docs.

11. **Future Revisions**  
    When you want to change the font selection, simply update the source files in the packaging tree, bump the version number in `debian/changelog`, rebuild, and push the new .deb to your internal repository. All workstations receive the update via regular `apt upgrade`; on upgrade, it re-purges any re-added conflicts.

### Clean Monospaced Fonts

1. **Lat2-Terminus16** (Essential as it's Debian Console Font)  
   This should provide reliable glyphs for neovim in console as a fallback.

2. **Fira Code** (Estimated users: ~5-10 million; GitHub stars: 80k+)  
   Highly preferred for its innovative programming ligatures that improve code readability by combining characters (e.g., => becomes →), making it a favorite in modern IDEs like VS Code.

3. **Iosevka** (Estimated users: ~2-4 million; GitHub stars: ~18k)  
   Popular for its high customizability, allowing programmers to tweak spacing, weights, and styles, ideal for those who need a tailored font for long coding sessions.

4. **JetBrains Mono** (Estimated users: ~3-5 million; GitHub stars: ~17k)  
   Designed specifically for developers by JetBrains, it offers excellent legibility at small sizes, ligatures, and reduced eye strain, commonly used in IntelliJ and other professional tools.

5. **Hack** (Estimated users: ~2-3 million; GitHub stars: ~15k)  
   An open-source font optimized for source code, with clear distinctions between similar characters (like 0 and O), making it a reliable choice for cross-platform development.

6. **Source Code Pro** (Estimated users: ~1-2 million; GitHub stars: ~15k)  
   Adobe's clean, professional monospaced font with good spacing and readability, often chosen for UI environments and by designers who code.

### Special Monospaced Fonts

1. **OpenDyslexic Mono**  
   Tailored for dyslexia with weighted bottoms on letters to prevent flipping/rotation, monospaced for code alignment; helps reduce reading errors in programming without sacrificing functionality.

2. **Intel One Mono**  
   Developed with input from low-vision programmers, features enhanced character distinction and reduced eyestrain; ideal for visually impaired devs needing clear, fatigue-resistant text in code editors.

3. **Atkinson Hyperlegible Mono**  
   Designed for low-vision users with exaggerated forms for better letter recognition; monospaced version suits coding, improving scanability and accessibility in technical environments.

### Essential Variable-Width Fonts for Professional Printed Legal Documents

1. **Century Schoolbook**  
   Required by the US Supreme Court for briefs, offering exceptional readability with wide letterforms and high contrast, ideal for flowing legal texts in PDFs; imparts subtle authority in lawyer-facing documents due to its SCOTUS association.

2. **Times New Roman**  
   Ubiquitous serif in office environments, ensuring compatibility with incoming standard documents; its dense yet readable design supports professional flow in LaTeX-printed reports without visual disruption.

3. **Garamond**  
   Elegant serif with refined strokes for reduced eye strain in long printed passages; recommended in legal typography guides for its historical polish and smooth kerning in TIFF exports.

4. **Palatino**  
   Balanced serif with strong legibility at various sizes, favored for LaTeX compatibility; provides a professional edge in publishing contexts with its Renaissance-inspired flow.

5. **Georgia**  
   Serif optimized for print clarity with generous x-height; excels in office settings for mimicking book fonts while maintaining readability in dense legal paragraphs.

6. **Book Antiqua**  
   Serif similar to Palatino but with subtler refinements; utility in professional PDFs lies in its even spacing and adaptability to standard office tools for seamless integration.

7. **Caslon**  
   Historic serif with excellent letter spacing for narrative flow; adds extra sophistication for "font snob" peers in printed books or legal briefs, enhancing perceived quality.

8. **Baskerville**  
   Transitional serif with high contrast for impactful text; offers utility in legal documents through superior scanability on paper, reducing fatigue in extended reading.

9. **Equity**  
   Modern serif designed specifically for legal use (per Butterick); provides extra ligature control and readability tweaks for polished LaTeX outputs, critiqued but valued for utility in dense formats.

10. **Bookman Old Style**  
    Robust serif with wide proportions for clear distinction in printed lines; adds utility for office environments needing bold emphasis without sacrificing flow.

11. **Helvetica**  
    Clean sans-serif for headers in mixed layouts; its neutrality ensures professionalism in supplementary text, offering extra versatility for modern legal documents.

12. **Arial**  
    Reliable sans-serif for everyday compatibility; utility in printed TIFFs comes from crisp lines that blend with standard inputs, maintaining a no-frills professional aesthetic.

13. **Calibri**  
    Modern sans-serif default in Microsoft tools; enhances flow in office-printed reports with smooth curves, adding extra readability for variable-width transitions.

14. **Montserrat**  
    Geometric sans-serif with open forms; offers extra contemporary polish for legal summaries in PDFs, improving legibility in shorter, high-impact sections without overwhelming serifs.


