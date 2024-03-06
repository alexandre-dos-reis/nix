{
  vars,
  pkgs,
  ...
}: let 
  inherit (pkgs.stdenv) isDarwin;
  inherit (vars) email fullname;
in {
  programs.git = {
    enable = true;

    userEmail = email;
    userName = fullname;

    aliases = {
      cm = "commit -m";
      st = "status";
      br = "branch ";
      co = "checkout";
      p = "push";
      l = "pull";
      hist = "log --pretty=format:\"%Cgreen%h %Creset%cd %Cblue[%cn] %Creset%s%C(yellow)%d%C(reset)\" --graph --date=relative --decorate";
    };
    extraConfig = {
      core = {
        ignorecase = false;
      };

      pager = {
        branch = false;
      };

      branch = {
        # When branching off a remote branch, automatically let the local branch track the remote branch
        autosetupmerge = true;
      };

      push = {
        # When pushing without giving a refspec, push the current branch to its upstream branch
        default = "simple";
        autoSetupRemote = true;
      };

      rerere = {
        # Enable the recording of resolved conflicts, so that identical hunks can be resolved automatically later on.
        enabled = true;
      };

      advice = {
        addIgnoredFile = false;
      };

      credential = {
        # https://www.reddit.com/r/NixOS/comments/qwu3d1/confused_about_git_gnomekeyring_and_libsecret/
        # https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage
        helper =
          if isDarwin
          then "osxkeychain"
          else "";
      };
    };
  };
}
