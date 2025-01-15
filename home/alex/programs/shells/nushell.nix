{
  utils,
  pkgs,
  user,
  inputs,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;
in {
  programs.nushell = {
    enable = true;

    extraConfig = ''
      source ${inputs.nu-scripts}/custom-completions/git/git-completions.nu

      def gcm [message: string] {
          git commit --message ($message)
      }

      def gst [] {
          git status
      }

      extern "ga" [
        ...file: string@"nu-complete git add"               # file to add
        --all(-A)                                           # add all files
        --dry-run(-n)                                       # don't actually add the file(s), just show if they exist and/or will be ignored
        --edit(-e)                                          # open the diff vs. the index in an editor and let the user edit it
        --force(-f)                                         # allow adding otherwise ignored files
        --interactive(-i)                                   # add modified contents in the working tree interactively to the index
        --patch(-p)                                         # interactively choose hunks to stage
        --verbose(-v)                                       # be verbose
      ]

      export extern "gco" [
        ...targets: string@"nu-complete git checkout"   # name of the branch or files to checkout
        --conflict: string                              # conflict style (merge or diff3)
        --detach(-d)                                    # detach HEAD at named commit
        --force(-f)                                     # force checkout (throw away local modifications)
        --guess                                         # second guess 'git checkout <no-such-branch>' (default)
        --ignore-other-worktrees                        # do not check if another worktree is holding the given ref
        --ignore-skip-worktree-bits                     # do not limit pathspecs to sparse entries only
        --merge(-m)                                     # perform a 3-way merge with the new branch
        --orphan: string                                # new unparented branch
        --ours(-2)                                      # checkout our version for unmerged files
        --overlay                                       # use overlay mode (default)
        --overwrite-ignore                              # update ignored files (default)
        --patch(-p)                                     # select hunks interactively
        --pathspec-from-file: string                    # read pathspec from file
        --progress                                      # force progress reporting
        --quiet(-q)                                     # suppress progress reporting
        --recurse-submodules                            # control recursive updating of submodules
        --theirs(-3)                                    # checkout their version for unmerged files
        --track(-t)                                     # set upstream info for new branch
        -b                                              # create and checkout a new branch
        -B: string                                      # create/reset and checkout a branch
        -l                                              # create reflog for new branch
      ]

      $env.PROMPT_INDICATOR_VI_NORMAL = "n "
      $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = "n "
      $env.PROMPT_INDICATOR_VI_INSERT = "> "
      $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = "> "

      $env.config.show_banner = false
      $env.config.buffer_editor = "nvim"
      $env.config.edit_mode = "vi"
    '';

    shellAliases = {
      v = "nvim";
      t = "tmux";
      ta = "tmux attach";
      tk = "tmux kill-session";
      ll = "ls -l";
      lla = "ls -la";
      c = "clear";
      b = "bat -p";
      cs = "~/bin/cht.sh";
      d = "docker";
      dcp = "docker compose";
      ff = "fzf --preview 'bat --style=numbers --color=always {}'";
      ffn = "ff | xargs nvim";
      s = "sudo env PATH=\"$PATH\"";
      k = "kubectl";
      kns = "kubens";
      kx = "kubectx";

      # git
      # gst = "git status";
      # ga = "git add";
      # gcm = "git commit --all --message";
      # gco = "git checkout";
      # gcb = "git checkout -b";
      # gp = "git push";
      # gl = "git pull";
    };
  };
}
