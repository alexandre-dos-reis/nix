{
  alex = {
    username = "alex";
    email = "ajm.dosreis.daponte@gmail.com";
    fullname = "Alexandre Dos Reis";
    # This is not the nix package name but rather the name installed on the system
    font = "Maple Mono NF";
    editor = "nvim";
    cursor = {
      pkgs = "bibata-cursors";
      theme = "Bibata-Modern-Ice";
      size = 32;
    };
    wallpapers = [];
    colors = {
      background = "#072329";
      cursor = "#708183";
      palette = builtins.fromJSON (builtins.readFile ./colors/palette.json);
    };
    # This allows to install npm packages globally with: `npm i -g <some-package>`
    # Not available in nixpkgs
    npm.packages.path = "~/.npm-packages";
    shellAliases = {
      v = "nvim";
      t = "tmux";
      ta = "tmux attach";
      tk = "tmux kill-session";
      ll = "exa -l -g --icons";
      lla = "ll --all";
      llt = "ll --tree";
      c = "clear";
      b = "bat -p";
      cs = "~/bin/cht.sh";
      d = "docker";
      dc = "docker compose";
      ff = "fzf --preview 'bat --style=numbers --color=always {}'";
      ffn = "ff | xargs nvim";
      s = "sudo env PATH=\"$PATH\"";
      k = "kubectl";
      kns = "kubens";
      kx = "kubectx";
    };
  };
}
