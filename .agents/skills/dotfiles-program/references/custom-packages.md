# Updating custom packages

Use this reference only for local package expressions or overrides.

1. Inspect the current expression, callers, source version/hash, build inputs,
   wrappers and patches. Confirm the requested release and architecture from
   upstream release metadata, then obtain its source hash using Nix tooling.
   Never substitute a fabricated hash or keep a temporary placeholder as final.
2. Update the minimal source/version fields. Inspect upstream changes that may
   invalidate patches or runtime dependencies. A successful download does not
   establish compatibility.
3. Build the package itself where an output exists. Otherwise use the actual
   host package set/callPackage expression, preserving its overlays; do not test
   a different package set and claim that validates the installed package.
4. Evaluate affected host configurations and build their closure as appropriate.
   Runtime smoke testing requires the relevant environment; disclose when absent.

Current exceptions to inspect:

- `modules/features/apps/chatgpt.nix`: Debian archive, autoPatchelf, launcher wrapper and ASAR
  byte replacements. The replacement code checks unique matches and equal byte
  lengths. Preserve those checks; if upstream layout changes, inspect the new
  code and adapt or remove the workaround only with evidence. Do not merely
  disable the checks to make a new version build.
- `modules/features/desktop/waybar.nix`: Waybar override and custom workspace commands support the
  Hyprland Lua interface. Validate the pair when updating either side.
- `modules/hosts/ergo-laptop.nix`: wf-touch/hyprgrass overrides with compatibility
  comments. Keep plugin/compositor compatibility in view and do not drop an
  override merely because a newer upstream release exists.

This is a map of current exceptional workflows, not a frozen catalogue of versions.
Read the expressions for current values and revise this map when moving code.
