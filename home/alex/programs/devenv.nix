{
  pkgs,
  inputs,
  ...
}: let
  # Upstream flake, not nixpkgs: the nixpkgs build of devenv 2.3.1 links an
  # ABI-incompatible libghostty-vt, which aborts the interactive shell session
  # with "terminal error: invalid value".
  # https://github.com/NixOS/nixpkgs/issues/563507
  devenv = inputs.devenv.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  home.packages = [devenv];

  # Auto-activation: devenv ships its own shell hook, so no direnv/.envrc needed.
  # https://devenv.sh/auto-activation/
  #
  # The hook spawns a `devenv shell` when entering a directory containing a
  # devenv.nix, and exits it when leaving. Each project must be trusted once:
  #
  #   devenv allow      # from the project root
  #   devenv revoke     # to untrust it again
  #
  # Arguments for the spawned `devenv shell` go after `--`, e.g. `-- --quiet`.
  programs.fish.interactiveShellInit = ''
    ${devenv}/bin/devenv hook fish | source
  '';

  # Nushell loads anything in its autoload dir; generate the hook at build time
  # so it doesn't cost a subprocess on every shell start.
  xdg.configFile."nushell/autoload/devenv-hook.nu".source =
    pkgs.runCommand "devenv-hook.nu" {} ''
      ${devenv}/bin/devenv hook nu > $out
    '';
}
