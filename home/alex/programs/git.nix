{
  pkgs,
  config,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;
  inherit (import ../constants.nix) email fullname editor flakeDir;
in {
  home.packages = with pkgs; [
    delta # https://github.com/dandavison/delta
  ];

  programs.git = {
    enable = true;
    settings = {
      core.editor = editor;
      core.ignorecase = false;
      core.pager = "delta";
      user.email = email;
      user.name = fullname;
      alias.hist = "log --pretty=format:\"%Cgreen%h %Creset%cd %Cblue[%cn] %Creset%s%C(yellow)%d%C(reset)\" --graph --date=relative --decorate";
      interactive.diffFilter = "delta --color-only";
      delta.navigate = true;
      delta.line-numbers = true;
      delta.side-by-side = true;
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      pager.branch = false;
      branch.autosetupmerge = true; # When branching off a remote branch, automatically let the local branch track the remote branch
      push.default = "simple"; # When pushing without giving a refspec, push the current branch to its upstream branch
      push.autoSetupRemote = true;
      rerere.enabled = true; # Enable the recording of resolved conflicts, so that identical hunks can be resolved automatically later on.
      advice.addIgnoredFile = false;
      # Renux rewrites settings.ini on every cd, and the [paths] group it writes
      # is a recent-folders cache. The filter keeps that group out of what git
      # stores, so the file stays tracked without a diff per cd. Bound to the
      # file by dotfiles/renux/.gitattributes.
      filter.renux-settings.clean = "${config.home.homeDirectory}/${flakeDir}/home/alex/dotfiles/renux/settings-clean.sh";
      # https://www.reddit.com/r/NixOS/comments/qwu3d1/confused_about_git_gnomekeyring_and_libsecret/
      # https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage
      credential.helper =
        if isDarwin
        then "osxkeychain"
        else "store";
    };
  };
}
