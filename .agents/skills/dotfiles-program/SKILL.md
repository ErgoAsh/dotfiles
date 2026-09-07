---
name: dotfiles-program
description: Add, remove, or update programs in this NixOS dotfiles repository, including Home Manager configuration, desktop integrations and custom Nix packages. Use for program lifecycle tasks; not for unrelated hardware changes or a whole-repository architecture migration.
---

# Manage a dotfiles program

## Establish the change

Read the repository's AGENTS.md and follow the current import graph. Determine
the requested program, operation, configuration needs and affected hosts.
Preserve unrelated working-tree changes. Ask about host scope only when the
answer changes the implementation and cannot be inferred from the request.
The user prefers stable. Keep existing exceptions; explain a need for a new one.
Editing and validation are the default; switch only on the user's request.

Search for both package attributes and runtime names: a desktop ID, executable,
window class and package name may differ. Trace package declarations, program
modules, services, wrappers, MIME defaults, shell aliases, autostart, shortcuts
and workspace rules. Inspect actual files rather than assuming every integration
is present or needed. Installation does not imply adding autostart or a shortcut.

## Add

- Verify package and option availability in the locked inputs, using evaluation
  or source inspection. A current online package search does not prove availability
  at the repository's pinned revision.
- Use the owning Home Manager program module when it manages the requested
  configuration; otherwise add a user package. System services and drivers belong
  in NixOS. Avoid duplicate installation when a program module already adds it.
- Shared imports affect both hosts. For a host-only request use its existing
  extension point; avoid unrelated restructuring to accommodate one package.
- Add only requested or necessary configuration and integrations. Preserve the
  repository's Hyprland Lua helpers when touching bindings or window rules.

## Remove

- Remove installation and program-specific configuration within the requested
  host scope. Check remaining references, including desktop defaults and commands.
- Keep dependencies still used elsewhere and shared configuration needed by the
  other host. Do not assume a package with a similar name is a private dependency.
- Removing a program declaration does not authorize deleting its personal data,
  secrets, old generations or running garbage collection. Explain any retained
  integration that cannot be resolved without a user preference.

## Update

- Determine whether this means configuration changes, a custom package version,
  or an input update. Updating nixpkgs can affect many packages; there is no
  promise that changing a lock input updates only the named program.
- For a locked-input update, select only necessary inputs and review the lock
  diff; use `nix flake update INPUT` instead of an unqualified fleet update.
  Consider compatibility between nixpkgs and the Home Manager release.
- For custom packaging, read [references/custom-packages.md](references/custom-packages.md).
- For a configuration migration, consult upstream documentation for the version
  actually used. Preserve stateVersion and unrelated settings.

## Validate and report

Use the validation commands in AGENTS.md. Format changed Nix files, evaluate
affected hosts and build the changed package/system when needed. Ensure newly
created files are visible to the Git flake before drawing conclusions from checks.
Distinguish parse, evaluation, build and runtime checks. If access, network or
cache restrictions prevent a check, report that limitation rather than weakening
configuration or claiming success.

Review the final diff and remaining references. Report source/version changes,
affected hosts, integrations, checks actually completed and activation status.
Documentation changes should describe user-visible effects when relevant.

Edit the owning module in `modules/features/` and its explicit profile or host
selection when scope changes. A file discovered by import-tree defines a feature;
it does not enable that feature for every host. Keep NixOS and Home Manager parts
of one program together when they form one user-facing feature.
